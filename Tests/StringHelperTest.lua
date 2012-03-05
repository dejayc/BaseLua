--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua.BaseLua" )
local StringHelper = require( BaseLua.package.StringHelper )

context( "StringHelper", function()

-------------------------------------------------------------------------------
    context( "compareString", function()
-------------------------------------------------------------------------------

        test(
"nil, nil -> true",
        function()
            assert_true( StringHelper.compareString( nil, nil ) )
        end )

        test(
"'Hi', 'hi' -> false",
        function()
            assert_false( StringHelper.compareString( "Hi", "hi" ) )
        end )

        test(
"'Hi', 'hi', true -> true",
        function()
            assert_true( StringHelper.compareString( "Hi", "hi", true ) )
        end )

        test(
"{}, {} -> false",
        function()
            local s = {}
            assert_false( StringHelper.compareString( s, s ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "endsWith", function()
-------------------------------------------------------------------------------

        test(
"nil, nil -> true",
        function()
            assert_true( StringHelper.endsWith( nil, nil ) )
        end )

        test(
"'Hi there', 'Here' -> false",
        function()
            assert_false( StringHelper.endsWith( "Hi there", "Here" ) )
        end )

        test(
"'Hi there', 'Here', true -> true",
        function()
            assert_true( StringHelper.endsWith( "Hi there", "Here", true ) )
        end )

        test(
"'Hi there', '' -> true",
        function()
            assert_true( StringHelper.endsWith( "Hi there", "" ) )
        end )

        test(
"s = 'a'; s, s -> true",
        function()
            local s = "a"
            assert_true( StringHelper.endsWith( s, s ) )
        end )

        test(
"s = {}; s, s -> false",
        function()
            local s = {}
            assert_false( StringHelper.endsWith( s, s ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "startsWith", function()
-------------------------------------------------------------------------------

        test(
"nil, nil -> true",
        function()
            assert_true( StringHelper.startsWith( nil, nil ) )
        end )

        test(
"'Hi there', 'HI' -> false",
        function()
            assert_false( StringHelper.startsWith( "Hi there", "HI" ) )
        end )

        test(
"'Hi there', 'HI', true -> true",
        function()
            assert_true( StringHelper.startsWith( "Hi there", "HI", true ) )
        end )

        test(
"'Hi there', '' -> true",
        function()
            assert_true( StringHelper.startsWith( "Hi there", "" ) )
        end )

        test(
"s = 'a'; s, s -> true",
        function()
            local s = "a"
            assert_true( StringHelper.startsWith( s, s ) )
        end )

        test(
"s = {}; s, s -> false",
        function()
            local s = {}
            assert_false( StringHelper.startsWith( s, s ) )
        end )

    end )

end )
