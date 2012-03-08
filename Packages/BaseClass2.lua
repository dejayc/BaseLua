--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- The base class for object-oriented classes and objects.

module "BaseClass2"
-------------------------------------------------------------------------------
--]]

local BaseLua = require( "BaseLua" )
local ClassHelper = require( BaseLua.package.ClassHelper )

local CLASS = {
    class = {
        name = ClassHelper.getPackagePath( ... ),
        metatable = {},
        mixins = { interfaceList = {}, classes = {} },
        parents = { interfaceList = {}, classes = {} },
        virtualTable = {},
    },
}

function CLASS:invokeMethod( methodName, ... )
    -- Search mixins first
    -- Search current class next
    -- Search super classes last
end

--- Copies the metatable of the specified table or object into a new metatable
-- of the current class.
-- @name copyMetatable
-- @param source The table or object that has a metatable to copy into the
-- current class.
-- @return The current class.
-- @usage classInstance:copyMetatable( otherClass )
-- @see importMetatable
function CLASS:copyMetatable( source )
    local sourceMetatable = getmetatable( source )
    local targetMetatable = {}

    self.class.metatable = targetMetatable

    for index, value in pairs( sourceMetatable ) do
        targetMetatable[ index ] = value
    end

    return setmetatable( self, targetMetatable )
end

--- Extends the current class to the specified table or object.  This is
-- accomplished by setting the metatable of the specified table or object to
-- be the same metatable as the current class.  If no table or object is
-- specified, a new object is created.
-- @name cast
-- @param object The table or object to cast to the current class.
-- @return The specified table or object that was cast to the current class,
-- or a new object if no table or object was specified.
-- @usage SubclassOfBaseClass:cast( myObject )
function CLASS:extend( object )
    object = object or {}

    --[[
        Create a class-specific metatable that copies the metatable of the
        parent class being extended, and sets the fallback prototype chain to
        index the parent class.
    --]]
    object.super = self
    self.copyNewMetatableTo( object, object.super )
    getmetatable( object ).__index = object.super

    --[[
        Create a prototype metatable to be shared by all future child
        instances of this class, so that the fallback index searches this
        class before searching the parent class.  This single metatable
        is shared by all instances of future child instances in order to
        avoid a per-object metatable and their associated memory overhead.
    --]]
    object.class = {}
    self.copyNewMetatableTo( object.class, object )
    getmetatable( object.class ).__index = object

    return object
end

--- Copies the metatable of the specified table or object into the existing
-- metatable of the current class.
-- @name importMetatable
-- @param source The table or object that has a metatable to copy into the
-- current class.
-- @return The current class.
-- @usage classInstance:importMetatable( otherClass )
-- @see copyMetatable
function CLASS:importMetatable( source )
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

--[[
    'Class:new' is the same as 'Class:cast', except that a new object instance
    is always created.
--]]
--- Description.
-- @name new
-- @return description.
-- @usage example
-- @see .class
function CLASS:new()
    return self:cast( {} )
end

--- Description.
-- @name __tostring
-- @return description.
-- @usage example
-- @see .class
function CLASS:__tostring()
    if ( not self ) then return "undefined" end

    local class = self.class
    if ( not class ) then return self end

    local name = class.name
    if ( not name ) then return self end

    local super = class.super
    if ( not super ) then return name end

    local superClass = super.class
    if ( not superClass ) then return name end

    local superClassName = superClass.name
    if ( not superClassName ) then return name end

    return name .. " (" .. superClassName .. ")"
end

setmetatable( CLASS, {
    __tostring = CLASS.__tostring })

return CLASS
