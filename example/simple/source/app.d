import std.getopt;
import std.stdio;

import des.log;

static import pack1;
static import pack2;

void func()
{
    logger.fatal( "%s:%d", __FILE__, __LINE__ );
    logger.error( "%s:%d", __FILE__, __LINE__ );
    logger.warn( "%s:%d", __FILE__, __LINE__ );
    logger.info( "%s:%d", __FILE__, __LINE__ );
    logger.Debug( "%s:%d", __FILE__, __LINE__ );
    logger.trace( "%s:%d", __FILE__, __LINE__ );
}

void main( string[] args )
{
    auto go = getopt( args, log_getopt.expand );

    if( go.helpWanted )
    {
        defaultGetoptPrinter( "info", go.options );
        return;
    }

    writeln( "global rules:\n", logger.rule.strRepresent() );
    foreach( name; logger.output.names )
        writeln( name, ":\n", logger.output[name].rule.strRepresent() );

    logger.fatal( "%s:%d", __FILE__, __LINE__ );
    logger.error( "%s:%d", __FILE__, __LINE__ );
    logger.warn( "%s:%d", __FILE__, __LINE__ );
    logger.info( "%s:%d", __FILE__, __LINE__ );
    logger.Debug( "%s:%d", __FILE__, __LINE__ );
    logger.trace( "%s:%d", __FILE__, __LINE__ );

    pack1.func();
    pack2.func();
}
