--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for files, file systems, file names, and directories.

module "FileHelper"
-------------------------------------------------------------------------------
--]]

local BaseLua = require( "BaseLua" )
local StringHelper = require( BaseLua.package.StringHelper )

--- FileHelper class fields.
-- @class table
-- @name FileHelper
-- @field FILE_EXTENSION_SEPARATOR Indicates the character that separates base
--   file names from file extensions.  Statically assigned the value "."
-- @field FILE_EXTENSION_SPLIT_PATTERN The Lua pattern that can be used to
--   identify file extensions from file names.
-- @field LUA_FILE_EXTENSION Indicates the common file extension for Lua
--   source code files.  Statically assigned the value ".lua"
-- @field PATH_CURRENT_DIRECTORY Indicates that convention for specifying the
--   current directory in a path.  Statically assigned the value "."
-- @field PATH_PARENT_DIRECTORY Indicates the convention for specifying the
--   parent directory in a path.  Statically assigned the value ".."
-- @field PATH_SEPARATOR Indicates the character that separates subdirectories
--   in paths.  Assigned based on the environment during runtime; usually
--   either "/" or "\"
-- @field PATH_FILE_NAME_SPLIT_PATTERN The Lua pattern that can be used to
--   identify path and file names from paths that contain file names.
-- @field PATH_TRIM_PATTERN The Lua pattern that can be used to identify the
--   leading path from in paths that contain file names.
local CLASS = {}

CLASS.FILE_EXTENSION_SEPARATOR = "."
CLASS.FILE_EXTENSION_SPLIT_PATTERN = string.format(
    "^(.-)([.]?[^.]*)$", CLASS.FILE_EXTENSION_SEPARATOR )
CLASS.LUA_FILE_EXTENSION = CLASS.FILE_EXTENSION_SEPARATOR .. "lua"
CLASS.PATH_CURRENT_DIRECTORY = "."
CLASS.PATH_PARENT_DIRECTORY = ".."
CLASS.PATH_SEPARATOR = package.config:sub( 1, 1 )
CLASS.PATH_FILE_NAME_SPLIT_PATTERN = string.format(
    "^(.-)([^%s]*)$", CLASS.PATH_SEPARATOR )
CLASS.PATH_TRIM_PATTERN = string.format(
    "^[%s]?(.-)[%s]?$", CLASS.PATH_SEPARATOR, CLASS.PATH_SEPARATOR )

--- Returns the base path, file name, file base name, and file extension
-- components of the specified path.
-- @name getPathComponents
-- @param path The path to split into separate components.
-- @return The base path of the specified path.
-- @return The file name of the specified path.
-- @return The file base name of the specified path.
-- @return The file extension of the specified path.
-- components of the specified path.
-- @usage getPathComponents( "/" ) -- "/", nil, nil, nil
-- @usage getPathComponents( "/path/to/" ) -- "/path/to/", nil, nil, nil
-- @usage getPathComponents( "/path/to/file" )
--   -- "/path/to/", "file", "file", nil
-- @usage getPathComponents( "/path/to/file.txt" )
--   -- "/path/to/", "file.txt", "file", "txt"
-- @usage getPathComponents( "/path/to/file.txt.bak" )
--   -- "/path/to", "file.txt.bak", "file.txt", "bak"
-- @usage getPathComponents( "/path/to/.file" )
--   -- "/path/to/", ".file", ".file", nil
-- @usage getPathComponents( "/path/to/.file.txt" )
--   -- "/path/to/", ".file.txt", ".file", "txt"
-- @usage getPathComponents( "/path/to/../" )
--   -- "/path/to/..", nil, nil, nil
-- @usage getPathComponents( "/path/to/.." )
--   -- "/path/to/../", nil, nil, nil
-- @usage getPathComponents( "../" )
--   -- "../", nil, nil, nil
-- @usage getPathComponents( ".." )
--   -- "../", nil, nil, nil
-- @usage getPathComponents( "/path/to/./" )
--   -- "/path/to/./", nil, nil, nil
-- @usage getPathComponents( "/path/to/." )
--   -- "/path/to/./", nil, nil, nil
-- @usage getPathComponents( "./" )
--   -- "./", nil, nil, nil
-- @usage getPathComponents( "." )
--   -- "./", nil, nil, nil
-- @see http://stackoverflow.com/a/1403489
function CLASS.getPathComponents( path )
    path = path or ""

    local filePath, fileName = string.match(
        path, CLASS.PATH_FILE_NAME_SPLIT_PATTERN )

    if ( filePath == nil ) then
        filePath, fileName = "", path
    elseif ( fileName == CLASS.PATH_CURRENT_DIRECTORY or
        fileName == CLASS.PATH_PARENT_DIRECTORY )
    then
        filePath, fileName = filePath .. fileName .. CLASS.PATH_SEPARATOR, ""
    end

    if ( filePath == "" ) then
        filePath = nil
    end

    local fileBase, fileExt = string.match(
        fileName, CLASS.FILE_EXTENSION_SPLIT_PATTERN )

    if ( fileBase == "" and fileExt ~= "" ) then
        fileBase, fileExt = fileExt, ""
    end

    if ( fileName == "" ) then fileName = nil end
    if ( fileBase == "" ) then fileBase = nil end

    if ( fileExt == "" ) then
        fileExt = nil
    elseif ( fileExt ~= CLASS.FILE_EXTENSION_SEPARATOR and
        StringHelper.startsWith( fileExt, CLASS.FILE_EXTENSION_SEPARATOR ) )
    then
        fileExt = string.sub(
            fileExt, 1 + string.len( CLASS.FILE_EXTENSION_SEPARATOR ) )
    end

    return filePath, fileName, fileBase, fileExt
