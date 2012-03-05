--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing string manipulation.

module "StringHelper"
-------------------------------------------------------------------------------
--]]

local CLASS = {}

--- Indicates whether two strings are identical, optionally ignoring case and
-- safely handling nil values.  If either object is not nil and is not a
-- string, returns false.
-- @name compareString
-- @param target The first string to compare.
-- @param compareTo The second string to compare.
-- @param ignoreCase Determines whether case is ignored during comparison.
-- @return True if both strings are nil or are equal; false otherwise.
-- @usage compareString( nil, nil ) -- true
-- @usage compareString( "Hi", "hi" ) -- false
-- @usage compareString( "Hi", "hi", true ) -- true
-- @usage s = {}; compareString( s, s ) -- false
function CLASS.compareString( target, compareTo, ignoreCase )
    if ( target == nil and compareTo == nil ) then return true end

    if ( type( target ) ~= "string" ) then return false end
    if ( type( compareTo ) ~= "string" ) then return false end

    if ( target == compareTo ) then return true end
    if ( not ignoreCase ) then return false end

    return target:upper() == compareTo:upper()
end

--- Indicates whether the specified target string ends with the specified
-- suffix string, optionally ignoring case and safely handling nil values.  If
-- either object is not nil and is not a string, returns false.
-- @name endsWith
-- @param target The target string to be examined for whether it ends with the
-- specified suffix string.
-- @param suffix The string to be looked for at the end of the target string.
-- @param ignoreCase Determines whether case is ignored during evaluation.
-- @return True if both strings are nil, or if the specified target string
-- ends with the specified suffix string, or if the specified suffix string is
-- an empty string; false otherwise.
-- @usage endsWith( nil, nil ) -- true
-- @usage endsWith( "Hi there", "Here" ) -- false
-- @usage endsWith( "Hi there", "Here", true ) -- true
-- @usage endsWith( "Hi there", "" ) -- true
-- @usage s = "a"; endsWith( s, s ) -- true
-- @usage s = {}; endsWith( s, s ) -- false
-- @see startsWith
function CLASS.endsWith( target, suffix, ignoreCase )
    if ( target == nil and suffix == nil ) then return true end

    if ( type( target ) ~= "string" ) then return false end
    if ( type( suffix ) ~= "string" ) then return false end

    if ( suffix == "" ) then return true end

    local function _endsWith( target, suffix )
        if ( target == suffix ) then return true end
        return suffix == string.sub( target, -1 * string.len( suffix ) )
    end

    if ( ignoreCase ) then
        if ( target == suffix ) then return true end
        return _endsWith( target:lower(), suffix:lower() )
    else
        return _endsWith( target, suffix )
    end
end

--- Indicates whether the specified target string starts with the specified
-- prefix string, optionally ignoring case and safely handling nil values.  If
-- either object is not nil and is not a string, returns false.
-- @name startsWith
-- @param target The target string to be examined for whether it starts with
-- the specified suffix string.
-- @param prefix The string to be looked for at the start of the target
-- string.
-- @param ignoreCase Determines whether case is ignored during evaluation.
-- @return True if both strings are nil, or if the specified target string
-- starts with the specified prefix string, or if the specified prefix string
-- is an empty string; false otherwise.
-- @usage startsWith( nil, nil ) -- true
-- @usage startsWith( "Hi there", "HI" ) -- false
-- @usage startsWith( "Hi there", "HI", true ) -- true
-- @usage startsWith( "Hi there", "" ) -- true
-- @usage s = "a"; startsWith( s, s ) -- true
-- @usage s = {}; startsWith( s, s ) -- false
-- @see endsWith
function CLASS.startsWith( target, prefix, ignoreCase )
    if ( target == nil and prefix == nil ) then return true end

    if ( type( target ) ~= "string" ) then return false end
    if ( type( prefix ) ~= "string" ) then return false end

    if ( prefix == "" ) then return true end

    local function _startsWith( target, prefix )
        if ( target == prefix ) then return true end
        return prefix == string.sub( target, 1, string.len( prefix ) )
    end

    if ( ignoreCase ) then
        if ( target == prefix ) then return true end
        return _startsWith( target:lower(), prefix:lower() )
    else
        return _startsWith( target, prefix )
    end
end

return CLASS
