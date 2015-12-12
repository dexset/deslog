module des.log.rule;

import std.algorithm : min;
import std.string : split, join;

import des.log.base;

/// store rules for logging
synchronized class Rule
{
package:
    shared Rule parent; ///

    LogLevel level = LogLevel.ERROR; ///
    shared Rule[string] inner; ///

    bool use_minimal = true;
    bool only_register = false;
    bool registred = false;

public:

    ///
    this( shared Rule parent = null )
    {
        this.parent = parent;
        if( parent ) this.level = parent.level;
    }

    @property
    {
        ///
        bool useMinimal() const
        {
            if( parent !is null ) return parent.useMinimal;
            else return use_minimal;
        }

        ///
        bool useMinimal( bool v )
        {
            if( parent !is null ) return parent.useMinimal = v;
            else return use_minimal = v;
        }

        ///
        bool onlyRegister() const
        {
            if( parent !is null ) return parent.onlyRegister;
            else return only_register;
        }

        ///
        bool onlyRegister( bool v )
        {
            if( parent !is null ) return parent.onlyRegister = v;
            else return only_register = v;
        }
    }

    /// setting allowed level for emitter (create new inner Rule), if emitter is "" sets self level
    void setLevel( LogLevel lvl, string emitter="" )
    { setLevelImpl( lvl, emitter.split(".") ); }

    /// if emitter is "" returns self level
    LogLevel allowedLevel( string emitter="" ) const
    { return allowedLevelImpl( emitter.split(".") ); }

    /// test is message allowed for this rule
    bool isAllowed( in LogMessage lm ) const
    { return allowedLevel( lm.emitter ) >= lm.level; }

    /// return string what represent of rule structure
    string strRepresent() const { return strRepresentImpl(); }

protected:

    void setLevelImpl( LogLevel lvl, string[] emitter )
    {
        if( emitter.length == 0 || emitter[0].length == 0 )
        {
            level = lvl;
            registred = true;
            return;
        }

        auto iname = emitter[0];

        if( iname !in inner )
            inner[iname] = new shared Rule(this);

        inner[iname].setLevelImpl( lvl, emitter.length > 1 ? emitter[1..$] : [] );
    }

    /// if emitter is "" returns self level
    LogLevel allowedLevelImpl( string[] emitter ) const
    {
        if( emitter.length == 0 || emitter[0].length == 0 )
            return level;

        auto iname = emitter[0];

        if( iname !in inner )
        {
            if( onlyRegister )
            {
                if( !(registred && parent !is null) )
                    return LogLevel.OFF;
                else
                    return level;
            }
            else return level;
        }

        auto childnames = emitter.length > 1 ? emitter[1..$] : [];

        if( useMinimal )
            return min( level, inner[iname].allowedLevelImpl( childnames ) );
        else
            return inner[iname].allowedLevelImpl( childnames );
    }

    string strRepresentImpl( string offset="", bool first=true ) const
    {
        string ret = format( "%s%s", level, registred ? " [reg]" : "" );
        if( first )
            ret ~= format( "%s%s", useMinimal ? " use minimal" : "",
                                 onlyRegister ? " only register" : "" );
        foreach( key, val; inner )
            ret ~= format( "\n%s%s : %s", offset, key,
                    val.strRepresentImpl( offset ~ mlt(" ",key.length), false ) );
        return ret;
    }
}

private T[] mlt(T)( T[] val, size_t cnt ) nothrow
{
    T[] buf;
    foreach( i; 0 .. cnt ) buf ~= val;
    return buf;
}

unittest { assert( "    ", mlt( " ", 4 ) ); }

///
unittest
{
    auto r = new shared Rule;

    r.setLevel( LogLevel.INFO );
    r.setLevel( LogLevel.TRACE, "des.gl" );
    r.setLevel( LogLevel.WARN, "des" );

    assert( r.allowedLevel() == LogLevel.INFO );
    assert( r.allowedLevel("des") == LogLevel.WARN );
    assert( r.allowedLevel("des.gl") == LogLevel.WARN );

    r.use_minimal = false;

    assert( r.allowedLevel() == LogLevel.INFO );
    assert( r.allowedLevel("des") == LogLevel.WARN );
    assert( r.allowedLevel("des.gl") == LogLevel.TRACE );
}
