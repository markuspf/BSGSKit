#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# Implementations
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
            res.stab := sc_to_bsgs(sc.stabilizer);
        fi;
    fi;

    return res;
end);


# bsgs := rec( basepoint, schreiertree, gens, stab, act )
InstallGlobalFunction( BSGSKit_Strip,
function(bsgs, elt)
    local baseimage, u;

    baseimage := bsgs.act(bsgs.basepoint, elt);

    if not (baseimage in bsgs.orb) then
        # can this be done by having an empty orbit in the last
        # bit of the chain?
        return [bsgs, elt];
    else
        u := BSGSKit_TraceSchreierTree(bsgs.tree, elt);
        return BSGSKit_Strip(bsgs.stab, elt * u^-1);
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


# bsgs := rec( basepoint, schreiertree, gens, stab, act )
InstallGlobalFunction( BSGSKit_SchreierDown,
function(bsgs, elt)
    local baseimage, u, add, e;

    baseimage := bsgs.act(bsgs.basepoint, elt);

    # Stripping fails because orbit not big enough
    if not (baseimage in bsgs.schreiertree.map) then
        add := elt;
    else
        u := BSGSKit_TraceSchreierTree(bsgs.schreiertree, baseimage);
        e := elt * u;

        if not IsOne(e) then
            if IsBound(bsgs.stab) then
                bsgs.stab := BSGSKit_SchreierDown(bsgs.stab, e);
            else
                # We reached the bottom of the chain, but still have a non-identity
                # element, So we extend the base by another point
                bsgs.stab := BSGSKit_NewLink( SmallestMovedPoint(e)
                                            , [e], bsgs.act );
                add := e;
            fi;
        else
            # Stripping was successful, don't need to add anything
        fi;
    fi;

    # Back up, adding generators if necessary
    if IsBound(add) then
        Print("add ", add, "\n");
        Add(bsgs.gens, add);
        bsgs.orbit := BSGSKit_SchreierTree(bsgs.gens, bsgs.basepoint, bsgs.act);
    fi;

    # BSGSKit_SchreierUp(bsgs);
    return bsgs;
end);

InstallGlobalFunction( BSGSKit_SchreierUp,
function(bsgs)
    local T, stree, p, s, sg, sr;

    if IsBound(bsgs.stab) then
        BSGSKit_SchreierUp(bsgs.stab);

        for p in Keys(bsgs.schreiertree.map) do
            for s in bsgs.gens do
                sg := BSGSKit_SchreierGen(bsgs.schreiertree, p, s);
                sr := BSGSKit_SchreierDown(bsgs, sg);
            od;
        od;
    fi;

    return bsgs;
end);

