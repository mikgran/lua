ObjectDescriptorTest = {}

function ObjectDescriptorTest:new()
    local obj = {}

    function obj:init()
        obj.name = "ObjectDescriptorTest"
    end

    obj:init()

    function obj:getName() -- not provided since obj = {}, thus copy of it here
        return obj.name
    end

    function obj:testGetName()
        local Assert = Assert:new()
        local sn = "str"
        local newoo = function()
            local oo = ObjectDescriptor:new()
            oo.name = sn
            return oo
        end
        local expected = sn
        local candidate = newoo():getName()

        return Assert:equals(expected, candidate)
    end

    return obj
end
