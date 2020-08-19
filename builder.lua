-------------
-- BUILDER --
-------------

--[[
This is a custom build script that combines all the files here 
into a single lua file, for easier distribution.
It looks for two keywords: return and require

RETURN
It looks for module level returns, which is always the last return in a
file
Identifies the name of the symbol returned

REQUIRE
It looks for require statements. It builds a dependency graph from those.
The graph should be a DAG, so it can be topologically sorted 
and thus composed into a single file.
Note: LUA already freaks out to circular import, 
so it is kinda guaranteed to be a DAG since the code runs.


CHECKS:
- dep graph should be DAG
- requires should not rename (imported symbol name should match the original in the source)

If both checks succeed, it can easily remove requires and returns and splice the files together.

]]

local lfs = require"lfs"


function findReturn(file)
    local ret = nil
    for l in io.lines(file) do
        local exp = l:match("return (%w+)$")
        if exp then
            ret = exp
        end
    end
    return ret
end

function findImports(file)
    local imports = {}
    for l in io.lines(file) do
        if l:match("require") then
            local as, name = l:match("(%w+) = require%(\"(%w+)\"%),?$")
            if not (as and name) then
                print("GODDAMN ERROR")
                print("INVALID REQUIRE")
                print(("IN FILE \"%s\""):format(file))
                print(l)
                os.exit()
            end
            imports[#imports + 1] = {name, as}
        end
    end
    return imports
end

function topsort(G)
    local Gc = {}
    local found = {}
    while next(G)~=nil do
        for n, edges in pairs(G) do
            local f = true
            for _, e in pairs(edges) do
                if not found[e[1]] then
                    f = false
                end
            end
            if f then
                found[n:match("^(%w+)%.lua$")] = true
                Gc[#Gc + 1] = {n, G[n]}
                G[n] = nil
            end
        end
    end

    return Gc
end


-- write the file except last return and imports
-- add alias if necessery
function build(file, aliases, returns)
    local name = file[1]
    local f = ""
    f = f .. "-- *** BUILDER: SECTION START ***\n"
    f = f .. ("-- *** THIS SECTION IS SOURCED FROM FILE \"%s\" ***\n"):format(name)
    f = f .. "\n\n"
    for l in io.lines(file[1]) do
        local written = false
        if not (l:match("require")) then
            if not (l:match("return") and l:match(returns[name])) then
                f = f .. l .. "\n"
                written = true
            end
        elseif not l:match("local") then
            f = f .. ("-- *** BUILDER: CHANGED ***\n-- ORIGINAL: \"%s\"\n"):format(l)
            local as, from, sep = l:match("(%w+) = require%(\"(%w+)\"%)(,?)")
            f = f .. ("%s = %s%s\n"):format(as, returns[from..".lua"], sep or "")
            written = true
        end
        if not written then
            f = f .. ("-- *** BUILDER: REMOVED ***\n-- %s\n"):format(l)
        end
    end
    f = f .. "\n"
    if aliases[name:match("^(%w+)%.lua$")] then
        f = f .. "-- *** BUILDER: SETTING IMPORT ALIAS ***\n"
        f = f .. ("local %s = %s\n"):format(aliases[name:match("^(%w+)%.lua$")], returns[name])
        f = f .. "\n"
    end
    f = f .. "\n"
    return f
end

-- iterate over all lua files in this directory, except itself
local G = {}
local returns = {}
for file in lfs.dir"." do

	if file~="." and file~=".." and file~="builder.lua" and file ~= "bundle.lua" then
		if file:match("%.lua$") then
		    local name = file:match("^(%w+)%.lua$")
            local exp = findReturn(file)
            returns[file] = exp
            G[file] = findImports(file)
	    end
	end
end


local aliases = {}
for _, imports in pairs(G) do
    for _, i in ipairs(imports) do
        local from, as = i[1], i[2]
        if returns[from..".lua"]~=as then
            if aliases[from] and aliases[from]~=as then
                print("Error!")
                print(("File '%s' is imported as multiple aliases!"):format(from))
                print(("%s vs %s"):format(aliases[from], as))
                print(("Note: importing it as %s does not count here"):format(from))
                os.exit(-1)
            end
            aliases[from] = as
        end
    end
end

G = topsort(G)


local BUNDLE = "-- *** BUILDER: START OF FILE ***\n"
BUNDLE = BUNDLE .. "-- THIS IS AN AUTO-GENERATED FILE\n"
BUNDLE = BUNDLE .. "-- BUILT FROM THE DIFFERENT FILES OF YALG\n"
BUNDLE = BUNDLE .. "-- BY AN AUTOMATIC BUILD TOOL\n"
BUNDLE = BUNDLE .. "-- DO NOT EDIT THIS FILE DIRECTLY!\n"
BUNDLE = BUNDLE .. "--\n"
BUNDLE = BUNDLE .. os.date"-- TIMESTAMP: %Y. %B %d. %X\n"

local c = assert(io.popen('git log --format="%H" -n 1', 'r'), "Error: can't run git")
local h = assert(c:read("*a"):match("%w+"), "Error: git shown no output!!")
c:close()
BUNDLE = BUNDLE .. ("-- LATEST COMMIT HASH: %s\n\n\n"):format(h)

for _, n in ipairs(G) do
    BUNDLE = BUNDLE .. build(n, aliases, returns)
end
BUNDLE = BUNDLE .. "-- *** BUILDER: RETURN ***\n"
BUNDLE = BUNDLE .. ("return %s\n\n"):format(returns[G[#G][1]])

BUNDLE = BUNDLE .. "-- *** BUILDER: END OF FILE ***"

local output = io.open("bundle.lua", "w")
output:write(BUNDLE)
output:close()