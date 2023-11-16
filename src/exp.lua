Exp = {}

function Exp:of(expChart)
    local obj = ObjectDescriptor:new()

    function obj:init()
        local util = Util:new()
        obj.isEmptyStr = util.isEmptyStr
        obj.name = "Exp"
        obj.skills = Opt:of {}
        obj.weaponSkills = Consts.weaponSkills
        obj.rangedSkills = Consts.rangedSkills
        obj.otherSkills = Consts.otherSkills
    end

    function obj:dump()
        obj.skills:dump()
    end

    function obj:parseSkill(line, name)
        Opt:
            of(line):
            flatMap(function(k, v) return splitByChunk(split(v, "|")[2], 3) end):
            map(function(k, v) return trim(v) end):
            with(function(v) obj.skills:set(name, v) end)
    end

    function obj:parseSkills(chart)
        local lines = Opt:of {}

        Opt:
            of(chart):
            flatMap(function(_, all) return split(all, "\n") end):
            with(function(table) lines:use(table) end)

        Opt:
            of(obj.otherSkills):
            forEach(function(k, skillName)
                lines:
                    filter(function(_, line) return string.find(line, skillName) end):
                    forEach(function(_, line) obj:parseSkill(line, skillName) end)
            end)
    end

    obj:init()
    obj:parseSkills(expChart)

    function obj:get(skillName)
        return obj.skills:get()[skillName]
    end

    return obj
end
