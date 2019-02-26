#! @Chapter Functionality
#!
#! @Section Orbits and Schreier Trees
#!
#! @Description
#!   Orbit computatio

DeclareCategory( "IsBSGSKit_SchreierTree", IsObject );
DeclareRepresentation( "IsBSGSKit_SchreierTreeRep"
                     , IsBSGSKit_SchreierTree and
                       IsAttributeStoringRep
                     , [ ] );
BindGlobal( "BSGSKit_SchreierTreeFamily"
          , NewFamily("BSGSKit_SchreierTreeFamily", IsObject));
BindGlobal( "BSGSKit_SchreierTreeType"
          , NewType( BSGSKit_SchreierTreeFamily, IsBSGSKit_SchreierTreeRep ) );

DeclareGlobalFunction( "BSGSKit_SchreierTree" );

DeclareGlobalFunction( "BSGSKit_TraceSchreierTreeWord" );
DeclareGlobalFunction( "BSGSKit_TraceSchreierTreeElement" );

DeclareGlobalFunction( "BSGSKit_Orbit_Depths" );
DeclareGlobalFunction( "BSGSKit_Orbit_Complete" );
DeclareGlobalFunction( "BSGSKit_Orbit_PermGroup_Natural" );
