CharacterDefaults = {}

function CharacterDefaults:new()
    local obj = {}

    function obj:init()
        obj.weaponSkills = Consts.weaponSkills
        obj.rangedSkills = Consts.rangedSkills
        obj.otherSkills = Consts.otherSkills
        obj.skillGlyphs = { [1] = "+", [2] = "*" }
        obj.chdat = nil
        obj.loadAttempted = false
    end

    obj:init()

    function obj:skillMessage(prefix, skill, skillType, value)
        local msg = ""

        if prefix then
            msg = prefix .. ";"
        end

        if skillType then
            msg = msg .. skillType .. "(" .. skill .. "):" .. value
        else
            msg = msg .. skill .. ":" .. value
        end

        return msg
    end

    function obj:saveSkills(skills)
        for _, sk in ipairs(skills) do
            if you.train_skill(sk) > 0 then
                obj.chdat["" .. sk] = you.train_skill(sk)
                obj.chdat["" .. sk .. "target"] = you.get_training_target("" .. sk)
            end
        end
    end

    function obj:loadSkills(weapons)
        for _, sk in ipairs(weapons) do
            if obj.chdat[sk] then
                you.train_skill(sk, obj.chdat["" .. sk])
                you.set_training_target(sk, obj.chdat["" .. sk .. "target"])
            else
                you.train_skill(sk, 0)
            end
        end
    end

    function obj:saveCharDefaults(quiet)
        obj:updateCharCombo()
        if you.class() == "Wanderer" then
            return
        end

        if not c_persist.charDefaults then
            c_persist.charDefaults = {}
        end
        c_persist.charDefaults[obj.charCombo] = {}
        obj.chdat = c_persist.charDefaults[obj.charCombo]

        obj:saveSkills(obj.weaponSkills)
        obj:saveSkills(obj.rangedSkills)
        obj:saveSkills(obj.otherSkills)

        tprint(obj.chdat)

        if not quiet then
            mpr("Saved default for " .. obj.charCombo)
        end
    end

    function obj:hasDefaults()
        return you.class() ~= "Wanderer"
            and c_persist.charDefaults ~= nil
            and c_persist.charDefaults[obj.charCombo] ~= nil
    end

    function obj:updateCharCombo()
        obj.charCombo = you.race() .. you.class()
    end

    function obj:loadCharDefaults(quiet)
        obj:updateCharCombo()
        if not obj:hasDefaults() then
            return
        end

        obj.chdat = c_persist.charDefaults[obj.charCombo]

        obj:loadSkills(obj.weaponSkills)
        obj:loadSkills(obj.rangedSkills)
        obj:loadSkills(obj.otherSkills)

        if not quiet then
            mpr("Loaded defaults for " .. obj.charCombo)
        end
    end

    function obj:setDefaults(quiet)
        obj:updateCharCombo()
        if you.turns() ~= 0 then
            return
        end

        if not obj.loadAttempted then
            obj:loadCharDefaults(quiet)
            obj.loadAttempted = true
        end
    end

    function obj:mydofile()
        dofile("CharacterDefaults.lua")
    end

    return obj
end
