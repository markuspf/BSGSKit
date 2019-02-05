#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# Implementations
#

# 
InstallGlobalFunction( BSGSKit_BaseOfStabChain,
function(bsgs)
    if IsBound(bsgs.stab) then
        return Concatenation([bsgs.basepoint], BSGSKit_BaseOfStabChain(bsgs.stab));
    else
        return [bsgs.basepoint];
    fi;
end);

# Mainly for testing purposes
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

    return res;
end);


# bsgs := rec( basepoint, schreiertree, gens, stab, act )
InstallGlobalFunction( BSGSKit_Strip,
function(bsgs, elt)
    local baseimage, u;

    baseimage := bsgs.act(bsgs.basepoint, elt);
    u := BSGSKit_TraceSchreierTree(bsgs.schreiertree, baseimage);

    # The baseimage is not in this level's orbit.
    if u = fail then
        return [bsgs, elt];

    # Found a representative
    else
        elt := elt * u;

        if IsBound(bsgs.stab) then
            return BSGSKit_Strip(bsgs.stab, elt);
        else
            return [bsgs, elt];
        fi;
    fi;
end);

InstallGlobalFunction( BSGSKit_SchreierGen,
function(tree, pt, s)
    local t1,t2;
    t1 := BSGSKit_TraceSchreierTree(tree, pt);
    t2 := BSGSKit_TraceSchreierTree(tree, tree.act(pt, s));
    return t1 * s * t2^-1;
end);

BSGSKit_NewLink := function(bpt, gens, act)
    return rec( basepoint := bpt
              , gens := gens
              , act := act
              , schreiertree := BSGSKit_SchreierTree(gens, bpt, act) );
end;

InstallGlobalFunction( BSGSKit_SchreierAdd,
function(bsgs, elt)

    Add(bsgs.gens, elt);
    bsgs.orbit := BSGSKit_SchreierTree(bsgs.gens, bsgs.basepoint, bsgs.act);
    if IsBound(bsgs.stab) then
        BSGSKit_SchreierAdd(bsgs.gens, elt);
    fi;
end);

# bsgs := rec( basepoint, schreiertree, gens, stab, act )
InstallGlobalFunction( BSGSKit_SchreierDown,
function(bsgs, elt)
    local baseimage, u, add, e;

    add := BSGSKit_Strip(bsgs, elt);

    # stripping failed
    if not IsOne(add[2]) then
        # We reached the bottom of the chain, but still have a non-identity
        # element, so we extend the base by another point

        # meh.
        if not IsBound(bsgs.stab) then
            add[1].stab := BSGSKit_NewLink( SmallestMovedPoint(e)
                                        , [e], bsgs.act );
        else
            # TODO: .stab ok?
            BSGSKit_SchreierAdd(bsgs.stab, add[2]);
        fi;
        return true;
    fi;
    return false;
end);

InstallGlobalFunction( BSGSKit_SchreierUp,
function(bsgs)
    local T, stree, p, s, sg, sr;

    if IsBound(bsgs.stab) then
        BSGSKit_SchreierUp(bsgs.stab);

        for p in Keys(bsgs.schreiertree.map) do
            for s in bsgs.gens do
                sg := BSGSKit_SchreierGen(bsgs.schreiertree, p, s);
                Print("SchreierGen: ", sg, "\n");
                sr := BSGSKit_SchreierDown(bsgs, sg);

                # TODO: Hack
                if sr then
                    BSGSKit_SchreierUp(bsgs);
                fi;
            od;
        od;
    fi;

    return bsgs;
end);

