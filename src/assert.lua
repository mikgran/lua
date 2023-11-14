Assert = {}

function Assert:new(context)
    local obj = TestUtil:new() -- ObjectDescriptor:getName(), TestUtil:newResult()

    function obj:init(ctx)
        obj.name = "Assert"
        local util = Util:new()
        self.isAllTables = util.isAllTables
        self.tablesEqual = util.tablesEqual
    end

    obj:init(context)

    function obj:equals(expected, candidate)
        if self:isAllTables(expected, candidate) then
            return obj:assertTablesEqual(expected, candidate)
        end

        local message = ""
        local state = false
        if expected == candidate then
            message = "were equal"
            state = true
        else
            message = "not equal"
            state = false
        end

        return obj:newResult("", message, expected, candidate, state)
    end

    function obj:assertTablesEqual(expected, candidate)
        local message = "were equal"
        local state = true
        if #expected ~= #candidate or (not obj:tablesEqual(expected, candidate)) then
            message = "not equal"
            state = false
        end

        return obj:newResult("", message, expected, candidate, state)
    end

    function obj:notEquals(expected, candidate)
        if self:isAllTables(expected, candidate) then
            return not obj:tablesEqual(expected, candidate)
        end

        local message = ""
        local state = false
        if expected ~= candidate then
            message = "not equal"
            state = true
        else
            message = "were equal"
            state = false
        end
        return obj:newResult("", message, expected, candidate, state)
    end

    return obj
end
