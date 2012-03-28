--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

    All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- The base class for classes that inspect and manipulate configurations.

module "BaseConfig"
-------------------------------------------------------------------------------
--]]

local BaseLua = require( "BaseLua" )

local ClassHelper = require( BaseLua.package.ClassHelper )
local DataHelper = require( BaseLua.package.DataHelper )
local TableHelper = require( BaseLua.package.TableHelper )

local CLASS = ClassHelper.autoclass( ClassHelper.getPackagePath( ... ) )

--- Initializes the configuration with the specified values and default
-- values.
-- @name init
-- @param values The values with which to initialize the configuration.
-- @param defaultValues The optional default values with which to initialize
-- the configuration.
function CLASS:init( values, defaultValues )
    self.values = values
    self.defaultValues = defaultValues
end

--- Returns the value of the specified configuration setting, optionally
-- returning a default value if the specified configuration setting is
-- missing.
-- @name getValue
-- @param useDefault True if a default value should be returned if the
-- specified configuration setting is missing.
-- @param ... A list of configuration setting names, with each name
--   representing a step deeper into the hierarchy of nested configuration
--   settings.
-- @return The value of the specified configuration setting, if it exists;
--   otherwise, the default value, if it exists and default values have been
--   specified to be returned.
-- @usage init( { name = "test", tests = { test = 1 } }, { status = "pass" } )
-- @usage getValue( false, "name" ) -- "test"
-- @usage getValue( false, "tests", "test" ) -- 1
-- @usage getValue( false, "status" ) -- nil
-- @usage getValue( true, "status" ) -- "pass"
-- @see getDefaultValue
-- @see setDefaultValue
-- @see setValue
-- @see TableHelper.getByIndex
function CLASS:getValue( useDefault, ... )
    local value = TableHelper.getByIndex( self.values, ... )

    if ( value == nil and ( useDefault or useDefault == nil ) ) then
        value = self:getDefaultValue( ... )
    end

    return value
end

--- Sets the value of the specified configuration setting.
-- @name setValue
-- @param value The value to set for the specified configuratino setting.
-- @param ... A list of configuration setting names, with each name
--   representing a step deeper into the hierarchy of nested configuration
--   settings.
-- @return The new value of the specified configuration setting.
-- @usage init( { name = "test", tests = { test = 1 } } )
-- @usage setValue( "qa", "name" ) -- { name = "qa" }
-- @usage setValue( 2, "tests", "test" ) -- { test = 2 }
-- @usage setValue( 4, "tests", "control", "flag" )
--   -- { tests = { control = { flag = 4 } } }
-- @see getDefaultValue
-- @see setValue
-- @see TableHelper.setByIndex
function CLASS:setValue( value, ... )
    TableHelper.setByIndex( value, self.values, ... )
end

--- Indicates whether the specified configuration setting exists and has a
-- value other than empty string.
-- @name hasValue
-- @param ... A list of configuration setting names, with each name
--   representing a step deeper into the hierarchy of nested configuration
--   settings.
-- @return True if the specified configuration setting exists and has a value
--   other than empty string; otherwise, false.
-- @usage init( { name = "test", tests = { test = 1 } }, { status = "pass" } )
-- @usage hasValue( "name" ) -- true
-- @usage hasValue( "tests", "test" ) -- true
-- @usage hasValue( "status" ) -- false
-- @see getValue
-- @see DataHelper.hasValue
function CLASS:hasValue( ... )
    return DataHelper.hasValue( self:getValue( false, ... ) )
end

--- Returns the default value of the specified configuration setting, if it
-- exists.
-- @name getDefaultValue
-- @param ... A list of configuration setting names, with each name
--   representing a step deeper into the hierarchy of nested configuration
--   settings.
-- @return The default value of the specified configuration setting, if it
--   exists; otherwise, nil.
-- @usage init( { name = "test", tests = { test = 1 } }, { status = "pass" } )
-- @usage getDefaultValue( "name" ) -- nil
-- @usage getDefaultValue( "status" ) -- "pass"
-- @see getValue
-- @see setValue
-- @see TableHelper.getByIndex
function CLASS:getDefaultValue( ... )
    return TableHelper.getByIndex( self.defaultValues, ... )
end

return CLASS
