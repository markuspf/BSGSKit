#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
#! @Chapter Introduction
#!
#! BSGSKit contains implementations of algorithms to determine
#! and handle base and strong generating sets for groups.
#!
#! We aim for these algorithms to be simple and transparent
#!

DeclareInfoClass( "BSGSKit_SchreierSims" );


DeclareGlobalFunction( "BSGSKit_SchreierDown" );
DeclareGlobalFunction( "BSGSKit_SchreierUp" );

DeclareGlobalFunction( "BSGSKit_Strip" );
DeclareGlobalFunction( "BSGSKit_SchreierGen" );
DeclareGlobalFunction( "BSGSKit_Schreier" );

DeclareGlobalFunction( "BSGSKit_AsBSGSKitStabChain");
DeclareGlobalFunction( "BSGSKit_BaseOfStabChain" );

#! @Description
#!
DeclareGlobalFunction( "BSGSKit_TraceSchreierTree" );
DeclareGlobalFunction( "BSGSKit_TraceSchreierTree_2" );
