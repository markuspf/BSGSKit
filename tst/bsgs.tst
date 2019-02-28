gap> grp := MathieuGroup(12);;
gap> gens := GeneratorsOfGroup(grp);;
gap> bsgs := BSGSKit_StabChain(gens, \^);;
gap> bsgs := BSGSKit_SchreierUp(bsgs);;
gap> ForAll(grp, g -> IsOne(BSGSKit_Strip(bsgs, g).elt));
true
gap> rcs := RightCosets(SymmetricGroup(12), grp);;
gap> ForAll(rcs{[2..10]}, c -> ForAll(c, g -> not IsOne(BSGSKit_Strip(bsgs,g).elt)));
true
gap> bsgs;
<BSGSKit StabChain with base [ 1, 3, 2, 4, 5 ]>
gap> BSGSKit_GroupSize(bsgs) = Size(grp);
true

# TestGroup
gap> TestGroup := function(gens)
>    local bsgs;
>    bsgs := BSGSKit_StabChain(gens, \^);
>    BSGSKit_SchreierUp(gens);
>    return BSGSKit_GroupSize(bsgs) = Size(Group(gens));
> end;

#
gap> LoadPackage("atlasrep");;
gap> gens := AtlasGenerators("Fi22", 1).generators;;
gap> TestGroup(gens);
true

gap> for i in [1..100] do
>        x := Random([100..4095]);
>        y := Random([1..NrPrimitiveGroups(x)]);
>        if not TestGroup(GeneratorsOfGroup(PrimitiveGroup(x, y))) then
>            Error("Failed to check stabilizer chain");
>        fi;
>    od;

