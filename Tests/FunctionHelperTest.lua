--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua.BaseLua" )
local FunctionHelper = require( BaseLua.package.FunctionHelper )

context( "FunctionHelper", function()

-------------------------------------------------------------------------------
    context( "memoize", function()
-------------------------------------------------------------------------------

        test(
"Memoized function executes once per index",
        function()
            local value = 0
            local sub = FunctionHelper.memoize(
                function( a, b ) value = value + 1; return a - b end )

            assert_equal( 3, sub( 4, 1 ) )
            assert_equal( 1, value )
            assert_equal( 3, sub( 4, 1 ) )
            assert_equal( 1, value )
            assert_equal( 2, sub( 4, 2 ) )
            assert_equal( 2, value )
        end )

        test(
"__forget clears memoized results",
        function()
            local value = 0
            local sub = FunctionHelper.memoize(
                function( a, b ) value = value + 1; return a - b end )

            assert_equal( 3, sub( 4, 1 ) )
            assert_equal( 1, value )

            sub:__forget()
            assert_equal( 3, sub( 4, 1 ) )
            assert_equal( 2, value )
        end )

        test(
"Memoized function executes once per custom index",
        function()
            local value = 0
            local add = FunctionHelper.memoize(
                function( a, b ) value = value + 1; return a + b end,
                function( a, b ) return "[" .. ( a + b ) .. "]" end )

            assert_equal( 5, add( 2, 3 ) )
            assert_equal( 1, value )
            assert_equal( 5, add( 3, 2 ) )
            assert_equal( 1, value )
            assert_equal( 6, add( 3, 3 ) )
            assert_equal( 2, value )
        end )

    end )

end )
