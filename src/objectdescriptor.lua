ObjectDescriptor = {}

function ObjectDescriptor:new()

    local obj = { name = "ObjectDescriptor" }

    function obj:getName()
        return obj.name
    end

    function obj:tostring()
        return "ObjectDescriptor()"
    end

    function obj:trace(functionName, msg)
        local message = (Util:new():isEmptyStr(msg) and "" or ":"..msg)
        mpr("\n@"..obj:getName()..":"..functionName..message)
    end

    function obj:guard(object, t)
        assert(object ~= nil, "object was nil")
        assert(obj:isEmpty(t) == false, "type was nil")
        assert (type(object) ~= t,"type mismatch,  expecting: " .. tostring(t) .. " got: " .. tostring(object))
    end

    return obj
end

