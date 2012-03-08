--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- The base class for object-oriented classes and objects.

module "BaseClass3"
-------------------------------------------------------------------------------
--]]

local BaseLua = require( "BaseLua" )
local DataHelper = require( BaseLua.package.DataHelper )
local TableHelper = require( BaseLua.package.TableHelper )

local metamethodNames = {
    '__add', '__sub', '__unm', '__mul', '__pow', '__div', '__mod',
    '__le', '__lt',
    '__concat', '__tostring',
    '__index', '__newindex', '__call',
}

local function searchClassForMetamethod( target, index, ignoreFn )
    local class = TableHelper.selectByNestedIndex(
        target, "class", "instanceProperties" )

    local toInvoke

    -- First, check the class instance properties for the specified
    -- metamethod, which will not propagate to super classes.
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

local function searchClassForMethod( target, index )
    local class = TableHelper.selectByNestedIndex(
        target, "class", "instanceProperties" )

    local toInvoke

    -- First, check the class instance properties for the specified method,
    -- which will not propagate to super classes.
    if ( class ~= nil) then
        toInvoke = rawget( class, index )
        if ( toInvoke ~= nil ) then
            return toInvoke
        end
    end

    -- Next, check the class raw table properties for the specified method,
    -- which will not propagate to super classes.
    toInvoke = rawget( target, index )
    if ( toInvoke ~= nil ) then
        return toInvoke
    end

    -- Next, check the class table properties for the specified method, which
    -- MAY propagate to super classes, depending on how "__index" is defined
    -- for this table.
    toInvoke = target[ index ]
    if ( toInvoke ~= nil ) then
        return toInvoke
    end
end

local function searchClassesForMetamethod( target, index, ignoreFn )
    -- First, check the current table for the specified metamethod.
    toInvoke = searchClassForMetamethod( target, index, ignoreFn )
    if ( toInvoke ~= nil ) then return toInvoke end

    -- Next, check each super class for the specified metamethod.
    local parents = TableHelper.selectByNestedIndex(
        target, "class", "parents" )

    if ( parents ~= nil) then
        for _, parent in pairs( parents ) do
            toInvoke = searchClassForMetamethod( parent, index, ignoreFn )
            if ( toInvoke ~= nil ) then return toInvoke end
        end
    end
end

local function searchClassesForMethod( target, index )
    -- First, check the mixins for the specified method.
    local mixinMethods = TableHelper.selectByNestedIndex(
        target, "class", "mixins", "methods" )

    if ( mixinMethods ~= nil ) then
        toInvoke = mixinMethods[ index ]
        if ( toInvoke ~= nil ) then return toInvoke end
    end

    -- Next, check the current table for the specified method.
    toInvoke = searchClassForMethod( target, index )
    if ( toInvoke ~= nil ) then return toInvoke end

    local parentClasses = TableHelper.selectByNestedIndex(
        target, "class", "parents" )

    -- Next, check each super class for the specified method.
    if ( parents ~= nil) then
        for _, parent in pairs( parents ) do
            toInvoke = searchClassForMethod( parent, index )
            if ( toInvoke ~= nil ) then return toInvoke end
        end
    end
end

local function initializeMetamethods( target )
    local metatable = getmetatable( target ) or {}

    for _, metamethodName in ipairs( metamethodNames )
    do
        metatable[ metamethodName ] = function( ... )
            local toInvoke = searchClassesForMetamethod(
                target, metamethodName, metatable[ metamethodName ] )

            if ( toInvoke ~= nil ) then
                return toInvoke( ... )
            end
        end
    end
    return metatable
end

local function createClassStructure( target, name, baseClass )
    target = target or {}
    name = name or "undefined"

    local baseClassStructure = TableHelper.selectByNestedIndex(
        baseClass, "class" )

    local baseClassName = TableHelper.selectByNestedIndex(
        baseClassStructure, "name" )

    if ( DataHelper.hasValue( baseClassName ) ) then
        name = baseClassName .. "." .. name
    end

    local className = name
    local classMetatable = initializeMetamethods( target )
    local classInstanceProperties = {}
    local classMixinInterfaceNames = {}
    local classMixinMethods = {}
    local classParents = {}

    local classMixins = {
        interfaceNames = classMixinInterfaceNames,
        methods = classMixinMethods,
    }

    local class = {
        name = className,
        metatable = classMetatable,
        instanceProperties = classInstanceProperties,
        mixins = classMixins,
        parents = classParents,
    }

    class.id = tostring( class )
    target.class = class

    if ( baseClassStructure ~= nil ) then
        classParents[ baseClassName ] = baseClass
    end

    return setmetatable( target, classMetatable )
end

local CLASS = createClassStructure( {}, arg[ 1 ] )

CLASS.class.instanceProperties.__newindex = function( target, index, value )
    target.class.instanceProperties[ index ] = value
end

CLASS.__index = searchClassesForMethod

function CLASS:__tostring()
    return self.class.id
end

function CLASS:getClassName()
    return self.class.name
end

return CLASS
