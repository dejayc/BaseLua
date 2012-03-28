--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "BaseLua" )
local ClassHelper = require( BaseLua.package.ClassHelper )

local CLASS = { className = ClassHelper.getPackagePath( ... ) }

local function findMetamethod( target, index, ignoreFn )
    local toInvoke

    -- First, check the class instance properties for the specified
    -- metamethod, which will not propagate to super classes.
    local class = TableHelper.selectByNestedIndex(
        target, "class", "instanceProperties" )

    if ( class ~= nil) then
        toInvoke = rawget( class, index )
        if ( toInvoke ~= nil and toInvoke ~= ignoreFn ) then
            return toInvoke
        end
    end

    -- Next, check the class raw table properties for the specified
    -- metamethod, which will not propagate to super classes.
    toInvoke = rawget( target, index )
    if ( toInvoke ~= nil and toInvoke ~= ignoreFn ) then
        return toInvoke
    end

    -- Next, check the class metatable properties for the specified
    -- metamethod, which will not propagate to super classes.
    local metatable = getmetatable( target )

    if ( metatable ~= target and metatable ~= nil ) then
        toInvoke = rawget( metatable, index )
        if ( toInvoke ~= nil and toInvoke ~= ignoreFn ) then
            return toInvoke
        end
    end

    -- Next, check the class table properties for the specified metamethod,
    -- which MAY propagate to super classes, depending on how "__index" is
    -- defined for this table.  Only do this for metamethod lookups which are
    -- not "__index", as that would lead to infinite recursion.
    if ( metatable == nil or metatable.__index ~= ignoreFn ) then
        toInvoke = target[ index ]
        if ( toInvoke ~= nil and toInvoke ~= ignoreFn ) then
            return toInvoke
        end
    end

    -- Next, check the metatable table properties for the specified
    -- metamethod, which MAY propagate to super classes, depending on whether
    -- the metatable has its own metatable defined with an "__index"
    -- metamethod.
    if ( metatable ~= target and metatable ~= nil ) then
        toInvoke = metatable[ index ]
        if ( toInvoke ~= nil and toInvoke ~= ignoreFn ) then
            return toInvoke
        end
    end
end

local function createMetamethodLookup( target, metamethodName )
    return function( ... )
        local metatable = getmetatable( target ) or {}
        local ignoreFn = metatable[ metamethodName ]

        -- First, check the current table for the specified metamethod.
        local toInvoke = findMetamethod( target, metamethodName, ignoreFn )
        if ( toInvoke ~= nil ) then return toInvoke( ... ) end

        -- Next, check the super class for the specified metamethod.
        local super = TableHelper.selectByNestedIndex(
            target, "class", "super" )

        if ( super ~= nil) then
            toInvoke = findMetamethod( super, metamethodName, ignoreFn )
            if ( toInvoke ~= nil ) then return toInvoke ( ... ) end
        end
    end
end

local function initializeMetamethods( target )
    local metatable = getmetatable( target ) or {}

    for _, metamethodName in ipairs( metamethodNames )
    do
        metatable[ metamethodName ] =
            createMetamethodLookup( target, metamethodName )
    end
    return metatable
end

function CLASS:cast( object )
    object = object or {}
    setmetatable( object, getmetatable( self.class ))

    return object
end

function CLASS:cloneMetatable( source )
    local sourceMetatable = getmetatable( source )
    local targetMetatable = {}

    for index, value in pairs( sourceMetatable ) do
        targetMetatable[ index ] = value
    end

    return setmetatable( self, targetMetatable )
end

function CLASS:copyMetatable( source )
    local sourceMetatable = getmetatable( source )
    local targetMetatable = getmetatable( self )

    if ( sourceMetatable ~= targetMetatable )
    then
        for index, value in pairs( sourceMetatable ) do
            targetMetatable[ index ] = value
        end
    end

    return self
end

function CLASS:extend( object )
    object = object or {}

    --[[
        Create a class-specific metatable that copies the metatable of the
        parent class being extended, and sets the fallback prototype chain to
        index the parent class.
    --]]
    object.super = self
    self.cloneMetatable( object, object.super )
    getmetatable( object ).__index = object.super

    --[[
        Create a prototype metatable to be shared by all future child
        instances of this class, so that the fallback index searches this
        class before searching the parent class.  This single metatable
        is shared by all instances of future child instances in order to
        avoid a per-object metatable and their associated memory overhead.
    --]]
    object.class = {}
    self.cloneMetatable( object.class, object )
    getmetatable( object.class ).__index = object

    return object
end

--[[
    'Class:new' is the same as 'Class:cast', except that a new object instance
    is always created.
--]]
function CLASS:new()
    return self:cast( {} )
end

function CLASS:__tostring()
    if ( not self ) then return "undefined" end
    if ( not self.className ) then return self end
    if ( not self.super ) then return self.className end
    if ( not self.super.className ) then return self.className end

    return self.className .. " (" .. self.super.className .. ")"
end

setmetatable( CLASS, {
    __tostring = CLASS.__tostring })

return CLASS
