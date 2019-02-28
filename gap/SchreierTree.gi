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
    return Objectify( BSGSKit_SchreierTreeType
                    , rec( map := orbit
                         , gens := gens
                         , labels := labels
                         , act := act ) );
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

# InstallGlobalFunction( BSGSKit_SchreierTracer,
# function(tree, pt)
#     local gen, elt;
#
#     elt := tree[pt];
#     if pt <> fail then
#         gen := tree!.gens[elt]^-1;
#         pt := tree.act(pt, gen);
#         return [ elt, pt ];
#     else
#         return fail;
#     fi;
# end);
#
# InstallGlobalFunction( BSGSKit_TraceSchreierTreeWord,
# function(tree, pt)
#     local word;
#
#     word := [];
#
#     accum := function(e)
#         Add(word, e);
#     end;
#     BSGSKit_TraceSchreierTree(tree, pt, accum);
#     return word;
# end);
#
# InstallGlobalFunction( BSGSKit_TraceSchreierTreeElement,
# function(tree, pt)
#     local g;
#
#     g := One(tree!.gens);
#
#     accum := function(e)
#         g := g * tree!.gens[e]^-1;
#     end;
#     BSGSKit_TraceSchreierTree(tree, pt, accum);
#     return word;
# end);
#
# FIXME: This should be deduplicated
# Computes the element g of G such that
# pt^g = base
InstallGlobalFunction( BSGSKit_TraceSchreierTreeWord,
function(tree, pt)
    local word, gen, elt;

    elt := tree[pt];
    if elt <> fail then
        word := [];
        while elt <> -1 do
            Add(word, elt);
            gen := tree!.gens[elt]^-1; # might want to just pre-compute inverses...
            pt := tree!.act(pt, gen);
            elt := tree[pt];
        od;
        return word;
    else
        return fail;
    fi;
end);

InstallGlobalFunction( BSGSKit_TraceSchreierTreeElement,
function(tree, pt)
    local elt, g, gen;

    elt := tree[pt];
    if elt <> fail then
        g := ();
        while elt <> -1 do
            gen := tree!.gens[elt]^-1; # might want to just pre-compute inverses...
            g := g * gen;
            pt := tree!.act(pt, gen);
            elt := tree[pt];
        od;
        return g;
    else
        return fail;
    fi;
end);

InstallMethod( \in, "for an object, and an BSGSKit Schreier Tree"
               , [ IsObject, IsBSGSKit_SchreierTree ],
function(elt, tree)
    return elt in tree!.map;
end);

InstallOtherMethod( \[\], "for a BSGSKit Schreier Tree and an object"
                  , [ IsBSGSKit_SchreierTree, IsObject ],
function(tree, elt)
    return tree!.map[elt];
end);

InstallOtherMethod( Iterator, "for a BSGSKit Schreier Tree"
                  , [ IsBSGSKit_SchreierTree ],
function(tree)
    return KeyIterator(tree!.map);
end);

InstallOtherMethod( Size, "for a BSGSKit Schreier Tree"
               , [ IsBSGSKit_SchreierTree ],
function(tree)
    return Size(tree!.map);
end);

#
# Housekeeping
#
InstallMethod( ViewString, "for a BSGSKit Schreier Tree"
               , [ IsBSGSKit_SchreierTreeRep ],
function(tree)
    return STRINGIFY("<schreier tree with ", Size(tree), " elements>");
end);
