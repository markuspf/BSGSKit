#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# Implementations
#


#
# Options for orbits
#  - Compute just the orbit (no use for Schreier-Sims)
#  - Compute orbit with representatives (uses memory)
#  - Compute a Schreier Vector (makes sifting slower)
#  - Compute orbit with Schreier Vector that is made shallow(er)
#

#
# This is just a simple, universal orbit computation
#
# We call pt the base point of the orbit.
# TODO: Consider whether this is a good name
#
InstallGlobalFunction( BSGSKit_Orbit,
function( gens, pt, act )
    local orbit, labels, new, s, p, pp, k;

    k := Length(gens);
    labels := [1..Length(gens)];

    orbit := HashMap();
    new := PlistDeque(1024);

    orbit[pt] := 0;
    PushBack(new, pt);
    repeat
        p := PopFront(new);
        for s in [1..k] do
            pp := act(p, gens[s]);
            if not (pp in orbit) then
                orbit[pp] := s;
                PushBack(new, pp);
            fi;
        od;
    until IsEmpty(new);
    return rec( map := orbit, gens := gens, labels := labels, act := act );
end);

# Computes the element g of G such that
# pt^g = base
InstallGlobalFunction( BSGSKit_TraceSchreierTree,
function(tree, pt)
    local g, gen, elt;

    if pt in tree.map then
        g := One(tree.gens);
        elt := tree.map[pt];
        while elt <> 0 do
            gen := tree.gens[elt]^-1;
            g := gen * g;
            pt := tree.act(pt, gen);
            elt := tree.map[pt];
        od;
        return g;
    else
        return fail;
    fi;
end);
