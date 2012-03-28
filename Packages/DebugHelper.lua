--[[ BaseLua
     https://github.com/dejayc/BaseLua
     Copyright 2012 Dejay Clayton

     All use of this file must comply with the Apache License,
     Version 2.0, under which this file is licensed:

     http://www.apache.org/licenses/LICENSE-2.0 --]]

--[[
-------------------------------------------------------------------------------
-- Convenience functions for performing debuggin logic.

module "DebugHelper"
-------------------------------------------------------------------------------
--]]

local CLASS = {}

CLASS.indent = 1

function CLASS:incIndent()
    self.indent = self.indent + 1
    return self.indent
end

function CLASS:decIndent()
    self.indent = self.indent - 1
    return self.indent
end

function CLASS.printIndent( indent, ... )
    io.write( string.rep( " ", ( indent - 1 ) * 4 ) )
    print( ... )
    io.flush()
end

function CLASS:print( str )
    local strType = type( str )
    if ( strType == "nil" or str == "" ) then return end
    if ( strType ~= "string" ) then str = tostring( str ) end

    local firstChar = string.sub( str, 1, 1 )
    if ( firstChar == ">" ) then
        self.printIndent( self:incIndent(), string.sub( str, 2 ) )
    elseif ( firstChar == "<" or firstChar == "}" ) then
        self.printIndent( self:decIndent(), string.sub( str, 2 ) )
    else
        local lastChar = string.sub( str, -1 )
        if ( lastChar == "{" ) then
            self.printIndent( self.indent, string.sub( str, 1, -2 ) )
            self:incIndent()
        else
            self.printIndent( self.indent, str )
        end
    end
end

return CLASS
