--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing function manipulation.

module "FunctionHelper"
-------------------------------------------------------------------------------
--]]

local BaseLua = require( "BaseLua" )
local TableHelper = require( BaseLua.package.TableHelper )

local CLASS = {}

--- Returns a memoized version of the specified function, using an optionally
-- specified index function to create a memoization index from the parameters
-- that are passed to invocations of the memoized function.  The memoized
-- function will expose a "__forget" method that can be used to clear all
-- memoized results.
-- @name memoize
-- @param fn The function to memoize
-- @param fnIndex An optional function to create a memoization index from the
-- parameters that are passed to invocations of the memoized function.
-- @return The memoized version of the specified function.
-- @usage sub = memoize( function( a, b ) return a - b end )
-- @usage sub:__forget()
-- @usage add = memoize(
--   function( a, b ) return a + b end, function( a, b ) return a + b end )
-- @see http://lua-users.org/wiki/FuncTables
function CLASS.memoize( fn, fnIndex )
    fnIndex = fnIndex or function ( ... )
        local key = ""
        for i = 1, table.getn( arg ) do
            key = key .. "[" .. tostring( arg[ i ] ) .. "]"
        end
        return key 
    end

    local object = {
        __call  = function( targetTable, ... )
            local key = fnIndex( ... )
            local values = targetTable.__memoized[ key ]

            if ( values == nil ) then
                values = TableHelper.pack( fn( ... ) )
                targetTable.__memoized[ key ] = values
            end

            if ( table.getn( values ) > 0 ) then
                return unpack( values )
            end

            return
        end,
        __forget = function( self ) self.__memoized = {} end,
        __memoized = {},
        __mode = "v",
    }

    return setmetatable( object, object )
end

return CLASS
