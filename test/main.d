import std.stdio;

import des.log;

enum DESPACKAGE = "LOG";

void main()
{
    version(unittest)
    {
        writeln( "\n-------------------------" );
        writefln( "DES %s unittests complite", DESPACKAGE );
        writeln( "-------------------------\n" );
    }
    else stderr.writefln( "build with -unittest flag to test DES %s", DESPACKAGE );
}
