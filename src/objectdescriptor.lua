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
        local name = obj:getName() or ""
        local sb = name .. "\n("
        local kvPair = "\n  %s: %s"
        local kvProperties = {}
        local kvFunctions = {}
        local kvTables = {}
        for key, value in pairs(self) do
            local val = tostring(value)
            if type(value) == "string" then
                val = "\"" .. val .. "\""
                kvProperties[#kvProperties + 1] = string.format(kvPair, tostring(key), val)
            elseif type(value) == "function" then
                val = "fn"
                kvFunctions[#kvFunctions + 1] = string.format(kvPair, tostring(key), val)
            elseif type(value) == "table" then
                val = "{ }"
                kvTables[#kvTables + 1] = string.format(kvPair, tostring(key), val)
            end
        end
        table.sort(kvProperties)
        table.sort(kvFunctions)
        table.sort(kvTables)
        for _, value in pairs(kvProperties) do
            sb = sb .. value
        end
        for _, value in pairs(kvFunctions) do
            sb = sb .. value
        end
        for _, value in pairs(kvTables) do
            sb = sb .. value
        end
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
