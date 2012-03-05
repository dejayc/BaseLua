--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua" )
local BaseConfig = require( BaseLua.package.BaseConfig )

context( "BaseConfig", function()

-------------------------------------------------------------------------------
    context( "init", function()
-------------------------------------------------------------------------------

        test(
"Invoked with values",
        function()
            local config = BaseConfig:new()
            local values = {}

            config:init( values )
            assert_equal( values, config.values )
        end )

        test(
"Invoked with values and defaultValues",
        function()
            local config = BaseConfig:new()
            local values = {}
            local defaultValues = {}

            config:init( values, defaultValues )
            assert_equal( values, config.values )
            assert_equal( defaultValues, config.defaultValues )
        end )

    end )

    context( "getValue", function()

        test(
"Value:missing Default:disabled, missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_nil( config:getValue( false, "control" ) )
        end )

        test(
"Value:missing Default:disabled, exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_nil( config:getValue( false, "status" ) )
        end )

        test(
"Value:exists Default:disabled, exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( "test", config:getValue( false, "name" ) )
        end )

        test(
"Value:exists Default:disabled, missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( 5, config:getValue( false, "value" ) )
        end )

        test(
"Value:missing Default:enabled, missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_nil( config:getValue( true, "control" ) )
        end )

        test(
"Value:missing Default:enabled, exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( "pass", config:getValue( true, "status" ) )
        end )

        test(
"Value:exists Default:enabled, missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( 5, config:getValue( true, "value" ) )
        end )

        test(
"Value:exists Default:enabled, exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( "test", config:getValue( true, "name" ) )
        end )

        test(
"Value:exists, nested",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", tests = { test = 1 } }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( 1, config:getValue( true, "tests", "test" ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "setValue", function()
-------------------------------------------------------------------------------

        test(
"Test condition",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", tests = { test = 1 } }
            local defaultValues = { }

            config:init( values, defaultValues )
            assert_equal( "test", config:getValue( false, "name" ) )
            config:setValue( "qa", "name" )
            assert_equal( "qa", config:getValue( false, "name" ) )
        end )

        test(
"Test condition",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", tests = { test = 1 } }
            local defaultValues = { }

            config:init( values, defaultValues )
            assert_equal( 1, config:getValue( false, "tests", "test" ) )
            config:setValue( 2, "tests", "test" )
            assert_equal( 2, config:getValue( false, "tests", "test" ) )
        end )

        test(
--   -- { tests = { control = { flag = 4 } } }
"Test condition",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", tests = { test = 1 } }
            local defaultValues = { }

            config:init( values, defaultValues )
            config:setValue( 4, "tests", "control", "flag" )
            assert_equal(
                4, config:getValue( false, "tests", "control", "flag" ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "hasValue", function()
-------------------------------------------------------------------------------

        test(
"Value:missing Default: missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_false( config:hasValue( "control" ) )
        end )

        test(
"Value:missing Default: exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_false( config:hasValue( "status" ) )
        end )

        test(
"Value:exists Default: exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_true( config:hasValue( "name" ) )
        end )

        test(
"Value:exists Default: missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_true( config:hasValue( "value" ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "getDefaultValue", function()
-------------------------------------------------------------------------------

        test(
"Value:missing Default:missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_nil( config:getDefaultValue( "control" ) )
        end )

        test(
"Value:missing Default:exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( "pass", config:getDefaultValue( "status" ) )
        end )

        test(
"Value:exists Default:missing",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_nil( config:getDefaultValue( "value" ) )
        end )

        test(
"Value:exists Default:exists",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", value = 5 }
            local defaultValues = { name = "defaultTest", status = "pass" }

            config:init( values, defaultValues )
            assert_equal( "defaultTest", config:getDefaultValue( "name" ) )
        end )

        test(
"Default:exists, nested",
        function()
            local config = BaseConfig:new()
            local values = { name = "test", tests = { test = 1 } }
            local defaultValues = { events = { event = 2 } }

            config:init( values, defaultValues )
            assert_equal( 2, config:getDefaultValue( "events", "event" ) )
        end ) 

    end )

end )
