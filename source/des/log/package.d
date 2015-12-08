/++ ### Simple example
 +
 + ---
 + import des.log;
 +
 + void func()
 + {
 +     logger.fatal( "fatal" );
 +     logger.error( "error" );
 +     logger.warn( "warn" );
 +     logger.info( "info" );
 +     logger.Debug( "debug" );
 +     logger.trace( "trace" );
 + }
 +
 + void main()
 + {
 +     logger.fatal( "fatal message" );
 +     logger.error( "error message" );
 +     logger.warn( "warn message" );
 +     logger.info( "info message" );
 +     logger.Debug( "debug message" );
 +     logger.trace( "trace message" );
 +
 +     func();
 + }
 + ---
 +
 + can have output like this:
 +
 + ---
 + ./app
 + [000000.000122258][FATAL][app.main]: fatal message
 + [000000.000214030][ERROR][app.main]: error message
 + [000000.000261067][FATAL][app.func]: fatal
 + [000000.000285349][ERROR][app.func]: error
 + ---
 +

 + Flag `--log` used for setting max level of logging output.
 + Default level is `error`. If log function called with greater level it's skipped.
 + Level has attitudes `off < fatal < error < warn < info < debug < trace`.
 +
 +
 + ---
 + $ ./app --log app.func:debug
 + [log use min]: false
 + [log rules]:
 + ERROR
 + app : ERROR
 +    func : DEBUG
 + [000000.000162889][FATAL][app.main]: fatal message
 + [000000.000207483][ERROR][app.main]: error message
 + [000000.000242506][FATAL][app.func]: fatal
 + [000000.000261887][ERROR][app.func]: error
 + [000000.000285754][ WARN][app.func]: warn
 + [000000.000304789][ INFO][app.func]: info
 + [000000.000323652][DEBUG][app.func]: debug
 + ---
 +
 +
 + ---
 + $ ./app --log info --log app.func:trace
 + [log use min]: false
 + [log rules]:
 + INFO
 + app : INFO
 +    func : TRACE
 + [000000.000245525][FATAL][app.main]: fatal message
 + [000000.000308796][ERROR][app.main]: error message
 + [000000.000338714][ WARN][app.main]: warn message
 + [000000.000365555][ INFO][app.main]: info message
 + [000000.000406501][FATAL][app.func]: fatal
 + [000000.000434482][ERROR][app.func]: error
 + [000000.000461296][ WARN][app.func]: warn
 + [000000.000487242][ INFO][app.func]: info
 + [000000.000512884][DEBUG][app.func]: debug
 + [000000.000538288][TRACE][app.func]: trace
 + ---
 +
 +
 + Flag `--log` can be used with module name `./program --log draw.point:debug`.
 + It will set `debug` level for module `draw.point` and default to other.
 +
 + Flag `--log-use-min` is boolean flag. It forces logging system to skip output from
 + all child modules if their level greater than parent. Default is `false`.
 +
 + `./program --log trace --log draw:info --log draw.point:trace --log-use-min=true`
 + skips all output from `logger.trace` and `logger.Debug` from whole draw.point,
 + and doesn't skip from other modules.
 +
 + `./program --log trace --log draw:info --log draw.point:trace` allow `log_trace`
 + and `log_debug` only from `draw.point` from module `draw`. For other modules in
 + `draw` sets level `info`
 +
 + You can compile program with `version=des_log_onlyerror` for skip all
 + `trace`, `debug`, `info` and `warn` outputs in logger. It can improve program
 + release speed.
 +
 + ### Class logging
 +
 + Module provides some functional for useful logging classes.
 +
 + Example:
 +
 + ---
 + module x;
 + import des.log;
 + class A
 + {
 +     mixin ClassLogger;
 +     void func() { logger.trace( "hello" ); }
 + }
 + ---
 + ---
 + module y;
 + import x;
 + class B : A { }
 + ---
 + ---
 + auto b = new B;
 + b.func();
 + ---
 + 
 + outputs:
 + ---
 + [000000.148628473][TRACE][x.A.func]: hello
 + ---
 + 
 + If create instance logger
 + ---
 + class B : A { this(){ logger = new InstanceLogger(this); } }
 + ---
 + 
 + outputs:
 + ---
 + [000000.148628473][TRACE][y.B.func]: hello
 + ---
 + 
 + If create instance logger with instance name
 + ---
 + class B : A { this(){ logger = new InstanceLogger(this,"my object"); } }
 + ---
 + 
 + outputs:
 + ---
 + [000000.148628473][TRACE][y.B.[my object].func]: hello
 + ---
 + 
 + If create instance full logger
 + ---
 + class B : A { this(){ logger = new InstanceFullLogger(this); } }
 + ---
 + 
 + outputs:
 + ---
 + [000000.148628473][TRACE][y.B.[x.A.func]]: hello
 + ---
 + 
 + If create instance full logger with name
 + 
 + ---
 + class B : A { this(){ logger = new InstanceFullLogger(this,"name"); } }
 + ---
 + 
 + outputs:
 + ---
 + [000000.148628473][TRACE][y.B.[name].[x.A.func]]: hello
 + ---
 + 
 + Flag `--log` can get full emitter string `y.B.[name].[x.A.func]`.
 + ---
 + ./program --log "y.B.[one]:trace" --log "y.B.[two]:debug"
 + ---
 +/
