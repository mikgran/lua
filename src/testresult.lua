TestResult = {} -- no inheritance, skip circular dependencies

function TestResult:new(tstName, message, expected, candidate, state)
    local obj = ObjectDescriptor:new()

    function obj:init(tn, m, e, c, s)
        obj.name = "TestResult"
        obj.testName = tn or ""
        obj.message = m
        obj.expected = e
        obj.candidate = c
        obj.state = s or false
    end

    obj:init(tstName, message, expected, candidate, state)

    function obj:setTestName(newTestName)
        obj.testName = newTestName or ""
    end

    function obj:toStr(o)
        if type(o) == 'table' then
            local s = '{ '
            for k, v in pairs(o) do
                if type(k) ~= 'number' then k = '"' .. k .. '"' end
                s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
            end
            return s .. '} '
        else
            return tostring(o)
        end
    end

    function obj:tostring()
        local toString = string.format("%5s: %s", (obj.state and "OK" or "Fail"), obj.testName)
        if obj.state then
            return toString
        else
            return toString ..
                string.format("\n       expected:\n       %s\n       got:\n       %s", obj:toStr(obj.expected),
                    obj:toStr(obj.candidate))
        end
    end

    return obj
end
