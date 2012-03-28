--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing table manipulation.

module "TableHelper"
-------------------------------------------------------------------------------
--]]

local CLASS = {}

--- Returns a shallow or deep copy of the specified table.
-- @name copy
-- @param sourceTable The table to copy.
-- @param copyTables False if the specified table and its resulting copy
-- should share references to child elements that are also tables; True if
-- child tables should be copied recursively.  Defaults to false.
-- @param copyMetatables False if the specified table and its child table
-- elements should share metatables with the resulting copies of the tables;
-- True if metatables should be copied recursively.  Defaults to false.
-- @return A copy of the specified table.
-- @usage table2 = copy( table1 )
-- @usage table2 = copy( table1, true )
-- @usage table2 = copy( table1, true, true )
-- @usage table2 = copy( nil ) -- nil
-- @usage table2 = copy( "non-table" ) -- "non-table"
-- @see http://lua-users.org/wiki/CopyTable
function CLASS.copy( sourceTable, copyTables, copyMetatables )
    local lookupTable = {}

    local function _copy( toCopy )
        if ( type( toCopy ) ~= "table" ) then
            return toCopy
        end

        if ( lookupTable[ toCopy ] ) then
            return lookupTable[ toCopy ]
        end

        local copied = {}
        lookupTable[ toCopy ] = copied

        if ( copyTables ) then
            for index, value in pairs( toCopy ) do
                copied[ _copy( index) ] = _copy( value )
            end
        else
            for index, value in pairs( toCopy ) do
                copied[ index ] = value
            end
        end

        if ( copyMetatables ) then
            return setmetatable( copied, _copy( getmetatable( toCopy ) ) )
        else
            return setmetatable( copied, getmetatable( toCopy ) )
        end
    end

    return _copy( sourceTable )
end

--- Returns the specified named element of the specified table, traversing
-- nested table elements as necessary.  If the specified table is nil, or
-- lacks the specified named element, returns nil.
-- @name getByIndex
-- @param target The target table to search for the specified named element.
-- @param ... A list of element names, with each name representing a step
-- deeper into the hierarchy of nested table elements.
-- @return The specified named element of the specified table, if available;
-- otherwise, nil.
-- @usage getByIndex( { hi = { bye = 9 } }, "hi", "bye" ) -- 9
-- @usage getByIndex( { hi = { bye = 9 } }, "hi" ) -- { bye = 9 }
-- @usage getByIndex( { hi = { bye = 9 } }, "hi", "there" ) -- nil
-- @usage getByIndex( nil, "hi", "bye" ) -- nil
-- @see getByIndex
function CLASS.getByIndex( target, ... )
    if ( type( target ) ~= "table" ) then return end

    local objRef = target

    for _, value in ipairs( arg ) do
        objRef = objRef[ value ]
        if ( objRef == nil ) then return end
    end

    return objRef
end

--- Returns a new table consisting of the sorted numeric key values of the
-- specified table.  Useful for iterating through a mixed table that contains
-- associative array entries in addition to traditional numeric array entries.
-- @name getNumericKeysSorted
-- @param target The target table to search for numeric key values.
-- @return The sorted numeric key values of the specified table.
-- @usage getNumericKeysSorted(
--   { [ 4 ] = "a", [ 1 ] = "b", hi = "bye", [ 2 ] = "c" } ) -- { 1, 2, 4 }
-- @usage getNumericKeysSorted( nil ) -- nil
-- @usage for index, value in ipairs( getNumericKeysSorted ( mixedTable ) ) do
function CLASS.getNumericKeysSorted( target )
    if ( target == nil ) then return end

    local sorted = {}
    for index, value in pairs( target ) do
        if ( type( index ) == "number" ) then
            table.insert( sorted, index )
        end
    end

    table.sort( sorted )
    return sorted
end

--- Indicates whether the specified parameter is a table that contains at
-- least one element.
-- @name isNonEmptyTable
-- @param target The target parameter to evaluate.
-- @return True if the specified parameter is a table that contains at least
-- one element; otherwise, false.
-- @usage isNonEmptyTable( nil ) -- false
-- @usage isNonEmptyTable( "Hi" ) -- false
-- @usage isNonEmptyTable( { } ) -- false
-- @usage isNonEmptyTable( { "" } ) -- true
function CLASS.isNonEmptyTable( target )
    return
        type( target ) == "table" and
        table.getn( target ) > 0
