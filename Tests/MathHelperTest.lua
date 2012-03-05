--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua.BaseLua" )
local MathHelper = require( BaseLua.package.MathHelper )

context( "MathHelper", function()

-------------------------------------------------------------------------------
    context( "roundNumber", function()
-------------------------------------------------------------------------------

        test(
"98.4 -> 98",
        function()
            assert_equal( 98, MathHelper.roundNumber( 98.4 ) )
        end )

        test(
"98.6 -> 99",
        function()
            assert_equal( 99, MathHelper.roundNumber( 98.6 ) )
        end )

        test(
"98.625, 1 -> 98.6",
        function()
            assert_equal( 98.6, MathHelper.roundNumber( 98.625, 1 ) )
        end )

        test(
"98.625, 2 -> 98.63",
        function()
            assert_equal( 98.63, MathHelper.roundNumber( 98.625, 2 ) )
        end )

    end )

end )
