#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# Implementations
#


InstallGlobalFunction( BSGSKit_SchreierGen,
function(tree, pt, s)
    local t1, t2;
    t1 := BSGSKit_TraceSchreierTreeElement(tree, pt);
    t2 := BSGSKit_TraceSchreierTreeElement(tree, tree!.act(pt, s));
    return t1 * s * t2^-1;
end);

BSGSKit_NewLink := function(bpt, gens, act)
    return Objectify( BSGSKit_StabChainType
                    , rec( basepoint := bpt
                         , gens := gens
                         , act := act
                         , schreiertree := BSGSKit_SchreierTree(gens, bpt, act) ) );
end;

InstallGlobalFunction( BSGSKit_SchreierAdd,
function(bsgs, elt)
    Add(bsgs!.gens, elt);
    bsgs!.schreiertree := BSGSKit_SchreierTree(bsgs!.gens, bsgs!.basepoint, bsgs!.act);
    if IsBound(bsgs!.stab) then
        BSGSKit_SchreierAdd(bsgs!.stab, elt);
    fi;
end);

# bsgs := rec( basepoint, schreiertree, gens, stab, act )
InstallGlobalFunction( BSGSKit_SchreierDown,
function(bsgs, elt)
    local baseimage, u, add, e;

    add := BSGSKit_Strip(bsgs, elt);

    # stripping failed
    if not IsOne(add.elt) then
        # We reached the bottom of the chain, but still have a non-identity
        # element, so we extend the base by another point

        # meh.
        if not IsBound(bsgs!.stab) then
            add.bsgs!.stab := BSGSKit_NewLink( SmallestMovedPoint(add.elt)
                                             , [add.elt], bsgs!.act );
        else
            BSGSKit_SchreierAdd(bsgs!.stab, add.elt);
        fi;
        return true;
    fi;
    return false;
end);

InstallGlobalFunction( BSGSKit_SchreierUp,
function(bsgs)
    local T, stree, p, s, sg, sr;

    if IsBound(bsgs!.stab) then
        BSGSKit_SchreierUp(bsgs!.stab);
    fi;

    for p in bsgs!.schreiertree do
        for s in bsgs!.gens do
            sg := BSGSKit_SchreierGen(bsgs!.schreiertree, p, s);
            sr := BSGSKit_SchreierDown(bsgs, sg);

            if sr then
                BSGSKit_SchreierUp(bsgs);
            fi;
        od;
    od;

    return bsgs;
end);
