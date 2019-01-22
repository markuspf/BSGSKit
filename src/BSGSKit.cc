/*
 * BSGSKit: A collection of Base and Strong Generating Set Algorithms
 */

extern "C" {
#include "src/compiled.h"          /* GAP headers */
}

// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    { 0 } /* Finish with an empty entry */
};

/******************************************************************************
**
*F  InitKernel( <module> ) . . . . . . . . .  initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success */
    return 0;
}

/******************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success */
    return 0;
}

/******************************************************************************
**
*F  Init__Dynamic() . . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
 /* type        = */ MODULE_DYNAMIC,
 /* name        = */ "BSGSKit",
 /* revision_c  = */ 0,
 /* revision_h  = */ 0,
 /* version     = */ 0,
 /* crc         = */ 0,
 /* initKernel  = */ InitKernel,
 /* initLibrary = */ InitLibrary,
 /* checkInit   = */ 0,
 /* preSave     = */ 0,
 /* postSave    = */ 0,
 /* postRestore = */ 0,
 /* moduleStateSize      = */ 0,
 /* moduleStateOffsetPtr = */ 0,
 /* initModuleState      = */ 0,
 /* destroyModuleState   = */ 0,
};

extern "C"
StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
