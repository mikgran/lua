Opt = {}

function Opt:of(val)
    local obj = ObjectDescriptor:new()

    function obj:use(o)
        if obj:isTable(o) and obj:isDef(o.name) and o.name == "Opt" then
            obj:use(o:get())
        elseif obj:isTable(o) then
            obj.tbl = o
        elseif obj:isDef(o) then
            obj.tbl = { o }
        else
            obj.tbl = {}
        end

        return self
    end

    function obj:init(o)
        self.name = "Opt"
        local util = Util:new()
        self.isEmptyStr = util.isEmptyStr
        self.isFunction = util.isFunction
        self.isDef = util.isDef
        self.isUnDef = util.isUnDef
        self.isTable = util.isTable
    end

    obj:init(val)
    obj:use(val)

    function obj:size()
        return #obj.tbl
    end

    function obj:set(k, v)
        if k ~= nil and v ~= nil then
            obj.tbl[k] = v
        end
        return self
    end

    function obj:add(o)
        if o ~= nil then
            obj.tbl[#obj.tbl + 1] = o
        end
        return self
    end

    function obj:map(fn)
        local allResults = {}
        local isResults = false
        if fn ~= nil and type(fn) == "function" then
            for k, v in pairs(obj.tbl) do
                local result = fn(k, v)
                if result then
                    allResults[#allResults + 1] = result
                    isResults = true
                end
            end
        end
        if isResults then
            return Opt:of(allResults)
        else
            return Opt:of(obj:get())
        end
    end

    function obj:forEach(forEachFunction)
        if forEachFunction ~= nil and type(forEachFunction) == "function" then
            for key, value in pairs(obj.tbl) do
                forEachFunction(key, value)
            end
        end
        return self
    end

    function obj:filter(predicate)
        local results = {}
        if predicate == nil or type(predicate) ~= "function" then -- no op in malformed call
            results = obj:get()
        else
            for k, v in pairs(obj.tbl) do
                if predicate(k, v) then
                    results[k] = v
                end
            end
        end
        return Opt:of(results)
    end

    -- cost of malformed "code" is an unintelligent error message
    function obj:mapc(code)
        local returnValue = {}
        local isResults = false
        if (not self:isEmptyStr(code)) then
            local codeString = string.format("return function(k, v) %s end", code) -- two return calls
            local function1 = loadstring(codeString)()                             -- function() return function() return %s end end
            setfenv(function1, getfenv())
            returnValue = obj:map(function1)
            isResults = true
        end
        if isResults then
            return Opt:of(returnValue)
        else
            return Opt:of(obj:get())
        end
    end

    function obj:get()
        local size = 0
        local firstKey = nil
        for key, value in pairs(obj.tbl) do
            size = size + 1
            if size == 1 then
                firstKey = key
            end
            if size >= 2 then
                break
            end
        end
        if size >= 2 then
            return obj.tbl
        else
            return obj.tbl[firstKey]
        end
    end

    function obj:with(function1)
        local results = nil
        if function1 ~= nil and type(function1) == "function" then
            results = function1(obj.tbl)
        end
        return Opt:of(results)
    end

    function obj:flatMap(function1)
        local results = {}
        local isResults = false
        if function1 ~= nil and type(function1) == "function" then
            for k, v in pairs(obj.tbl) do
                local c = function1(k, v)
                if c ~= nil and type(c) == "table" then
                    for _, v2 in pairs(c) do
                        results[#results + 1] = v2
                        isResults = true
                    end
                else
                    results[#results + 1] = v
                    isResults = true
                end
            end
        end
        if isResults then
            return Opt:of(results)
        else
            return Opt:of(obj:get())
        end
    end

    function obj:dump()
        mpr(dump(obj.tbl))
        return self
    end

    -- keeps existing keys
    function obj:addAll(table)
        if table ~= nil and type(table) then
            for key, value in pairs(table) do
                obj.tbl[#obj.tbl + 1] = value
            end
        end
        return self
    end

    return obj
end
