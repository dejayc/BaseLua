--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

local BaseLua = require( "Packages.BaseLua" )
local FileHelper = require( BaseLua.package.FileHelper )

context( "FileHelper", function()

-------------------------------------------------------------------------------
    context( "Package fields", function()
-------------------------------------------------------------------------------

        test(
"FILE_EXTENSION_SEPARATOR has a value",
        function()
            assert_not_blank( FileHelper.FILE_EXTENSION_SEPARATOR )
        end )

        test(
"FILE_EXTENSION_SPLIT_PATTERN has a value",
        function()
            assert_not_blank( FileHelper.FILE_EXTENSION_SPLIT_PATTERN )
        end )

        test(
"LUA_FILE_EXTENSION has a value",
        function()
            assert_not_blank( FileHelper.LUA_FILE_EXTENSION )
        end )

        test(
"PATH_CURRENT_DIRECTORY has a value",
        function()
            assert_not_blank( FileHelper.PATH_CURRENT_DIRECTORY )
        end )

        test(
"PATH_PARENT_DIRECTORY has a value",
        function()
            assert_not_blank( FileHelper.PATH_PARENT_DIRECTORY )
        end )

        test(
"PATH_SEPARATOR has a value",
        function()
            assert_not_blank( FileHelper.PATH_SEPARATOR )
        end )

        test(
"PATH_FILE_NAME_SPLIT_PATTERN has a value",
        function()
            assert_not_blank( FileHelper.PATH_FILE_NAME_SPLIT_PATTERN )
        end )

        test(
"PATH_TRIM_PATTERN has a value",
        function()
            assert_not_blank( FileHelper.PATH_TRIM_PATTERN )
        end )

    end )

-------------------------------------------------------------------------------
    context( "getPathComponents", function()
-------------------------------------------------------------------------------

        test(
"'/' -> '/', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/" )

            assert_equal( "/", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'/path/to/' -> '/path/to/', nil nil nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/" )

            assert_equal( "/path/to/", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'/path/to/file' -> '/path/to/', 'file', 'file', nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/file" )

            assert_equal( "/path/to/", filePath )
            assert_equal( "file", fileName )
            assert_equal( "file", fileBase )
            assert_nil( fileExt )
        end )

        test(
"'/path/to/file.txt' -> '/path/to/', 'file.txt', 'file', 'txt'",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/file.txt" )

            assert_equal( "/path/to/", filePath )
            assert_equal( "file.txt", fileName )
            assert_equal( "file", fileBase )
            assert_equal( "txt", fileExt )
        end )

        test(
"'/path/to/' -> '/path/to/', 'file.txt.bak', 'file.txt', 'bak'",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/file.txt.bak" )

            assert_equal( "/path/to/", filePath )
            assert_equal( "file.txt.bak", fileName )
            assert_equal( "file.txt", fileBase )
            assert_equal( "bak", fileExt )
        end )

        test(
"'/path/to' -> '/path/to', '.file', '.file', nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/.file" )

            assert_equal( "/path/to/", filePath )
            assert_equal( ".file", fileName )
            assert_equal( ".file", fileBase )
            assert_nil( fileExt )
        end )

        test(
"'/path/to/.file.txt' -> '/path/to/', '.file.txt', '.file', 'txt'",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/.file.txt" )

            assert_equal( "/path/to/", filePath )
            assert_equal( ".file.txt", fileName )
            assert_equal( ".file", fileBase )
            assert_equal( "txt", fileExt )
        end )

        test(
"'/path/to/../' -> '/path/to/../', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/../" )

            assert_equal( "/path/to/../", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'/path/to/..' -> '/path/to/../', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/.." )

            assert_equal( "/path/to/../", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'../' -> '../', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "../" )

            assert_equal( "../", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'..' -> '../', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( ".." )

            assert_equal( "../", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'/path/to/./' -> '/path/to/./', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/./" )

            assert_equal( "/path/to/./", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'/path/to/.' -> '/path/to/./', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "/path/to/." )

            assert_equal( "/path/to/./", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'./' -> './', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "./" )

            assert_equal( "./", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

        test(
"'.' -> './', nil, nil, nil",
        function()
            local filePath, fileName, fileBase, fileExt = FileHelper.
                getPathComponents( "." )

            assert_equal( "./", filePath )
            assert_nil( fileName )
            assert_nil( fileBase )
            assert_nil( fileExt )
        end )

    end )

-------------------------------------------------------------------------------
    context( "getRequirePath", function()
-------------------------------------------------------------------------------

        test(
"'myModule' -> 'myModule'",
        function()
            local path = FileHelper.getRequirePath( "myModule" )
            assert_equal( "myModule", path )
        end )

        test(
"'myModule.lua' -> 'myModule'",
        function()
            local path = FileHelper.getRequirePath( "myModule.lua" )
            assert_equal( "myModule", path )
        end )

        test(
"'Classes/myModule' -> 'Classes.myModule'",
        function()
            local path = FileHelper.getRequirePath( "Classes/myModule" )
            assert_equal( "Classes.myModule", path )
        end )

        test(
"'Classes/myModule.lua' -> 'Classes.myModule'",
        function()
            local path = FileHelper.getRequirePath( "Classes/myModule.lua" )
            assert_equal( "Classes.myModule", path )
        end )

        test(
"'myModule.lua.lua' -> 'myModule.lua'",
        function()
            local path = FileHelper.getRequirePath( "myModule.lua.lua" )
            assert_equal( "myModule.lua", path )
        end )

        test(
"'Classes/myModule/lua' -> 'Classes.myModule.lua'",
        function()
            local path = FileHelper.getRequirePath( "Classes/myModule/lua" )
            assert_equal( "Classes.myModule.lua", path )
        end )

        test(
"'' -> nil",
        function()
            local path = FileHelper.getRequirePath( "" )
            assert_nil( path )
        end )

        test(
"nil -> nil",
        function()
            local path = FileHelper.getRequirePath( )
            assert_nil( path )
        end )

    end )

-------------------------------------------------------------------------------
    context( "trimTrailingPathSeparator", function()
-------------------------------------------------------------------------------

        test(
"'/' -> '/'",
        function()
            local path = FileHelper.trimTrailingPathSeparator( "/" )
            assert_equal( "/", path )
        end )

        test(
"'/path' -> '/path'",
        function()
            local path = FileHelper.trimTrailingPathSeparator( "/path" )
            assert_equal( "/path", path )
        end )

        test(
"'/path/' -> '/path'",
        function()
            local path = FileHelper.trimTrailingPathSeparator( "/path/" )
            assert_equal( "/path", path )
        end )

        test(
"'' -> ''",
        function()
            local path = FileHelper.trimTrailingPathSeparator( "" )
            assert_equal( "", path )
        end )

        test(
"nil -> nil",
        function()
            local path = FileHelper.trimTrailingPathSeparator( nil )
            assert_nil( path )
        end )

    end )

end )
