Ready = {}

function Ready:new()
    local obj = {}

    function obj:importFiles()
        local imports = { "Consts.lua",
            "Util.lua",
            "UtilTest.lua",
            "ObjectDescriptor.lua",
            "ObjectDescriptorTest.lua",
            "Opt.lua",
            "OptTest.lua",
            "Assert.lua",
            "AssertTest.lua",
            "TestResult.lua",
            "TestRunner.lua",
            "TestUtil.lua",
            "CharacterDefaults.lua",
            "Exp.lua",
            "ExpTest.lua" }

        for _, name in ipairs(imports) do
            dofile("src/" .. name)
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
        saveCharDefaults = charDef.saveCharDefaults
        loadCharDefaults = charDef.loadCharDefaults
        charDef:setDefaults()
    end

    return obj
end

local ready = Ready:new()
ready:importFiles()
ready:setup()
