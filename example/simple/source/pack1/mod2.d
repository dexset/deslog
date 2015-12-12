module pack1.mod2;

import des.log;

void func()
{
    logger.fatal( "%s:%d", __FILE__, __LINE__ );
    logger.error( "%s:%d", __FILE__, __LINE__ );
    logger.warn( "%s:%d", __FILE__, __LINE__ );
    logger.info( "%s:%d", __FILE__, __LINE__ );
    logger.Debug( "%s:%d", __FILE__, __LINE__ );
    logger.trace( "%s:%d", __FILE__, __LINE__ );
}
