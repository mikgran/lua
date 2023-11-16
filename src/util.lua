Util = {}
--[[
        Use with delegation
            - avoids crowding global
            - avoids crowding the class using the Util
        local util =  Util:new()
        self.isEmptyStr = util.isEmptyStr
        self.isFunction = util.isFunction
        self.isUnDef = util.isUnDef
        self.isString = util.isString
        self.isNumber = util.isNumber
    ]]
--
function Util:new()
    local obj = {} -- no circular references with nothing inherited

    function obj:setOptions()
        crawl.setopt("pickup_mode = multi")
        crawl.setopt("message_colour += mute:Okay")
        crawl.setopt("message_colour += mute:Read which item")
        crawl.setopt("message_colour += mute:Search for what")
        crawl.setopt("message_colour += mute:Can't find anything")
        crawl.setopt("message_colour += mute:Drop what")
        crawl.setopt("message_colour += mute:Use which ability")
        crawl.setopt("message_colour += mute:Read which item")
        crawl.setopt("message_colour += mute:Drink which item")
        crawl.setopt("message_colour += mute:not good enough")
        crawl.setopt("message_colour += mute:Attack whom")
        crawl.setopt("message_colour += mute:move target cursor")
        crawl.setopt("message_colour += mute:Aim:")
        crawl.setopt("message_colour += mute:You reach to attack")
        crawl.setopt("message_colour += mute:No target in view!")

        -- crawl.enable_more(false)
    end

    function obj:unsetOptions()
        crawl.setopt("pickup_mode = auto")
        crawl.setopt("message_colour -= mute:Okay")
        crawl.setopt("message_colour -= mute:Search for what")
        crawl.setopt("message_colour -= mute:Can't find anything")
        crawl.setopt("message_colour -= mute:Drop what")
        crawl.setopt("message_colour -= mute:Use which ability")
        crawl.setopt("message_colour -= mute:Read which item")
        crawl.setopt("message_colour -= mute:Drink which item")
        crawl.setopt("message_colour -= mute:not good enough")
        crawl.setopt("message_colour -= mute:Attack whom")
        crawl.setopt("message_colour -= mute:move target cursor")
        crawl.setopt("message_colour -= mute:Aim:")
        crawl.setopt("message_colour -= mute:You reach to attack")
        crawl.setopt("message_colour -= mute:No target in view!")

        -- crawl.enable_more(true)
    end

    function obj:isAllDef(...) return obj:isAll(function(o) return o ~= nil end, ...) end

    function obj:isAllTables(...) return obj:isAll(function(o) return obj:isTable(o) end, ...) end

    function obj:isAll(fn, ...)
        local allDef = true
        for i = 1, select('#', ...) do
            if not fn(select(i, ...)) then
                allDef = false
                break
            end
        end
        return allDef
    end

    function obj:isUnDef(o) return (o == nil) end

    function obj:isDef(o) return (o ~= nil) end

    function obj:isEmptyStr(o) return (o == nil or o == "") end

    function obj:eq(a, b)
        local s = obj
        local isEqual = false
        if s:isDef(a) and s:isDef(b) and a == b then
            isEqual = true
        end
        return isEqual
    end

    function obj:isFunction(o) return (o ~= nil and type(o) == "function") end

    function obj:isTable(o) return (o ~= nil and type(o) == "table") end

    function obj:isString(o) return (o ~= nil and type(o) == "string") end

    function obj:isNumber(o) return (o ~= nil and type(o) == "number") end

    -- unrecursive shallow testing: no table compares
    -- every key in t1 must be found in t2 and they must return same the value
    function obj:tablesEqual(t1, t2)
        local returnValue = false
        if obj:isAllTables(t1, t2) and #t1 == #t2 then
            returnValue = true
            for i, v in pairs(t1) do
                if t1[i] ~= t2[i] then -- every key found in both tables and they return same values
                    returnValue = false
                    break
                end
            end
        end
        return returnValue
    end

    -- unrecursive shallow testing: no table compares
    -- t2 must be a subset of t1, both unordered
    -- every key in t2 must be found in t1 and they must return same the value
    function obj:table1ContainsTable2(t1, t2)
        local foundAll = false

        if obj:isAllTables(t1, t2) and #t2 <= #t1 then
            foundAll = true
            for i2, v2 in pairs(t2) do
                if t1[i2] ~= t2[i2] then -- found all keys in table2 pointing to same values in both tables
                    foundAll = false
                    break
                end
            end
        end
        return foundAll
    end

    -- unrecursive shallow testing: no table compares
    -- t2 keys must be a subset of t1 keys, both unordered
    -- no value comparison
    function obj:tableKeys1ContainsTableKeys2(t1, t2)
        local foundAll = false

        if obj:isAllTables(t1, t2) and #t2 <= #t1 then
            foundAll = true
            for i2, _ in pairs(t2) do
                local found = false
                for i1, _ in pairs(t1) do
                    if i2 == i1 then
                        found = true
                        break
                    end
                end

                foundAll = foundAll and found
                if not foundAll then
                    break
                end
            end
        end
        return foundAll
    end

    return obj
