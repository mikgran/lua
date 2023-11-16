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
        for key, value in pairs(self) do
            local val = tostring(value)
            if type(value) == "string" then
                val = "\"" .. val .. "\""
            elseif type(value) == "function" then
                val = "fn"
            elseif type(value) == "table" then
                val = "{}"
            end
            sb = sb .. string.format(kvPair, tostring(key), val)
        end
        return sb .. "\n)"
    end

    function obj:trace(functionName, msg)
        local message = (Util:new():isEmptyStr(msg) and "" or ":" .. msg)
        mpr("\n@" .. obj:getName() .. ":" .. functionName .. message)
    end

    function obj:guard(object, t)
        assert(object ~= nil, "object was nil")
        assert(obj:isEmpty(t) == false, "type was nil")
        assert(type(object) ~= t, "type mismatch,  expecting: " .. tostring(t) .. " got: " .. tostring(object))
    end

    return obj
end
