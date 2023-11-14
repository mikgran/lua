OptTest = {}

function OptTest:new()
    local obj = ObjectDescriptor:new()

    function obj:init()
        obj.name = "OptTest"
        obj.assert = Assert:new()
    end

    obj:init()

    function obj:testMap()
        local str = "111222"
        local expected = str .. str

        Opt:
            of(str):
            map(function(k, v) return v .. v end):
            with(function(v)
                candidate = v[1]
            end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testMapValueWithNilFunction()
        local str = "111222"
        local expected = str
        local candidate = nil

        Opt:
            of(str):
            map():
            with(function(v)
                candidate = v[1]
            end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testMapValueWithNotAFunction()
        local str = "111222"
        local expected = str
        local candidate = nil

        Opt:
            of(str):
            map("ssss"):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testMapNilValue()
        local str = nil
        local expected = nil
        local candidate = nil

        Opt:
            of(str):
            map(function(k, v) return v .. v end):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(tostring(expected), tostring(candidate))
    end

    function obj:testMapc()
        local str = "abc"
        local expected = str .. str
        local candidate = nil

        Opt:
            of(str):
            mapc("return v..v"):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testMapcWithNilFunction()
        local str = "abc"
        local expected = str
        local candidate = nil

        Opt:
            of(str):
            mapc():
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testMapcWithNilValue()
        local str = nil
        local expected = nil
        local candidate = nil

        Opt:
            of(str):
            mapc("return it"):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testUse()
        local str = "abc"
        local expected = "cde"
        local candidate = nil

        Opt:
            of(str):
            use("cde"):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testUseWithNil()
        local str = "abc"
        local expected = nil
        local candidate = nil

        Opt:
            of(str):
            use(nil):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testUse2()
        local expected = "abc"
        local candidate = nil

        Opt:
            of(nil):
            use("abc"):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testFilter()
        local str = "abc"
        local expected = str
        local candidate = nil

        Opt:
            of(str):
            filter(function(k, v) return type(v) == "string" end):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testFilter2()
        local str = "abc"
        local expected = nil
        local candidate = nil

        Opt:
            of(str):
            filter(function(k, v) return (type(v) == "function") end):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testFilter3()
        local str = nil
        local expected = nil
        local candidate = nil

        Opt:
            of(str):
            filter(function(k, v) return type(v) == "function" end):
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testFilterWithNilPredicate()
        local str = "abc"
        local expected = "abc"
        local candidate = nil

        Opt:
            of(str):
            filter():
            with(function(v) candidate = v[1] end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testForEachWithSimpleValue()
        local str = "abc"
        local expected = "abc"
        local candidate = ""

        Opt:
            of(str):
            forEach(function(k, v) candidate = candidate .. v end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testForEachWithTable()
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3" }
        local candidate = Opt:of {}

        Opt:
            of(strs):
            forEach(function(k, v) candidate:add(v) end)

        return obj.assert:equals(expected, candidate:get())
    end

    function obj:testWith()
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3" }
        local candidate = {}

        Opt:
            of(strs):
            with(function(tbl) candidate = tbl end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testFlatMap()
        local strs = { "1,2,3" }
        local expected = { "1", "2", "3" }
        local candidate = {}

        Opt:
            of(strs):
            flatMap(function(k, v) return split(v, ",") end):
            forEach(function(k, v) candidate[#candidate + 1] = v end)

        return obj.assert:equals(expected, candidate)
    end

    function obj:testAddAll()
        local strs = { "1", "2", "3" }
        local expected = { "1", "2", "3", "1", "2", "3" }
        local candidate = nil

        Opt:
            of(strs):
            addAll({ "1", "2", "3" }):
            with(function(tbl) candidate = tbl end)

        return obj.assert:equals(expected, candidate)
    end

    return obj
end
