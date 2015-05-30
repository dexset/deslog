import des.log;

void func()
{
    logger.fatal( "fatal" );
    logger.error( "error" );
    logger.warn( "warn" );
    logger.info( "info" );
    logger.Debug( "debug" );
    logger.trace( "trace" );
}

void main()
{
    logger.fatal( "fatal message" );
    logger.error( "error message" );
    logger.warn( "warn message" );
    logger.info( "info message" );
    logger.Debug( "debug message" );
    logger.trace( "trace message" );

    func();
}
