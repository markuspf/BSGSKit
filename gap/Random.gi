
InstallGlobalFunction( BSGSKit_InitPseudoRandom,
function(gens, r, n)
    local res, i, k;

    res := rec();

    k := Length(gens);
    res.r := r;
    res.gens := ShallowCopy(gens);
    for i in [k+1..r] do res.gens[i] := res.gens[i-k]; od;
    Add(res.gens, One(gens), 1);
    for i in [1..n] do BSGSKit_PseudoRandom(res); od;

    return res;
end);

InstallGlobalFunction( BSGSKit_PseudoRandom,
function(pr)
    local x,y,e,ds;

    ds := [2..pr.r + 1];
    x := Random([2..pr.r + 1]);
    Remove(ds, x - 1);
    y := Random(ds);
    e := Random([-1,1]);

    if Random([true,false]) then
        pr.gens[x] := pr.gens[x] * pr.gens[y]^e;
        pr.gens[1] := pr.gens[1] * pr.gens[x];
    else
        pr.gens[x] := pr.gens[y]^e * pr.gens[x];
        pr.gens[1] := pr.gens[x] * pr.gens[1];
    fi;
    return pr.gens[1];
end);

