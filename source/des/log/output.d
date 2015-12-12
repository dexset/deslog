module des.log.output;

import std.stdio : stdout, stderr;
import std.string : toStringz;
import std.datetime;
import std.exception;

import des.log.base;
import des.log.rule;

/// output for logger
synchronized abstract class LogOutput
{
    Rule rule;
    private bool _enable = true;

    @property
    {
        bool enable() const { return _enable; }
        bool enable( bool v ) { _enable = v; return v; }
    }

    this()
    {
        rule = new shared Rule;
        rule.setLevel( LogLevel.TRACE );
    }

    ///
    void opCall( in LogMessage lm )
    {
        if( enable && rule.isAllowed(lm) )
            writeMessage( lm, formatLogMessage( lm ) );
    }

protected:

    ///
    void writeMessage( in LogMessage, string );

    /// by default call des.util.logsys.base.defaultFormatLogMessage
    string formatLogMessage( in LogMessage lm ) const
    out(ret){ assert( ret.length ); }
    body { return defaultFormatLogMessage( lm ); }
}

///
synchronized class NullLogOutput : LogOutput
{
protected:
    override
    {
        /// empty
        void writeMessage( in LogMessage, string ) {}

        /// not call formating message
        string formatLogMessage( in LogMessage lm ) const { return "null"; }
    }
}

/// output to file
synchronized class FileLogOutput : LogOutput
{
    import core.stdc.stdio;
    import std.exception;
    FILE* file;

    ///
    this( string fname )
    {
        file = enforce( fopen( fname.toStringz, "a\0".ptr ),
                "Cannot open file '" ~ fname ~ "' in append mode" );
        fprintf( file, "%s\n", firstLine().toStringz );
    }

    ~this() { fclose( file ); }

protected:

    /// 
    override void writeMessage( in LogMessage, string msg ) { fprintf( file, "%s\n", msg.toStringz ); }

    /++ call from ctor and past to file first line with datetime
        Returns:
        format( "%02d.%02d.%4d %02d:%02d:%02d", dt.day, dt.month, dt.year, dt.hour, dt.minute, dt.second );
     +/
    string firstLine() const
    {
        import core.runtime;
        import std.datetime;
        import std.array;

        auto dt = Clock.currTime;
        return format( "%02d.%02d.%4d %02d:%02d:%02d %s",
                dt.day, dt.month, dt.year, dt.hour, dt.minute, dt.second,
                Runtime.args.join(" ") );
    }
}

///
synchronized class ConsoleLogOutput : LogOutput
{
    /// log messages with level > ERROR puts to stdout, and stderr otherwise
    protected override void writeMessage( in LogMessage lm, string str )
    {
        if( lm.level > LogMessage.Level.ERROR )
            stdout.writeln( str );
        else
            stderr.writeln( str );
    }
}

/// colorise console output with escape seqence
synchronized class ColorConsoleLogOutput : ConsoleLogOutput
{
protected:

    import des.log.consolecolor;

    /// formatting with colors
    override string formatLogMessage( in LogMessage lm ) const
    {
        auto color = chooseColors( lm );
        return format( "[%6$s%1$016.9f%5$s][%7$s%2$5s%5$s][%8$s%3$s%5$s]: %9$s%4$s%5$s",
                       lm.ts / 1e9f, lm.level, lm.emitter, lm.message,
                       cast(string)CEColor.OFF, color[0], color[1], color[2], color[3] );
    }

    /// returns 4 colors for timestamp, log level, emitter name, message text
    string[4] chooseColors( in LogMessage lm ) const
    {
        string clr;

        final switch( lm.level )
        {
            //case LogMessage.Level.FATAL: clr = CEColor.FG_BLACK ~ CEColor.BG_RED; break;
            case LogMessage.Level.FATAL: clr = CEColor.FG_BI_RED; break;
            case LogMessage.Level.ERROR: clr = CEColor.FG_RED; break;
            case LogMessage.Level.WARN: clr = CEColor.FG_PURPLE; break;
            case LogMessage.Level.INFO: clr = CEColor.FG_CYAN; break;
            case LogMessage.Level.DEBUG: clr = CEColor.FG_YELLOW; break;
            case LogMessage.Level.TRACE: break;
        }

        return [clr,clr,clr,clr];
    }
}

/// main logging output center
synchronized class OutputHandler
{
package:
    LogOutput[string] list; ///

    ///
    this()
    {
        version(linux)
            list[console] = new shared ColorConsoleLogOutput;
        else
            list[console] = new shared ConsoleLogOutput;
    }

    /// call from Logger.writeLog by default
    void writeMessage( string output_name, in LogMessage lm )
    {
        if( output_name.length )
        {
            if( output_name in list )
                list[output_name](lm);
        }
        else foreach( name, lo; list ) lo(lm);
    }

public:

    enum console = "console"; ///

    /// get output
    shared(LogOutput) opIndex( string name )
    {
        enforce( name in list, LogException.fmt( "no output named '%s'", name ) );
        return list[name];
    }

    /// set output
    shared(LogOutput) opIndexAssign( shared LogOutput output, string name )
    in{ assert( output !is null ); } body
    { return list[name] = output; }

    string[] names() @property { return list.keys; }

    ///
    void remove( string name )
    {
        if( name == console )
            throw new LogException( "can not unregister '" ~ name ~ "' log output" );
        list.remove( name );
    }
}
