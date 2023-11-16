ObjectDescriptor = {}

function ObjectDescriptor:new()
    local obj = {}

    function obj:init()
        obj.name = "ObjectDescriptor"
    end

    obj:init()
    function obj:getName()
        return obj.name
    end

    function obj:tostring()
        local addToTable = function(tbl, key, val)
            tbl[#tbl + 1] = string.format("\n  %s: %s", tostring(key), val)
        end
        local sbcat = function(sb, tbl)
            local s = sb
            for _, v in pairs(tbl) do
                s = s .. v
            end
            return s
        end

        local name = obj:getName() or ""
        local sb = name .. "\n("
        local kvProperties = {}
        local kvFunctions = {}
        local kvTables = {}
        for key, value in pairs(self) do
            if type(value) == "string" then
                addToTable(kvProperties, key, "\"" .. tostring(value) .. "\"")
            elseif type(value) == "function" then
                addToTable(kvFunctions, key, "fn")
            elseif type(value) == "table" then
                addToTable(kvTables, key, "{ }")
            end
        end
        table.sort(kvProperties)
        table.sort(kvFunctions)
        table.sort(kvTables)
        sb = sbcat(sb, kvProperties)
        sb = sbcat(sb, kvFunctions)
        sb = sbcat(sb, kvTables)
        return sb .. "\n)"
    end

    function obj:trace(functionName, msg)
        local message = (Util:new():isEmptyStr(msg) and "" or ":" .. msg)
        mpr("\n@" .. obj:getName() .. ":" .. functionName .. message)
    end

    function obj:guard(object, t)
        assert(object ~= nil, "object was nil")
        assert(t ~= nil, "type was nil")
        assert(type(object) ~= t, "type mismatch,  expecting: " .. tostring(t) .. " got: " .. tostring(object))
    end

    return obj
end
