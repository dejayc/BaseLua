--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua.BaseLua" )
local DataHelper = require( BaseLua.package.DataHelper )

context( "DataHelper", function()

-------------------------------------------------------------------------------
    context( "getNonNil", function()
-------------------------------------------------------------------------------

        test(
"return nil when no parameters",
        function()
            assert_nil( DataHelper.getNonNil() )
        end )

        test(
"return nil when nil as first of multiple parameters",
        function()
            assert_nil( DataHelper.getNonNil( nil, 5, nil ) )
        end )

        test(
"return first parameter when non-nil as first parameter",
        function()
            assert_equal( 5, DataHelper.getNonNil( 5, nil ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "hasValue", function()
-------------------------------------------------------------------------------

        test(
"return false when no parameters",
        function()
            assert_false( DataHelper.hasValue() )
        end )

        test(
"return true when non-nil, non-empty-string parameter",
        function()
            assert_true( DataHelper.hasValue( 5 ) )
        end )

        test(
"return false when empty-string parameter",
        function()
            assert_false( DataHelper.hasValue( "" ) )
        end )

        test(
"return true when whitespace parameter",
        function()
            assert_true( DataHelper.hasValue( " " ) )
        end )

    end )

-------------------------------------------------------------------------------
    context( "ifThenElse", function()
-------------------------------------------------------------------------------

        test(
"return nil when no params",
        function()
            assert_nil( DataHelper.ifThenElse() )
        end )

        test(
"return true param if test param is true",
        function()
            assert_true( DataHelper.ifThenElse( true, true, false ) )
        end )

        test(
"return false param if test param is nil",
        function()
            assert_false( DataHelper.ifThenElse( nil, true, false ) )
        end )

        test(
"return false param if test param is false",
        function()
            assert_false( DataHelper.ifThenElse( false, true, false ) )
        end )

    end )

end )
