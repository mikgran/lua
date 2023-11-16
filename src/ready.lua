Ready = {}

function Ready:new()
    local obj = {}

    function obj:setDEV()
        if not crawl then
            obj.DCSS = false
        else
            obj.DCSS = true
        end
    end

    obj:setDEV()

    function obj:isDEV()
        return not obj.DCSS
    end

    function obj:importGlobals()
        if obj:isDEV() then
            you = {}
            function you.turns() return 0 end

            function you.race() return "" end

            function you.class() return "" end

            crawl = {}
            function crawl.mpr(s) print(s) end

            function crawl.setopt(s) end

            c_persist = {}
        end
    end

    function obj:importFiles()
        local dir = nil
        if obj:isDEV() then
            dir = ""
        else
            dir = "src/"
        end

        local imports = { "consts.lua",
            "util.lua",
            "utiltest.lua",
            "objectdescriptor.lua",
            "objectdescriptorTest.lua",
            "opt.lua",
            "opttest.lua",
            "assert.lua",
            "asserttest.lua",
            "testresult.lua",
            "testrunner.lua",
            "testutil.lua",
            "characterdefaults.lua",
            "exp.lua",
            "exptest.lua" }

        for _, name in ipairs(imports) do
            dofile(dir .. name)
        end
    end

    function obj:setup()
        local tests =
        {
            OptTest:new(),
            AssertTest:new(),
            UtilTest:new(),
            ObjectDescriptorTest:new(),
            ExpTest:new()
        }

        local testFilter = nil
        -- testFilter = "testAddAll"
        TestRunner:run(tests, testFilter)

        Util:new():setOptions()

        local charDef = CharacterDefaults:new()
        _G.saveCharDefaults = charDef.saveCharDefaults
        _G.loadCharDefaults = charDef.loadCharDefaults
        charDef:setDefaults()
    end

    return obj
end

local ready = Ready:new()
ready:importGlobals()
ready:importFiles()
ready:setup()