end

-- global functions

if not mpr then
    mpr = function(msg, color)
        if not color then
            color = "white"
        end
        crawl.mpr("<" .. color .. ">" .. msg .. "</" .. color .. ">")
    end
end

-- shamelessly borrowed from the net
if not dump then
    dump = function(o)
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
end

-- shamelessly borrowed from the net
if not tprint then
    tprint = function(t, s)
        for k, v in pairs(t) do
            local kfmt = '["' .. tostring(k) .. '"]'
            if type(k) ~= 'string' then
                kfmt = '[' .. k .. ']'
            end

            local vfmt = '"' .. tostring(v) .. '"'
            if type(v) == 'table' then
                tprint(v, (s or '') .. kfmt)
            else
                if type(v) ~= 'string' then
                    vfmt = tostring(v)
                end
                mpr(type(t) .. (s or '') .. kfmt .. ' = ' .. vfmt)
            end
        end
    end
end

if not tableAdd then
    tableAdd = function(t, o)
        if t ~= nil and type(t) == "table" then
            t[#t + 1] = o
        end
    end
end
if not tableFilter then
    tableFilter = function(t, p)
        local results = {}
        if t ~= nil and type(t) == "table" and p ~= nil and type(p) == "function" then
            for k, v in pairs(t) do
                if p(k, v) then
                    results[#results + 1] = v
                end
            end
        end
        return results
    end
end
if not tableForEach then
    tableForEach = function(t, fn)
        if t ~= nil and type(t) == "table" and fn ~= nil and type(fn) == "function" then
            for k, v in pairs(t) do
                fn(k, v)
            end
        end
    end
end

-- shamelessly borrowed from the net
if not stripLetters then
    stripLetters = function(str)
        local result = ""
        if str ~= nil and type(str) == "string" then
            for i = 1, #str do
                local c = str:sub(i, i)
                if c:match("^%-?%d+$") then
                    result = result .. c
                end
            end
        end
        return result
    end
end

if not split then
    split = function(str, sep)
        local r = {}
        if str ~= nil and type(str) == "string" and sep ~= nil and type(sep) == "string" then
            local regex = ("([^%s]+)"):format(sep)
            for o in str:gmatch(regex) do
                r[#r + 1] = o
            end
        end
        return r
    end
end

if not splitByChunk then
    splitByChunk = function(text, chunkSize)
        local s = {}
        if text ~= nil and type(text) == "string" and chunkSize ~= nil and type(chunkSize) == "number" then
            for i = 1, #text, chunkSize do
                s[#s + 1] = text:sub(i, i + chunkSize - 1)
            end
        end
        return s
    end
end

if not trim then
    trim = function(s)
        if type(s) == "string" then
            return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
        else
            return s
        end
    end
end

if not mpre then
    mpre = function(v)
        if (v ~= nil and type(v) == "table") then
            for key, value in pairs(table) do
                mpr(dump("key: " .. key))
                mpr(dump("value " .. value))
            end
        else
            mpr(dump("value: " .. v))
        end
    end
end
