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
InstallGlobalFunction( BSGSKit_SchreierTree,
function( gens, pt, act )
    local orbit, labels, new, s, p, pp, k;

    k := Length(gens);
    labels := [1..Length(gens)];

    orbit := HashMap();
    new := PlistDeque(1024);

    orbit[pt] := -1;
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

InstallGlobalFunction( BSGSKit_Orbit_Depths,
function( gens, pt, act )
    local orbit, labels, new, s, p, pp, k;

    k := Length(gens);
    labels := [1..Length(gens)];

    orbit := HashMap();
    new := PlistDeque(1024);

    orbit[pt] := [-1, 0];
    PushBack(new, [pt,0]);
    repeat
        p := PopFront(new);
        for s in [1..k] do
            pp := act(p[1], gens[s]);
            if not (pp in orbit) then
                orbit[pp] := [s, p[2] + 1, p[1]];
                PushBack(new, [pp, p[2] + 1]);
            fi;
        od;
    until IsEmpty(new);
    return rec( map := orbit, gens := gens, labels := labels, act := act );
end);

# Compute all representatives
InstallGlobalFunction( BSGSKit_Orbit_Complete,
function( gens, pt, act )
    local orbit, labels, new, s, p, pp, k;

    k := Length(gens);
    labels := [1..Length(gens)];

    orbit := HashMap();
    new := PlistDeque(1024);

    orbit[pt] := [0, ()];
    PushBack(new, [pt, ()]);
    repeat
        p := PopFront(new);
        for s in [1..k] do
            pp := act(p[1], gens[s]);
            if not (pp in orbit) then
                orbit[pp] := [s, p[2] * gens[s]];
                PushBack(new, [pp, p[2] * gens[s]]);
            fi;
        od;
    until IsEmpty(new);
    return rec( map := orbit, gens := gens, labels := labels, act := act );
end);

InstallGlobalFunction( BSGSKit_Orbit_PermGroup_Natural,
function(gens,pt)
    local orbit, labels, new, s, p, pp, k;
    k := Length(gens);
    labels := [1..Length(gens)];

    orbit := 0 * [1..LargestMovedPoint(gens)];
    new := PlistDeque(1024);

    orbit[pt] := -1;
    PushBack(new, pt);
    repeat
        p := PopFront(new);
        for s in [1..k] do
            pp := p ^ gens[s];
            if orbit[pp] = 0 then
                orbit[pp] := s;
                PushBack(new, pp);
            fi;
        od;
    until IsEmpty(new);
    return rec( map := orbit, gens := gens, labels := labels, act := \^ );
end);


# Computes the element g of G such that
# pt^g = base
InstallGlobalFunction( BSGSKit_TraceSchreierTree,
function(tree, pt)
    local g, gen, elt;

    if pt in tree.map then
#         g := [];
        g := ();
        elt := tree.map[pt];
        while elt <> -1 do
            gen := tree.gens[elt]^-1; # might want to just pre-compute inverses...
            g := g * gen;
            #    Add(g, elt);
            pt := tree.act(pt, gen);
            elt := tree.map[pt];
        od;
        return g;
    else
        return fail;
    fi;
end);
