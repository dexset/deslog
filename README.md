## D Extended Set (DES) Logging System

Package provides static `Logger logger`

### Logger using

class `Logger` has functions for logging with different levels

```d
void error(Args...)( Args args );
void warn (Args...)( Args args );
void info (Args...)( Args args );
void Debug(Args...)( Args args );
void trace(Args...)( Args args );
```

and for hacking logging system in runtime

```d
static shared(OutputHandler) output() @property;
static shared(Rule) rule() @property;
```

For hacking see `example` dir

### Simple example

```d
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
```

![example output](https://github.com/dexset/deslog/blob/master/example/simple/output.png)

Flag `--log` used for setting max level of logging output.
Default level is `error`. If log function called with greater level it's skipped.
Level has attitudes `off < fatal < error < warn < info < debug < trace`.

Flag `--log` can be used with module name `./program --log draw.point:debug`.
It will set `debug` level for module `draw.point` and default to other.

Flag `--log-use-min` is boolean flag. It forces logging system to skip output from
all child modules if their level greater than parent. Default is `false`.

`./program --log trace --log draw:info --log draw.point:trace --log-use-min=true`
skips all output from `logger.trace` and `logger.Debug` from whole draw.point,
and doesn't skip from other modules.

`./program --log trace --log draw:info --log draw.point:trace` allow `log_trace`
and `log_debug` only from `draw.point` from module `draw`. For other modules in
`draw` sets level `info`

You can compile program with `version=des_log_onlyerror` for skip all
`trace`, `debug`, `info` and `warn` outputs in logger. It can improve program
release speed.

#### Class logging

Module provides some functional for useful logging classes.

Example:

```d
module x;
import des.log;
class A
{
    mixin ClassLogger;
    void func() { logger.trace( "hello" ); }
}
```
```d
module y;
import x;
class B : A { }
```
```d
auto b = new B;
b.func();
```

outputs:
```
[000000.148628473][TRACE][x.A.func]: hello
```

If create instance logger
```d
class B : A { this(){ logger = new InstanceLogger(this); } }
```

outputs:
```
[000000.148628473][TRACE][y.B.func]: hello
```

If create instance logger with instance name
```d
class B : A { this(){ logger = new InstanceLogger(this,"my object"); } }
```

outputs:
```
[000000.148628473][TRACE][y.B.[my object].func]: hello
```

If create instance full logger
```d
class B : A { this(){ logger = new InstanceFullLogger(this); } }
```

outputs:
```
[000000.148628473][TRACE][y.B.[x.A.func]]: hello
```

If create instance full logger with name

```d
class B : A { this(){ logger = new InstanceFullLogger(this,"name"); } }
```

outputs:
```
[000000.148628473][TRACE][y.B.[name].[x.A.func]]: hello
```

Flag `--log` can get full emitter string `y.B.[name].[x.A.func]`.
```
./program --log "y.B.[one]:trace" --log "y.B.[two]:debug"
```


Documentation orient to [harbored-mod](https://github.com/kiith-sa/harbored-mod)

to build doc:
```sh
cd path/to/desstdx
path/to/harbored-mod/bin/hmod
```
