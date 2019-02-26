DeclareGlobalFunction( "BSGSKit_AsBSGSKitStabChain");
DeclareGlobalFunction( "BSGSKit_BaseOfStabChain" );

DeclareCategory( "IsBSGSKit_StabChain", IsObject );
DeclareRepresentation( "IsBSGSKit_StabChainRep"
                     , IsBSGSKit_StabChain and
                       IsAttributeStoringRep
                     , [ ] );
BindGlobal( "BSGSKit_StabChainFamily"
          , NewFamily("BSGSKit_StabChainFamily", IsObject));
BindGlobal( "BSGSKit_StabChainType"
          , NewType( BSGSKit_StabChainFamily, IsBSGSKit_StabChainRep ) );
