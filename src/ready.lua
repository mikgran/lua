Ready = {}

function Ready:new()
    local obj = {}

    function obj:importFiles()
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
        _G.saveCharDefaults = charDef.saveCharDefaults
        _G.loadCharDefaults = charDef.loadCharDefaults
        charDef:setDefaults()
    end

    return obj
end

local ready = Ready:new()
ready:importFiles()
ready:setup()