end

--- Translates the specified path into a format compatible with the Lua
-- "require" function.
-- @name getRequirePath
-- @param filePath The path to be translated.
-- @return The specified path translated into a format compatible with the
--   Lua "require" function.
-- @usage getRequirePath( "myModule" ) -- "myModule"
-- @usage getRequirePath( "myModule.lua" ) -- "myModule"
-- @usage getRequirePath( "Classes/myModule" ) -- "Classes.myModule"
-- @usage getRequirePath( "Classes/myModule.lua" ) -- "Classes.myModule"
-- @usage getRequirePath( "myModule.lua.lua" ) -- "myModule.lua"
-- @usage getRequirePath( "Classes/myModule/lua" ) -- "Classes.myModule.lua"
-- @usage getRequirePath( "" ) -- nil
-- @usage getRequirePath( nil ) -- nil
function CLASS.getRequirePath( filePath )
    if ( StringHelper.endsWith( filePath, CLASS.LUA_FILE_EXTENSION, true ) )
    then
        filePath = string.sub(
            filePath, 1, -1 * ( string.len( CLASS.LUA_FILE_EXTENSION ) + 1 ) )
    end

    if ( filePath == nil or filePath == "" or
         filePath == CLASS.PATH_SEPARATOR )
    then
        return
    end

    return string.gsub(
        string.match( filePath, CLASS.PATH_TRIM_PATTERN ),
        CLASS.PATH_SEPARATOR, BaseLua.PACKAGE_PATH_SEPARATOR )
end

--- Returns the specified path without a trailing path separator character.
-- @name trimTrailingPathSeparator
-- @param filePath The specified path from which to remove the trailing path
--   separator character.
-- @preturn The specified path without a trailing path separator character.
-- @usage trimTrailingPathSeparator( "/" ) -- "/"
-- @usage trimTrailingPathSeparator( "/path" ) -- "/path"
-- @usage trimTrailingPathSeparator( "/path/" ) -- "/path"
-- @usage trimTrailingPathSeparator( "" ) -- ""
-- @usage trimTrailingPathSeparator( nil ) -- nil
function CLASS.trimTrailingPathSeparator( filePath )
    if ( filePath ~= CLASS.PATH_SEPARATOR and
        StringHelper.endsWith( filePath, CLASS.PATH_SEPARATOR ) )
    then
        return string.sub(
            filePath, 1, -1 * (1 + string.len( CLASS.PATH_SEPARATOR ) ) )
    end

    return filePath
end

return CLASS
