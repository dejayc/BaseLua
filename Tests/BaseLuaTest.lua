--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua" )

context( "BaseLua", function()

-------------------------------------------------------------------------------
    context( "Package fields", function()
-------------------------------------------------------------------------------

        test(
"PACKAGE_PATH_SEPARATOR has a value",
        function()
            assert_not_blank( BaseLua.PACKAGE_PATH_SEPARATOR )
        end )

        test(
"PACKAGE_NAME_PATTERN has a value",
        function()
            assert_not_blank( BaseLua.PACKAGE_NAME_PATTERN )
        end )

        test(
"PACKAGE_PATH_PATTERN has a value",
        function()
            assert_not_blank( BaseLua.PACKAGE_PATH_PATTERN )
        end )

    end )

-------------------------------------------------------------------------------
    context( "Package fields", function()
-------------------------------------------------------------------------------

        test(
"package table exists",
        function()
            assert_type( BaseLua.package, "table" )
        end )

        test(
"package.name has a value",
        function()
            assert_type( BaseLua.package.name, "string" )
        end )

        test(
"package[ other ] has a value",
        function()
            assert_type( BaseLua.package.test, "string" )
        end )

    end )

-------------------------------------------------------------------------------
    context( "printf", function()
-------------------------------------------------------------------------------

        test(
"printf exists",
        function()
            assert_type( BaseLua.printf, "function" )
        end )

    end )

-------------------------------------------------------------------------------
    context( "writef", function()
-------------------------------------------------------------------------------

        test(
"writef exists",
        function()
            assert_type( BaseLua.writef, "function" )
        end )

    end )

-------------------------------------------------------------------------------
    context( "require", function()
-------------------------------------------------------------------------------

        test(
"require( 'BaseLua' ) exists",
        function()
            assert_type( require( "BaseLua" ), "table" )
        end )

    end )

end )