module des.log;

public
{
    import des.log.base;
    import des.log.logcls;
    import des.log.rule;
    import des.log.output;
}

import core.runtime, std.getopt;
import std.stdio;
import std.file;

/// for simple adding logging to class
mixin template ClassLogger()
{
    static if( !is( typeof( __logger ) ) )
    {
        private Logger __logger;
        protected nothrow final @property
        {
            const(Logger) logger() const
            {
                mixin( "static import " ~ __MODULE__ ~ ";" );
                if( __logger is null )
                    mixin( "return " ~ __MODULE__ ~ ".logger;" );
                else return __logger;
            }
            void logger( Logger lg ) { __logger = lg; }
        }
    }
}

Logger logger; ///

static this() { logger = new Logger; }

GetoptResult logger_getopt_result;

shared static this()
{
    if( g_rule !is null ) return;

    g_rule = new shared Rule;

    auto args = thisExePath ~ Runtime.args;
    string[] logging;
    bool use_minimal = false;
    bool console_color = true;
    string logfile;

    try
    {
        logger_getopt_result = getopt( args,
                std.getopt.config.passThrough,
                "log", &logging,
                "log-use-min", &use_minimal,
                "log-console-color", &console_color,
                "log-file", &logfile,
              );
    }
    catch( Exception e ) stderr.writefln( "bad log arguments: %s", e.msg );

    g_output = new shared OutputHandler( console_color );

    if( logfile.length )
        g_output.append( "logfile", new shared FileLogOutput(logfile) );

    g_rule.use_minimal = use_minimal;

    foreach( ln; logging )
    {
        auto sp = ln.split(":");
        if( sp.length == 1 )
        {
            try g_rule.setLevel( toLogLevel( sp[0] ) );
            catch( Exception e )
                stderr.writefln( "log argument '%s' can't conv to LogLevel: %s", ln, e.msg );
        }
        else if( sp.length == 2 )
        {
            try
            {
                auto level = toLogLevel( sp[1] );
                g_rule.setLevel( level, sp[0] );
            }
            catch( Exception e )
                stderr.writefln( "log argument '%s' can't conv '%s' to LogLevel: %s", ln, sp[1], e.msg );
        }
        else stderr.writefln( "bad log argument: %s" );
    }

    if( logging.length )
    {
        writeln( "[log use min]: ", use_minimal );
        writeln( "[log rules]:\n", g_rule.print() );
    }
}
