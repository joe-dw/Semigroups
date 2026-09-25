InstallMethod(MaximalIdempotents,
"for a semilattice of idempotents",
[IsSemilattice],
function(S)
  local pos;
  pos := Positions(OutDegrees(HasseDigraph(S)), 0);
  return List(pos, i -> Elements(S)[i]);
end);

InstallMethod(IsUnambiguousSemilattice,
"for a semilattice of idempotents",
[IsSemilattice],
S -> 2 > Number(OutDegrees(HasseDigraph(S)), o -> o > 1));

InstallMethod(HasseDigraph,
"for a semilattice of idempotents",
[IsSemilattice],
S -> DigraphReverse(DigraphTransitiveReduction(
  Digraph(NaturalPartialOrder(S)))));
