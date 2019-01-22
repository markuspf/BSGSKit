#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# Implementations
#


#
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
                orbit[pp] := k;
                PushBack(new, pp);
            fi;
        od;
    until IsEmpty(new);
    return orbit;
end);
