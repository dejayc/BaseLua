--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing data manipulation.

module "DataHelper"
-------------------------------------------------------------------------------
--]]

local CLASS = {}

--- Returns the first non-nil value from the specified list of values.
-- @name getNonNil
-- @param ... A list of values to search for the first non-nil value.
-- @return The first non-nil value.
-- @usage getNonNil( nil, 5, nil ) -- 5
-- @usage getNonNil( "Hi", nil, 3 ) -- "Hi"
function CLASS.getNonNil( ... )
    for i = 1, table.getn( arg ) do
        local value = arg[ i ]
        if ( value ~= nil ) then return value end
    end
end

--- Indicates whether the specified target value is not nil and is not an
-- empty string.
-- @name hasValue
-- @param value The target value to evaluate.
-- @return True if the specified target value is not nil and is not an empty
-- string; otherwise, false.
-- @usage hasValue( nil ) -- false
-- @usage hasValue( 5 ) -- true
-- @usage hasValue( "" ) -- false
-- @usage hasValue( " " ) -- true
function CLASS.hasValue( value )
    return value ~= nil and value ~= ""
end

--- Returns the specified target value if the specified boolean test parameter
-- is true; otherwise, returns the specified default value.
-- @name ifThenElse
-- @param _if The boolean test parameter that determines whether the target
-- value or default value is to be returned; true if the target value is to be
-- returned, false if the default value is to be returned.
-- @param _then The target value to be returned if the specified boolean test
-- parameter is true.
-- @param _else The default value to be returned if the specified boolean
-- test parameter is false.
-- @return The specified target value if the specified boolean test parameter
-- is true; otherwise, the specified default value.
-- @usage ifThenElse( true, 1, 0 ) -- 1
-- @usage x = 3; y = 9; ifThenElse( x > y, x, y ) -- 9
function CLASS.ifThenElse( _if, _then, _else )
    if ( _if ) then return _then end
    return _else
end

return CLASS
