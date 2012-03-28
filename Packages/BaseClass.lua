--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "BaseLua" )
local ClassHelper = require( BaseLua.package.ClassHelper )
local TableHelper = require( BaseLua.package.TableHelper )

local CLASS_NAME = ClassHelper.getPackagePath( ... )
local OBJECT_LABEL_ID_OFFSET = string.len( "table " ) + 2

local METAMETHOD_NAMES = {
    '__mul', '__pow', '__div', '__mod', '__add', '__sub', '__unm',
    '__le', '__lt',
    '__concat', '__tostring',
    '__call', '__index', '__newindex',
}

local ERR_MSG_FN_CREATE_CLASS_INSTANCE_ARG_BASE_CLASS_INVALID =
    "Function 'createClassInstance' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'baseClass'"
local ERR_MSG_FN_CREATE_CLASS_INSTANCE_METATABLE_ARG_BASE_CLASS_INVALID =
    "Function 'createClassInstanceMetatable' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'baseClass'"
local ERR_MSG_FN_CREATE_CLASS_INSTANCE_METATABLE_ARG_SELF_INVALID =
    "Function 'createClassInstanceMetatable' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'self'"
local ERR_MSG_FN_COPY_CLASS_METATABLE_ARG_BASE_CLASS_INVALID =
    "Function 'copyClassMetatable' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'baseClass'"
local ERR_MSG_FN_COPY_CLASS_METATABLE_ARG_SELF_INVALID =
    "Function 'copyClassMetatable' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'self'"
local ERR_MSG_FN_CREATE_SUBCLASS_ARG_BASE_CLASS_INVALID =
    "Function 'createSubclass' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'baseClass'"
local ERR_MSG_FN_EXTEND_ARG_BASE_CLASS_INVALID =
    "Function 'extend' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'baseClass'"
local ERR_MSG_FN_EXTEND_ARG_SELF_INVALID =
    "Function 'extend' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'self'"
local ERR_MSG_FN_NEW_ARG_BASE_CLASS_INVALID =
    "Function 'new' in " .. CLASS_NAME ..
    " was supplied an invalid value for parameter 'baseClass'"

-- An array of shared class instance metatables that instances of a particular
-- class can share to conserve memory.
local classInstanceMetatables = setmetatable( { }, { __mode = "kv" } )

-- An array of shared class instance properties that instances of a particular
-- class can share to conserve memory.
local classInstanceProperties = setmetatable( { }, { __mode = "kv" } )

-- Forward declaration of methods that need it.
local createClass, createClassInstance, createSubclass 

local function onProxyTableError( target, propertyName, value )
    error(
        "Attempt to set protected class properties with index '" ..
        tostring( propertyName ) .. "'", 3 )
end

local function ancestors( class, includeSelf )
    -- Keep track of encountered objects to prevent any infinite recursion.
    local encountered = { }

    -- Only store weak references in the tracking array, otherwise objects
    -- might be held up from garbage collection.
    setmetatable( encountered, { __mode = "k" } )

    -- If class is specified to be included in the ancestry chain, create a
    -- new class structure with the specified class as the starting node.
    if ( includeSelf ) then class = { class = { super = class } } end

    return function()
        class = TableHelper.getByIndex( class, "class", "super" )

        if ( class == nil ) then
            -- Release the tracking array.
            encountered = nil
            return
        end

        if ( not encountered[ class ] ) then
            encountered[ class ] = true
            return class
        end

        -- Release the tracking array.
        encountered = nil
        return
    end
end

local function getClassName( class )
    return ( TableHelper.getByIndex( class, "class", "name" ) )
end

local function getConstructor( class )
    return (
        TableHelper.getByIndex( class, "constructor" ) or
        TableHelper.getByIndex( class, "class", "constructor" ) )
end

local function getObjectId( self )
    return TableHelper.getByIndex( self, "object", "id" )
end

local function copyClassMetatable( baseClass, self )
    assert( type( baseClass ) == "table",
        ERR_MSG_FN_COPY_CLASS_METATABLE_ARG_BASE_CLASS_INVALID )

    assert( type( self ) == "table",
        ERR_MSG_FN_COPY_CLASS_METATABLE_ARG_SELF_INVALID )

    local metatable = getmetatable( self )

    if ( metatable == nil ) then
        metatable = self
        setmetatable( self, metatable )
    end

    local baseMetatable = getmetatable( baseClass )
    if ( baseMetatable ) then
        -- Make all non-present metamethods in the class metatable point to
        -- their counterparts in the base class metatable.
        for _, metamethodName in ipairs( METAMETHOD_NAMES ) do
            if ( metatable[ metamethodName ] == nil ) then
                metatable[ metamethodName ] = baseMetatable[ metamethodName ]
            end
        end
    end

    -- Update the metatable to point to the base class.
    metatable.__index = baseClass
