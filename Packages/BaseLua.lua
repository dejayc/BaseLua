--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- BaseLua global configuration and convenience methods.

module "BaseLua"
-------------------------------------------------------------------------------
--]]

--- BaseLua class fields.
-- @class table
-- @name BaseLua
-- @field PACKAGE_PATH_SEPARATOR Indicates the character that separates Lua
--   nested package paths that appear in invocations to the Lua "require"
--   function.  Statically assigned the value "."
-- @field PACKAGE_NAME_PATTERN The Lua pattern that can be used to identify
--   the package name in nested package paths that appear in invocations to
--   the Lua "require" function.
-- @field PACKAGE_PATH_PATTERN The Lua pattern that can be used to identify
--   the leading paths in nested package paths that appear in invocations to
--   the Lua "require" function.
CLASS = {}

CLASS.PACKAGE_PATH_SEPARATOR = "."

CLASS.PACKAGE_NAME_PATTERN = string.format(
    "^.*%%%s(.-)$", CLASS.PACKAGE_PATH_SEPARATOR )

CLASS.PACKAGE_PATH_PATTERN = string.format(
    "^(.*%%%s).-$", CLASS.PACKAGE_PATH_SEPARATOR )

local _, _, packageName = string.find( ..., CLASS.PACKAGE_NAME_PATTERN )
local _, _, packagePath = string.find( ..., CLASS.PACKAGE_PATH_PATTERN )
packageName = packageName or "BaseLua"
packagePath = packagePath or ""

--- BaseLua package helper that facilitates working with BaseLua packages.
-- @class table
-- @name package 
-- @field name The package name for this BaseLua class.  Usually should be
--   'BaseLua', unless the file name of this class has been changed.
-- @field path The package path for all BaseLua classes.
-- @field PACKAGE_NAME An invocation of package that contains a child index
--   other than "name" or "path" will return the child index appended to the
--   package path.  Replace "PACKAGE_NAME" with the name of the package to
--   return.
-- @Usage: BaseLua.package.BaseClass -- Classes.BaseClass
CLASS.package = setmetatable(
    {
        name = packageName,
        path = packagePath,
    },
    {
        __index = function( t, index )
            return ( packagePath or "" ) .. index
        end,
    }
)

--- Prints the provided parameters via 'print', formatted according to the
-- specified format, following the formatting convention of 'string.format'.
-- Automatically prints an end-of-line character following the string.
-- @name printf
-- @param format The 'string.format' formatting convention to apply to the
-- provided parameters.
-- @param ... Optional parameters to format according to the specified format.
-- @usage printf( "Hello, %s!", "world" )
function CLASS.printf( format, ... )
    print( string.format( format, ... ) )
end

--- Writes the provided parameters via 'io.write', formatted according to the
-- specified format, following the formatting convention of 'string.format'.
-- Does not automatically print an end-of-line character following the string.
-- @name writef
-- @param format The 'string.format' formatting convention to apply to the
-- provided parameters.
-- @param ... Optional parameters to format according to the specified format.
-- @usage writef( "Hello, %s!", "world" )
function CLASS.writef( format, ... )
    io.write( string.format( format, ... ) )
end

-- Update the global loaded package table so that future invocations of the
-- Lua function 'require' can retrieve this class without knowing the path to
-- this class.
package.loaded[ packageName ] = CLASS

return CLASS
