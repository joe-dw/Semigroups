#############################################################################
##
#W  standard/main/orbits-pairs.tst
#Y  Copyright (C) 2026                                          Joseph Ward
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

#@local G, S, act, pairs, it, i, pair
gap> START_TEST("Semigroups package: standard/main/orbits-pairs.tst");
gap> LoadPackage("semigroups", false);;

#
gap> SEMIGROUPS.StartTest();
gap> G := SymmetricGroup(4);
Sym( [ 1 .. 4 ] )
gap> S := FullTransformationMonoid(4);
<full transformation monoid of degree 4>
gap> act := {t, p} -> t ^ p;
function( t, p ) ... end
gap> pairs := OrbitsOfPairs(G, S, act);;
gap> Length(pairs);
1455
gap> it := IteratorOfOrbitsOfPairs(G, S, act);
<iterator>
gap> for i in [1 .. 30] do
>   pair := NextIterator(it);
>   if not pair in pairs then
>     break;
>   fi;
> od;
gap> G := AlternatingGroup(5);
gap> S := SymmetricInverseMonoid(5);
gap> OrbitsOfPairsWithCount(G, S, act);;
gap> Sum(List(last, p -> p[2])) = Binomial(Size(S), 2);

gap> S := FullMatrixMonoid(3, 4);
gap> G := GroupOfUnits(S);
gap> OrbitsOfPairs(G, S, act);

gap> SEMIGROUPS.StopTest();
gap> STOP_TEST("Semigroups package: standard/main/orbits-pairs.tst");
