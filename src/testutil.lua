TestUtil = {}

function TestUtil:new()
    local obj = ObjectDescriptor:new()

    function obj:init()
        obj.name = "TestUtil"
    end

    obj:init()

    function obj:newResult(tstName, message, candidate, expected, state)
        return TestResult:new(tstName, message, candidate, expected, state)
    end

    return obj
end