end

local function createClassInstanceMetatable( baseClass, self )
    assert( type( baseClass ) == "table",
        ERR_MSG_FN_CREATE_CLASS_INSTANCE_METATABLE_ARG_BASE_CLASS_INVALID )

    assert( type( self ) == "table",
        ERR_MSG_FN_CREATE_CLASS_INSTANCE_METATABLE_ARG_SELF_INVALID )

    local metatable = classInstanceMetatables[ baseClass ]

    if ( metatable == nil ) then
        metatable = { }
        setmetatable( self, metatable )

        local baseMetatable = getmetatable( baseClass )
        if ( baseMetatable ) then
            -- Make all metamethods in the shared metatable point to their
            -- counterparts in the base class metatable.
            for _, metamethodName in ipairs( METAMETHOD_NAMES ) do
                metatable[ metamethodName ] = baseMetatable[ metamethodName ]
            end
        end

        classInstanceMetatables[ baseClass ] = metatable

        -- Update the metatable to point to the base class.
        metatable.__index = baseClass
    end
end

local function construct( class, ... )
    -- Search class and ancestors for a constructor.
    for ancestor in ancestors( class, true ) do
        constructor = getConstructor( class )
        if ( constructor ) then return constructor ( class, ... ) end
    end

    return class
end

local function new( baseClass, ... )
    assert( type( baseClass ) == "table",
        ERR_MSG_FN_NEW_ARG_BASE_CLASS_INVALID )

    local self = createClassInstance( baseClass )
    createClassInstanceMetatable( baseClass, self )

    local objectProperties = { }
    self.object = objectProperties

    objectProperties.id = string.sub(
        tostring( objectProperties ), OBJECT_LABEL_ID_OFFSET )

    return construct( self, ... )
end

local function extend( baseClass, self, name )
    assert( type( baseClass ) == "table",
        ERR_MSG_FN_EXTEND_ARG_BASE_CLASS_INVALID )

    assert( self == nil or type( self ) == "table",
        ERR_MSG_FN_EXTEND_ARG_SELF_INVALID )

    local self = createSubclass( baseClass, self, name )
    copyClassMetatable( baseClass, self )

    local objectProperties = { }
    self.object = objectProperties

    objectProperties.id = string.sub(
        tostring( objectProperties ), OBJECT_LABEL_ID_OFFSET )

    return self
end

local function __tostring( self )
    local className = getClassName( self ) or CLASS_NAME
    local id = getObjectId( self )

    if ( id ) then
        return className .. ": " .. id
    else
        return className
    end
end

createClass = function( name )
    local self = { }
    self.class = TableHelper.createReadProxyTable( {
        ancestors = function()
            return ancestors( self, false )
        end,
        constructor = TableHelper.getByIndex( class, "constructor" ),
        extend = function( ... )
            return extend( self, ... )
        end,
        name = name,
        new = function( ... )
            return new( self, ... )
        end,
        super = nil,
        }, onProxyTableError )

    setmetatable( self, self )
    return self
end

createClassInstance = function( baseClass )
    assert( type( baseClass ) == "table",
        ERR_MSG_FN_CREATE_CLASS_INSTANCE_ARG_BASE_CLASS_INVALID )

    local classProperties = classInstanceProperties[ baseClass ]

    if ( classProperties == nil ) then
        classProperties = TableHelper.createReadProxyTable( {
            ancestors = function()
                return ancestors( baseClass, true )
            end,
            constructor = TableHelper.getByIndex( class, "constructor" ),
            extend = function( ... )
                return extend( baseClass, ... )
            end,
            name = getClassName( baseClass ),
            new = function( ... )
                return new( baseClass, ... )
            end,
            super = baseClass,
            }, onProxyTableError )

        classInstanceProperties[ baseClass ] = classProperties
    end

    return { class = classProperties }
end

createSubclass = function( baseClass, self, name )
    assert( type( baseClass ) == "table",
        ERR_MSG_FN_CREATE_SUBCLASS_ARG_BASE_CLASS_INVALID )

    if ( baseClass == self ) then return baseClass end

    self = self or { }
    self.class = TableHelper.createReadProxyTable( {
        ancestors = function()
            return ancestors( self, false )
        end,
        constructor = function()
            return getConstructor( self )
        end,
        extend = function( ... )
            return extend( self, ... )
        end,
        name = name,
        new = function( ... )
            return new( self, ... )
        end,
        super = baseClass,
        }, onProxyTableError )

    return self
    
end

local CLASS = createClass( CLASS_NAME )

CLASS.__call = new
CLASS.__tostring = __tostring

CLASS = construct( CLASS )
return CLASS
