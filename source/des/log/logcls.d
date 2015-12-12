module des.log.logcls;

import std.traits : EnumMembers;
import std.string : toLower, format, split;
import std.stdio : stderr;

import des.log.base;
import des.log.output;
import des.log.rule;

/// base logger class
class Logger
{
    ///
    mixin( getLogFunctions );

    ///
    static shared(OutputHandler) output() @property
    out(o) { assert( o !is null, "log output handler is null" ); }
    body { return g_output; }

    ///
    static shared(Rule) rule() @property
    out(o) { assert( o !is null, "log rule handler is null" ); }
    body { return g_rule; }

protected:

    /// check log message level allowed with current rules for emmiter
    final void procMessage( in LogMessage lm ) const nothrow
    {
        try if( rule.isAllowed(lm) ) writeLog( lm );
        catch( Exception e ) writeLogFailPrint(e);
    }

    /// exception processing
    void writeLogFailPrint( Exception e ) const nothrow
    {
        try stderr.writefln( "[INTERNAL LOG EXCEPTION]: %s", e );
        catch(Exception){}
    }

    /// write log to logoutput
    void writeLog( in LogMessage lm ) const
    { output.writeMessage( chooseOutputName(lm), lm ); }

    /// logger can chouse output name, empty (default) for broadcast
    string chooseOutputName( in LogMessage lvl ) const { return ""; }

    /// transform caller func name to emitter name
    string getEmitterName( string func_name ) const nothrow
    in{ assert( func_name.length ); }
    out(ret){ assert( ret.length ); }
    body { return func_name; }

    private static string getLogFunctions() @property
    {
        string fnc = q{
        void %1$s( string fnc=__FUNCTION__, Args... )( Args args ) const nothrow
        {
            version(des_log_onlyerror)
            {
                static if( LogMessage.Level.%2$s <= LogMessage.Level.ERROR )
                    procMessage( LogMessage( getEmitterName(fnc), __ts, LogMessage.Level.%2$s, ntFormat(args) ) );
            }
            else procMessage( LogMessage( getEmitterName(fnc), __ts, LogMessage.Level.%2$s, ntFormat(args) ) );
        }
        };

        string ret;
        foreach( lvl; [EnumMembers!(LogMessage.Level)] )
        {
            auto slvl = to!string(lvl);
            auto fname = fixReservedName( slvl.toLower );
            ret ~= format( fnc, fname, slvl );
        }
        return ret;
    }
}

/// logger for class instances
class InstanceLogger : Logger
{
protected:
    string class_name; ///
    string inst_name; ///

public:

    ///
    this( Object obj, string inst="" )
    {
        class_name = typeid(obj).name;
        inst_name = inst;
    }

    ///
    this( string obj, string inst="" )
    {
        class_name = obj;
        inst_name = inst;
    }

    nothrow @property
    {
        ///
        void instance( string i ) { inst_name = i; }

        ///
        string instance() const { return inst_name; }
    }

protected:

    /// Returns: module + class_name + inst_name (if it exists)
    override string getEmitterName( string name ) const nothrow
    {
        try return fullEmitterName ~ "." ~ name.split(".")[$-1];
        catch(Exception e) return fullEmitterName;
    }

    string fullEmitterName() const nothrow @property
    { return class_name ~ (inst_name.length?".["~inst_name~"]":""); }
}

/// logger for class instances with extended emitter name
class InstanceFullLogger : InstanceLogger
{
    ///
    this( Object obj, string inst="" ) { super(obj,inst); }

    ///
    this( string obj, string inst="" ) { super(obj,inst); }

protected:

    /// Returns: module + class_name + inst_name (if it exists) + call function name
    override string getEmitterName( string name ) const nothrow
    { return fullEmitterName ~ ".[" ~ name ~ "]"; }
}
