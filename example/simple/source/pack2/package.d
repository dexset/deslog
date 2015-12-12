module pack2;

import des.log;
static import pack2.mod1;
static import pack2.mod2;

void func()
{
    logger.fatal( "%s:%d", __FILE__, __LINE__ );
    logger.error( "%s:%d", __FILE__, __LINE__ );
    logger.warn( "%s:%d", __FILE__, __LINE__ );
    logger.info( "%s:%d", __FILE__, __LINE__ );
    logger.Debug( "%s:%d", __FILE__, __LINE__ );
    logger.trace( "%s:%d", __FILE__, __LINE__ );
    pack2.mod1.func();
    pack2.mod2.func();
}