end

--- Returns a table that contains all of the passed parameters.
-- @name pack
-- @param ... A list of optional parameters with which to populate the
-- returned table.
-- @return A table that contains all of the passed parameters.
-- @usage pack ( 1, 2, 3 ) -- { 1, 2, 3 }
-- @usage pack ( 1, nil, 2, 3 ) -- { 1, nil, 2, 3 }
function CLASS.pack( ... )
    return arg
end

--- Updates the specified named element of the specified table to the
-- specified value and returns it, traversing and creating nested table
-- elements as necessary.  If the specified table is nil, returns nil.
-- @name setByIndex
-- @param value The value to which to set the specified named element in the
-- specified table.
-- @param target The target table to search for the specified named element.
-- @param ... A list of element names, with each name representing a step
-- deeper into the hierarchy of nested table elements.
-- @return The specified value, if the specified table is not nil and a named
-- element has been specified; otherwise, nil.
-- @usage setByIndex( 9, { hi = { bye = 0 } }, "hi", "bye" )
--   -- 9; target = { hi = { bye = 9 } }
-- @usage setByIndex( 9, { hi = { } }, "hi", "bye" )
--   -- 9; target = { hi = { bye = 9 } }
-- @usage setByIndex( { bye = 9}, { hi = { } }, "hi" )
--   -- { bye = 9 }; target = { hi = { bye = 9 } }
-- @usage setByIndex( 9, { hi = { } } ) -- nil; target = { hi = { } }
-- @usage setByIndex( 9, nil, "hi", "bye" ) -- nil
-- @see getByIndex
function CLASS.setByIndex( value, target, ... )
    if ( target == nil ) then return end

    local objRef = target
    local pathDepth = table.getn( arg )
    if ( pathDepth < 1 ) then return end

    for index, indexName in ipairs( arg ) do
        if ( index == pathDepth ) then
            objRef[ indexName ] = value
            break
        end
        if ( objRef[ indexName ] == nil ) then
            objRef[ indexName ] = {}
        end
        objRef = objRef[ indexName ]
    end

    return value
end

--- Updates the specified named element of the specified table to the
-- specified value and returns it, if it doesn't exist, traversing and creating
-- nested table elements as necessary.  If the specified named element does
-- exist, returns the existing value.  If the specified table is nil, returns
-- nil.
-- @name setDefaultByIndex
-- @param value The value to which to set the specified named element in the
-- specified table, if it doesn't exist.
-- @param target The target table to search for the specified named element.
-- @param ... A list of element names, with each name representing a step
-- deeper into the hierarchy of nested table elements.
-- @return The specified value, if the specified table is not nil and a named
-- element has been specified and the named element does not exist; or, the
-- existing value of the specified named element, if it exists; otherwise, nil.
-- @return True if the specified named element in the specified table already
-- exists and has a value; otherwise, false.
-- @usage setDefaultByIndex( 9, { hi = { bye = 0 } }, "hi", "bye" )
--   -- 0; target = { hi = { bye = 0 } }
-- @usage setDefaultByIndex( 9, { hi = { } }, "hi", "bye" )
--   -- 9; target = { hi = { bye = 9 } }
-- @usage setDefaultByIndex( { bye = 9}, { hi = { } }, "hi" )
--   -- { }; target = { hi = { } }
-- @usage setDefaultByIndex( 9, { hi = { } } ) -- nil; target = { hi = { } }
-- @usage setDefaultByIndex( 9, nil, "hi", "bye" ) -- nil
-- @see getByIndex
-- @see setByIndex
function CLASS.setDefaultByIndex( value, target, ... )
    if ( target == nil ) then return nil, false end

    local objRef = target
    local pathDepth = table.getn( arg )
    if ( pathDepth < 1 ) then return nil, false end

    for index, indexName in ipairs( arg ) do
        if ( index == pathDepth ) then
            local existingValue = objRef[ indexName ]
            if ( existingValue ) then return existingValue, true end
            objRef[ indexName ] = value
            break
        end
        if ( objRef[ indexName ] == nil ) then
            objRef[ indexName ] = {}
        end
        objRef = objRef[ indexName ]
    end

    return value, false
end

return CLASS
