UtilTest = {}

function UtilTest:new()
    local obj = ObjectDescriptor:new()

    function obj:init()
        obj.name = "UtilTest"
    end

    obj:init()

    function obj:testIsFunction()
        local assert = Assert:new()

        local fn = function() return "abc" end
        local expected = true
        local candidate = Util:new():isFunction(fn)

        return assert:equals(expected, candidate)
    end

    function obj:testIsFunctionWithNoFn()
        local assert = Assert:new()

        local expected = false
        local candidate = Util:new():isFunction(nil)

        return assert:equals(expected, candidate)
    end

    function obj:testTableContainsTable()
        local assert = Assert:new()

        local t1 = { "ab", "cd", "ef" }
        local t2 = { "ab", "cd" }
        local expected = true

        local candidate = Util:new():table1ContainsTable2(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTableContainsTableNot()
        local assert = Assert:new()

        local t1 = { "ab", "cd", "ef" }
        local t2 = { "ab", "cd", "ef", "gh" }
        local expected = false

        local candidate = Util:new():table1ContainsTable2(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTableContainsTableNot()
        local assert = Assert:new()

        local t1 = { "abc", "cde", "efg" }
        local t2 = { "abc", "cde", "efg", "hij" }
        local expected = false

        local candidate = Util:new():table1ContainsTable2(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTableKeys1ContainsTableKeys2()
        local assert = Assert:new()

        local t1 = { toString = "abc", getName = "def", setName = "gij" }
        local t2 = { toString = "abc", getName = "def", setName = "gij" }
        local expected = true
        local candidate = Util:new():tableKeys1ContainsTableKeys2(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTableKeys1ContainsTableKeys2Not()
        local assert = Assert:new()

        local t1 = { toString = "abc", getName = "def", setName = "gij" }
        local t2 = { toString = "abc", getName = "def", setGame = "gij" }
        local expected = false
        local candidate = Util:new():tableKeys1ContainsTableKeys2(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTableKeys1ContainsTableKeys2WithLessKeys()
        local assert = Assert:new()

        local t1 = { toString = "abc", getName = "def", setName = "gij" }
        local t2 = { toString = "abc", getName = "def" }
        local expected = true
        local candidate = Util:new():tableKeys1ContainsTableKeys2(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTableKeys1ContainsTableKeys2NotWithMoreKeys()
        local assert = Assert:new()

        local t1 = { toString = "abc", getName = "def" }
        local t2 = { toString = "abc", getName = "def", setName = "gij" }
        local expected = false
        local candidate = Util:new():tableKeys1ContainsTableKeys2(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testIsAllDef()
        local assert = Assert:new()

        local expected = true
        local candidate = Util:new():isAllDef("", 1, function() return true end)

        return assert:equals(expected, candidate)
    end

    function obj:testIsAllDefNot()
        local assert = Assert:new()

        local fn1 = nil
        local expected = false
        local candidate = Util:new():isAllDef("", fn1, function() return true end)

        return assert:equals(expected, candidate)
    end

    function obj:testTablesEqual()
        local assert = Assert:new()

        local t1 = {}
        t1.a = "1"
        t1.b = "2"
        t1.c = "3"
        local t2 = {}
        t2.a = "1"
        t2.b = "2"
        t2.c = "3"
        local expected = true
        local candidate = Util:new():tablesEqual(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTablesEqualNotWithDifferentKeys()
        local assert = Assert:new()

        local t1 = {}
        t1.a = "1"
        t1.b = "2"
        t1.c = "3"
        local t2 = {}
        t2.a = "1"
        t2.b = "2"
        t2.d = "3"
        local expected = false
        local candidate = Util:new():tablesEqual(t1, t2)

        return assert:equals(expected, candidate)
    end

    function obj:testTablesEqualNotWithDifferentValues()
        local assert = Assert:new()

        local t1 = {}
        t1.a = "1"
        t1.b = "2"
        t1.c = "3"
        local t2 = {}
        t2.a = "1"
        t2.b = "2"
        t2.c = "10"
        local expected = false
        local candidate = Util:new():tablesEqual(t1, t2)

        return assert:equals(expected, candidate)
    end

    return obj
end
