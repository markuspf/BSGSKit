InstallMethod( ViewString, "for a BSGSKit Stabilizer Chain",
               [ IsBSGSKit_StabChainRep ],
function(bsgs)
    return STRINGIFY("<BSGSKit StabChain with base ",
                    BSGSKit_BaseOfStabChain(bsgs), ">");
end);

#
InstallGlobalFunction( BSGSKit_BaseOfStabChain,
function(bsgs)
    if IsBound(bsgs!.stab) then
        return Concatenation( [bsgs!.basepoint]
                            , BSGSKit_BaseOfStabChain(bsgs!.stab) );
    else
        return [bsgs!.basepoint];
    fi;
end);

# Mainly for testing purposes
# Converts a GAP Stabilizer chain into a BSGSKit Stabilizer
# Chain
InstallGlobalFunction( BSGSKit_AsBSGSKitStabChain,
function(sc)
    local res;

    res := rec( basepoint := sc.orbit[1]
              , act := \^
              , gens := ShallowCopy(sc.generators) );
    res.schreiertree := BSGSKit_SchreierTree( res.gens
                                            , res.basepoint
                                            , res.act );
    if IsBound(sc.stabilizer) then
        if IsBound(sc.stabilizer.stabilizer) then
            res.stab := BSGSKit_AsBSGSKitStabChain(sc.stabilizer);
        fi;
    fi;

    return Objectify( BSGSKit_StabChainType, res );
end);

InstallGlobalFunction( BSGSKit_Strip,
function(bsgs, elt)
    local baseimage, u;

    baseimage := bsgs!.act(bsgs!.basepoint, elt);
    u := BSGSKit_TraceSchreierTreeElement(bsgs!.schreiertree, baseimage);

    # The baseimage is not in this level's orbit.
    if u = fail then
        return rec( bsgs := bsgs, elt := elt );

    # Found a representative
    else
        elt := elt * u;

        if IsBound(bsgs!.stab) then
            return BSGSKit_Strip(bsgs!.stab, elt);
        else
            return rec( bsgs := bsgs, elt := elt );
        fi;
    fi;
end);

