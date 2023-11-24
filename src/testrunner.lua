TestRunner = {}

function TestRunner:run(table, filter)
    local obj = ObjectDescriptor:new()

    function obj:init(tbl, ftr)
        obj.name = "TestRunner"
        if type(tbl) == "table" then
            obj.tests = tbl
        else
            obj.tests = { tbl }
        end
        obj.filter = ftr
    end

    obj:init(table, filter)

    function obj:runSuite()
        local results = Opt:of {}
        local resultMessages = Opt:of {}
        local successes = 0
        resultMessages:add("\nTest suites: " .. #obj.tests)
        if (obj.filter) then
            resultMessages:add("\nFilter: " .. obj.filter)
        end

        Opt:of(obj.tests):
            forEach(function(_, testClass)
                resultMessages:add("\n\nSuite: " .. testClass:getName() .. "\n")

                Opt:of(testClass):
                    filter(function(key, value)
                        local keyFound = string.find(key, "test")
                        if (obj.filter) then
                            keyFound = keyFound and string.find(key, obj.filter)
                        end
                        return keyFound
                    end):
                    forEach(function(fnName, fn)
                        local r = fn()
                        r:setTestName(fnName or "")
                        results:add(r)
                        resultMessages:add("\n" .. r.tostring())
                        if r.state then successes = successes + 1 end
                    end)
            end)

        local message = ""
        resultMessages:forEach(function(k, v) message = message .. v end)
        mpr(message)
        mpr(string.format("\n\nTotal tests run: %s, ok: %s, failed: %s", results:size(), successes,
            results:size() - successes))
    end

    obj:runSuite()

    return obj
end
