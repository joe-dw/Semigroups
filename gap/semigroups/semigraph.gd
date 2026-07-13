#############################################################################
##
##  semigroups/semigraph.gd
##  Copyright (C) 2014-2022               Zak Mesyan and James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

DeclareOperation("GraphInverseSemigroup", [IsDigraph]);

<<<<<<< HEAD
DeclareCategory("IsGraphInverseSemigroupElement",
=======
DeclareCategory("IsGraphInverseSemigroupElement", 
>>>>>>> 8a43ee22 (Set IsPositionalObjectRep on graph inverse semigroup elements, added attribute EdgesOfGraphInverseSemigroup and added IsWholeFamily test to graph inverse subsemigroups)
                 IsAssociativeElement and IsPositionalObjectRep);
DeclareCategoryCollections("IsGraphInverseSemigroupElement");

DeclareSynonymAttr("IsGraphInverseSubsemigroup",
                   IsSemigroup and
                   IsGraphInverseSemigroupElementCollection);

DeclareSynonymAttr("IsGraphInverseSemigroup",
                   IsGraphInverseSubsemigroup and IsWholeFamily);

DeclareAttribute("GraphOfGraphInverseSemigroup", IsGraphInverseSemigroup);
DeclareAttribute("Range", IsGraphInverseSemigroupElement);
DeclareAttribute("Source", IsGraphInverseSemigroupElement);

DeclareOperation("IsVertex", [IsGraphInverseSemigroupElement]);

InstallTrueMethod(IsGeneratorsOfInverseSemigroup,
                  IsGraphInverseSemigroupElementCollection);

# The following are required because we use Zero in an unintended way (it's
# supposed to be an additive zero).
DeclareOperation("ZeroOp", [IsGraphInverseSemigroupElement]);
DeclareProperty("IsZero", IsGraphInverseSemigroupElement);

DeclareOperation("IndexOfVertexOfGraphInverseSemigroup",
                 [IsGraphInverseSemigroupElement]);
DeclareAttribute("VerticesOfGraphInverseSemigroup",
                 IsGraphInverseSemigroup);
DeclareAttribute("EdgesOfGraphInverseSemigroup",
                 IsGraphInverseSemigroup);
