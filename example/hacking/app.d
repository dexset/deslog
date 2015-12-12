import des.log;
import std.getopt;

// write log to string array
synchronized class StringLogOutput : LogOutput
{
    string[] result;

protected:
    override void writeMessage( in LogMessage, string msg )
    { result ~= msg; }

    override string formatLogMessage( in LogMessage lm ) const
    { return format( "[%s]: %s", lm.level, lm.message ); }
}

// skip logoutput system
class FastStderrLogger : Logger
{
    protected override void writeLog( in LogMessage lm ) const
    { stderr.writeln( defaultFormatLogMessage( lm ) ); }
}

class A
{
    mixin ClassLogger;

    this()
    {
        logger = new FastStderrLogger;
        callAll();
    }

    void callAll()
    {
        logger.fatal( "fatal message" );
        logger.error( "error message" );
        logger.warn( "warn message" );
        logger.info( "info message" );
        logger.Debug( "debug message" );
        logger.trace( "trace message" );
    }
}

void main( string[] args )
{
    getopt( args, log_getopt.expand );

    auto slo = new shared StringLogOutput;
    logger.output["string"] = slo;
    logger.output["console"].enable = false;

    scope a = new A;

    logger.fatal( "fatal message" );
    logger.error( "error message" );
    logger.warn( "warn message" );
    logger.output["console"].enable = true;
    logger.info( "info message" );
    logger.Debug( "debug message" );
    logger.trace( "trace message" );

    stdout.writeln( "log result: ", slo.result );
}
