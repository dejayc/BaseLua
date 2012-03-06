--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua" )
local TableHelper = require( BaseLua.package.TableHelper )

context( "TableHelper", function()

-------------------------------------------------------------------------------
    context( "copy", function()
-------------------------------------------------------------------------------

        test(
"Copy table without recursion",
        function()
            local table1 = { level1 = 5, level2 = { level2a = 6 } }
            local table1_mt = { }
            setmetatable( table1, table1_mt )

            local table2 = TableHelper.copy( table1 )

            assert_not_equal( table1, table2 )
            assert_equal( table1.level1, table2.level1 )
            assert_equal( table1.level2, table2.level2 )
            assert_equal( table1.level2.level2a, table2.level2.level2a )

            assert_equal( table1_mt, getmetatable( table2 ) )
        end )

        test(
"Copy table recursively",
        function()
            local table1 = { level1 = 5, level2 = { level2a = 6 } }
            local table1_mt = {}
            setmetatable( table1, table1_mt )

            local table2 = TableHelper.copy( table1, true )

            assert_not_equal( table1, table2 )
            assert_equal( table1.level1, table2.level1 )
            assert_not_equal( table1.level2, table2.level2 )
            assert_equal( table1.level2.level2a, table2.level2.level2a )

            assert_equal( table1_mt, getmetatable( table2 ) )
        end )

        test(
"Copy table and metatable recursively",
        function()
            local table1 = { level1 = 5, level2 = { level2a = 6 } }
            local table1_mt = { level1 = 7, level2 = { level2a = 8 } }
            setmetatable( table1, table1_mt )

            local table2 = TableHelper.copy( table1, true, true )
            local table2_mt = getmetatable( table2 )

            assert_not_equal( table1, table2 )
            assert_equal( table1.level1, table2.level1 )
            assert_not_equal( table1.level2, table2.level2 )
            assert_equal( table1.level2.level2a, table2.level2.level2a )

            assert_not_equal( table1_mt, table2_mt )

            assert_equal( table1_mt.level1, table2_mt.level1 )
            assert_not_equal( table1_mt.level2, table2_mt.level2 )
            assert_equal( table1_mt.level2.level2a, table2_mt.level2.level2a )
        end )

        test(
"Copy nil",
        function()
            assert_nil( TableHelper.copy( nil ) )
        end )

        test(
"Copy string",
        function()
            assert_equal( "test", TableHelper.copy( "test" ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "getNumericKeysSorted", function()
-------------------------------------------------------------------------------

        test(
"Test condition",
        function()
            local keys = TableHelper.getNumericKeysSorted(
                { [ 4 ] = "a", [ 1 ] = "b", hi = "bye", [ 2 ] = "c" } )

            assert_equal( 3, table.getn( keys ) )
            assert_equal( 1, keys[ 1 ] )
            assert_equal( 2, keys[ 2 ] )
            assert_equal( 4, keys[ 3 ] )
        end )

        test(
"nil",
        function()
            assert_nil( TableHelper.getNumericKeysSorted( nil ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "isNonEmptyTable", function()
-------------------------------------------------------------------------------

        test(
"nil",
        function()
            assert_false( TableHelper.isNonEmptyTable( nil ) )
        end )

        test(
"String",
        function()
            assert_false( TableHelper.isNonEmptyTable( "Hi" ) )
        end )

        test(
"Empty table",
        function()
            assert_false( TableHelper.isNonEmptyTable( { } ) )
        end )

        test(
"Non-empty table",
        function()
            assert_true( TableHelper.isNonEmptyTable ( { "" } ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "pack", function()
-------------------------------------------------------------------------------

        test(
"1, 2, 3 -> { 1, 2, 3 }",
        function()
            local p = TableHelper.pack( 1, 2, 3 )
            assert_equal( 1, p[ 1 ] )
            assert_equal( 2, p[ 2 ] )
            assert_equal( 3, p[ 3 ] )
        end )

        test(
"1, nil, 3, 4 -> { 1, nil, 3, 4 }",
        function()
            local p = TableHelper.pack( 1, nil, 3, 4 )
            assert_equal( 1, p[ 1 ] )
            assert_nil( p[ 2 ] )
            assert_equal( 3, p[ 3 ] )
            assert_equal( 4, p[ 4 ] )
        end )

    end )

-------------------------------------------------------------------------------
    context( "selectByNestedIndex", function()
-------------------------------------------------------------------------------

        test(
"Nested sub-index",
        function()
            assert_equal( 9, TableHelper.selectByNestedIndex(
                { hi = { bye = 9 } }, "hi", "bye" ) )
        end )

        test(
"Nested index",
        function()
            local byeTable = { bye = 9 }
            assert_equal( byeTable, TableHelper.selectByNestedIndex(
                { hi = byeTable }, "hi" ) )
        end )

        test(
"Non-existent sub-index",
        function()
            assert_nil( TableHelper.selectByNestedIndex (
                { hi = { bye = 9 } }, "hi", "there" ) )
        end )

        test(
"Lookup into nil",
        function()
            assert_nil( TableHelper.selectByNestedIndex( nil, "hi", "bye" ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "updateByNestedIndex", function()
-------------------------------------------------------------------------------

        test(
"Nested sub-index updated with value",
        function()
            local table1 = { hi = { bye = 0 } }
            assert_equal( 0, table1.hi.bye )

            TableHelper.updateByNestedIndex( 9, table1, "hi", "bye" )
            assert_equal( 9, table1.hi.bye )
        end )

        test(
"Nested empty sub-index updated with value",
        function()
            local table1 = { hi = { } }

            TableHelper.updateByNestedIndex( 9, table1, "hi", "bye" )
            assert_equal( 9, table1.hi.bye )
        end )

        test(
"Nested sub-index updated with table",
        function()
            local table1 = { hi = { } }
            local byeTable = { bye = 9 }

            TableHelper.updateByNestedIndex( byeTable, table1, "hi" )
            assert_equal( 9, table1.hi.bye )
        end )

        test(
"Missing sub-index",
-- @usage updateByNestedIndex( 9, { hi = {} } ) --  { hi = {} }
        function()
            local table1 = { hi = { } }

            TableHelper.updateByNestedIndex( 9, table1 )
            assert_equal( table1, table1 )
        end )

        test(
"Update into nil",
-- @usage updateByNestedIndex( 9, nil, "hi", "bye" ) -- nil

        function()
            assert_nil( TableHelper.updateByNestedIndex(
                9, nil, "hi", "bye" ) )
        end )

    end )

end )
