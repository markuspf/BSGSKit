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
