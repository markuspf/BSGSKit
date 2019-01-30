gap> gens := [ (1,2,3)(4,5,6) ];;
gap> t1 := BSGSKit_SchreierTree(gens, 1, \^);;
gap> Size(t1.map);
3
gap> Keys(t1.map) = [1,2,3];
true
gap> t1 := BSGSKit_SchreierTree(gens, 2, \^);;
gap> Keys(t1.map) = [2,3,1];
true

#
gap> LoadPackage("atlasrep");;
gap> gens := AtlasGenerators("Fi24", 1).generators;;
gap> st := BSGSKit_SchreierTree( gens, 1, \^ );;
gap> Size(st.map) = 306936;
true
gap> BSGSKit_TraceSchreierTree(st, 1);
[  ]
gap> oo := Orbit(Group(gens), 1);;
gap> Set(Keys(st.map)) = Set(oo);
true
