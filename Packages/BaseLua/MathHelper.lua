--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing math manipulation.

module "MathHelper"
-------------------------------------------------------------------------------
--]]

local CLASS = {}

--- Returns the simply rounded representation of the specified number.
-- @name roundNumber
-- @param number The number to round.
-- @param decimalPlaces The number of decimal places to which to round
-- the specified number.  Defaults to 0.
-- @return The simply rounded representation of the specified number.
-- @usage roundNumber( 98.4 ) -- 98
-- @usage roundNumber( 98.6 ) -- 99
-- @usage roundNumber( 98.625, 1 ) -- 98.6
-- @usage roundNumber( 98.625, 2 ) -- 98.63
-- @see http://lua-users.org/wiki/SimpleRound
function CLASS.roundNumber( number, decimalPlaces )
    local multiplier = 10^( decimalPlaces or 0 )
    return math.floor( number * multiplier + 0.5 ) / multiplier
end

return CLASS
