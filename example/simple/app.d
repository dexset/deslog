import std.getopt;
import des.log;

class A
{
    mixin ClassLogger;

    this( string name ) { logger = new InstanceLogger("my class A",name); }

    void func1()
    {
        logger.fatal( "%s:%d",__FILE__,__LINE__ );
        logger.error( "error" );
        logger.warn( "warn" );
        logger.info( "info" );
        logger.Debug( "debug" );
        logger.trace( "trace" );
    }

    void func2()
    {
        logger.fatal( "%s:%d",__FILE__,__LINE__ );
        logger.error( "error" );
        logger.warn( "warn" );
        logger.info( "info" );
        logger.Debug( "debug" );
        logger.trace( "trace" );
    }
}

class B : A
{
    this( string name )
    {
        super( name );
        logger = new InstanceFullLogger(this,name);
    }

    override void func2()
    {
        logger.fatal( "%s:%d",__FILE__,__LINE__ );
        logger.error( "error" );
        logger.warn( "warn" );
        logger.info( "info" );
        logger.Debug( "debug" );
        logger.trace( "trace" );
    }
}

void func()
{
    logger.fatal( "%s:%d",__FILE__,__LINE__ );
    logger.error( "error" );
    logger.warn( "warn" );
    logger.info( "info" );
    logger.Debug( "debug" );
    logger.trace( "trace" );
}

void main( string[] args )
{
    //getopt( args, std.getopt.config.passThrough, log_getopt.expand );
    getopt( args, log_getopt.expand );

    import std.stdio;

    logger.info( "global logger rules\n", logger.rule.strRepresent() );
    foreach( name; logger.output.names )
        logger.info( name, "\n", logger.output[name].rule.strRepresent() );

    logger.fatal( "fatal message" );
    logger.error( "error message" );
    logger.warn( "warn message" );
    logger.info( "info message" );
    logger.Debug( "debug message" );
    logger.trace( "trace message" );

    func();

    auto foo = new A( "foo" );
    auto bar = new A( "bar" );
    auto baz = new B( "baz" );

    foo.func1();
    foo.func2();

    bar.func1();
    bar.func2();

    baz.func1();
    baz.func2();
}
