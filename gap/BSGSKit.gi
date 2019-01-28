#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# Implementations
#

# bsgs := rec( basepoint, schreiertree, gens, stab, act )
InstallGlobalFunction( BSGSKit_Strip,
function(bsgs, elt)
    local baseimage, u;

    baseimage := bsgs.act(bsgs.basepoint, elt);

    if not (baseimage in bsgs.orb) then
        # can this be done by having an empty orbit in the last
        # bit of the chain?
        return elt;
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
    # TODO: This is a product of permutations, which also
    #       is produced by tracing
    #       so we can make a permutation word here by
    #       concatenating?
    return t1 * s * t2^-1;
end);

InstallGlobalFunction( BSGSKit_Schreier,
function(bsgs)
    local T, stree, p, s, g, base;

    base := bsgs.base; # cumulative base, don't like it.
    stree := BSGSKit_SchreierTree(bsgs.gens, bsgs.basepoint, bsgs.act);

    # enumerating schreier tree seems to be a thing
    for p in stree do
        for s in bsgs.gens do
            # We know the trace of p already, yet compute it
            # again.
            g := BSGSKit_SchreierGen(bsgs, p, s);
#            Add(S,g); Add(S,g^-1);
            if base^g = base then
#                Add(base, newpoint);
                # add new base point
            fi;
        od;
    od;

    return bsgs;
end);

