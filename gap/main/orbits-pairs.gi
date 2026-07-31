BindGlobal("PARTITION_RIGHT_COSETS", function(S, SS, G)
  local RC, uf, i, C, c;
  RC := RightCosets(S, G);
  uf := PartitionDS(IsPartitionDS, Size(S));
  for C in RC do
    i := Position(SS, Representative(C));
    for c in C do
      Unite(uf, i, Position(SS, c));
    od;
  od;
  return uf;
end);

BindGlobal("PARTITION_LEFT_COSETS", function(S, SS, G)
  local LC, uf, i, C, c;
  LC := LeftCosets(S, G);
  uf := PartitionDS(IsPartitionDS, Size(S));
  for C in LC do
    i := Position(SS, Representative(C));
    for c in C do
      Unite(uf, i, Position(SS, c));
    od;
  od;
  return uf;
end);

BindGlobal("PARTITION_INVERSES", function(G)
  local elts, parts, g, h;
  elts := Elements(G);
  parts := [];
  for g in elts do
    h := g ^ -1;
    if g = h then
      Add(parts, [g]);
    else
      Add(parts, [g, h]);
    fi;
  od;
  return parts;
end);

# RootsOfPartitionDS := function(uf)
#   local pt, gp, data, n, result;
#
#     pt := 0;
#     gp := UF.getParent;
#     data := uf!.data;
#     n := SizeUnderlyingSetDS(uf);
#     result := [];
#     while pt <= n do
#       pt := pt + 1;
#       while pt <= n and gp(data[pt]) <> pt do
#         pt := pt + 1;
#       od;
#       if pt <= n then
#         Add(result, pt);
#       fi;
#     od;
#     return result;
# end;

BindGlobal("UF_JOIN", function(uf1parts, uf2)
    local join, rep, part, x;
    join := ShallowCopy(uf2);
    for part in uf1parts do
      rep := Representative(uf2, part[1]);
      for x in part do
        Unite(join, rep, x);
      od;
    od;
    return join;
end);

BindGlobal("UF_FROM_PARTITION", function(domain, partition)
  local uf, part, k, p;
  uf := PartitionDS(IsPartitionDS, Size(domain));
  for part in partition do
    k := Position(domain, part[1]);
    for p in part do
      Unite(uf, k, Position(domain, p));
    od;
  od;
  return uf;
end);

BindGlobal("FIND_JOIN_IJ", function(SS, R, lParts)
  local J;
  J := UF_JOIN(lParts, R);
  return List(RootsOfPartitionDS(J), k -> SS[k]);
end);

BindGlobal("FIND_JOIN_I", function(SS, L, R, invParts, lParts)
  local J;
  lParts := PartsOfPartitionDS(L);
  J := UF_JOIN(lParts, UF_JOIN(invParts, R));
  return List(RootsOfPartitionDS(J), k -> SS[k]);
end);

BindGlobal("SIZE_STABILISER_PAIR_CONJUGATE", function(A, x, g, act)
  local Ag, I, s;

  Ag := act(A, g);
  I := Intersection(A, Ag);

  for s in DoubleCoset(A, g, Ag) do
    if act(x, g * s) = x then
      return Size(ClosureGroup(I, s));
    fi;
  od;

  return Size(I);
end);

InstallGlobalFunction(OrbitsOfPairs, function(G, S, act)
  local T, tLength, A, GS, J, D, R, L, invPartition, invPartUF, invParts, i,
    lParts, j, pairs, g, x, y;
  T := List(Orbits(G, S, act), l -> l[1]);
  tLength := Length(T);
  A := List(T, t -> Stabiliser(G, t, act));
  GS := AsSet(G);
  J := [];
  D := [];
  R := [];
  L := [];
  invPartition := PARTITION_INVERSES(G);
  invPartUF := UF_FROM_PARTITION(GS, invPartition);
  invParts := PartsOfPartitionDS(invPartUF);
  for i in [1 .. tLength] do
    Add(R, PARTITION_RIGHT_COSETS(G, GS, A[i]));
    Add(L, PARTITION_LEFT_COSETS(G, GS, A[i]));
    # Print(Concatenation(["\rPartitioned Cosets ", String(i), " of ",
    # String(tLength)]));
  od;
  #  Print("\033[2K\rPartitioned All Cosets\n");
  lParts := List(L, PartsOfPartitionDS);

  for i in [1 .. tLength] do
    Add(J, []);
    Add(D, []);
    for j in [1 .. i - 1] do
      Add(J[i], UF_JOIN(lParts[j], R[i]));
      Add(D[i], List(RootsOfPartitionDS(J[i][j]), k -> GS[k]));
    od;
    Add(J[i], UF_JOIN(lParts[i], (UF_JOIN(invParts, R[i]))));
    Add(D[i], List(RootsOfPartitionDS(J[i][i]), k -> GS[k]));
    # Print(Concatenation(["\rFound Join for Element ", String(i), " of ",
    # String(tLength)]));
  od;
  #  Print("\033[2K\rFound All Joins\n");
  pairs := [];

  for i in [tLength, tLength - 1 .. 1] do
    for j in [i - 1, i - 2 .. 1] do
      for g in D[i][j] do
        x := act(T[i], g);
        y := T[j];
        Add(pairs, [x, y]);
      od;
    od;
    for g in D[i][i] do
      y := T[i];
      x := act(y, g);
      if x <> y then
        Add(pairs, [x, y]);
      fi;
    od;
    # Print(Concatenation(["\rFound Pairs for Element ", String(tLength - i +
    #       1),
    # " of ", String(tLength)]));
  od;
  #  Print("\033[2K\rFound All Pairs\n");
  return pairs;
end);

  # InstallGlobalFunction(OrbitsOfPairsWithCount, function(G, S, act)
  #   local T, tLength, A, GS, J, D, R, L, invPartition, invPartUF, invParts, i,
  #     lParts, j, pairs, g, x, y;
  #   T := List(Orbits(G, S, act), l -> l[1]);
  #   tLength := Length(T);
  #   A := List(T, t -> Stabiliser(G, t, act));
  #   GS := AsSet(G);
  #   J := [];
  #   D := [];
  #   R := [];
  #   L := [];
  #   invPartition := PARTITION_INVERSES(G);
  #   invPartUF := UF_FROM_PARTITION(GS, invPartition);
  #   invParts := PartsOfPartitionDS(invPartUF);
  #   for i in [1 .. tLength] do
  #     Add(R, PARTITION_RIGHT_COSETS(G, GS, A[i]));
  #     Add(L, PARTITION_LEFT_COSETS(G, GS, A[i]));
  #     Print(Concatenation(["\rPartitioned Cosets ", String(i), " of ",
  #       String(tLength)]));
  #   od;
  #   Print("\033[2K\rPartitioned All Cosets\n");
  #   lParts := List(L, PartsOfPartitionDS);
  #
  #   for i in [1 .. tLength] do
  #     Add(J, []);
  #     Add(D, []);
  #     for j in [1 .. i - 1] do
  #       Add(J[i], UF_JOIN(lParts[j], R[i]));
  #       Add(D[i], List(RootsOfPartitionDS(J[i][j]), k -> GS[k]));
  #     od;
  #     Add(J[i], UF_JOIN(lParts[i], (UF_JOIN(invParts, R[i]))));
  #     Add(D[i], List(RootsOfPartitionDS(J[i][i]), k -> GS[k]));
  #     Print(Concatenation(["\rFound Join for Element ", String(i), " of ",
  #       String(tLength)]));
  #   od;
  #   Print("\033[2K\rFound All Joins\n");
  #   pairs := [];
  #
  #   for i in [tLength, tLength - 1 .. 1] do
  #     for j in [i - 1, i - 2 .. 1] do
  #       for g in D[i][j] do
  #         x := act(T[i], g);
  #         y := T[j];
  #         Add(pairs, [[x, y], Size(G) / Size(Intersection(act(A[i], g),
                A[j]))]);
  #       od;
  #     od;
  #     for g in D[i][i] do
  #       y := T[i];
  #       x := act(y, g);
  #       if x <> y then
  #         Add(pairs, [[x, y], Size(G) / SIZE_STABILISER_PAIR_CONJUGATE(A[i],
               x, g, act)]);
  #       fi;
  #     od;
  #     Print(Concatenation(["\rFound Pairs for Element ", String(tLength - i
          + 1),
  #       " of ", String(tLength)]));
  #   od;
  #   Print("\033[2K\rFound All Pairs\n");
  #   return pairs;
  # end);

InstallGlobalFunction(IteratorOfOrbitsOfPairs,
function(G, S, act)
  local GS, T, invPartition, invPartUF, invParts, tLength, IsDone, Next, SCopy;

  GS := Elements(G);
  T := List(Orbits(G, S, act), l -> l[1]);
  tLength := Length(T);
  invPartition := PARTITION_INVERSES(G);
  invPartUF := UF_FROM_PARTITION(GS, invPartition);
  invParts := PartsOfPartitionDS(invPartUF);

  IsDone := function(self)
    return (Size(G) = 1)
        or ((self!.i = self!.tLength) and (self!.j = 1)
            and (self!.pos = Length(self!.currentList)))
        or self!.i > self!.tLength;
  end;

  Next := function(self)
    local g, lP, l;
    while true do
      while self!.pos < Length(self!.currentList) do
        self!.pos := self!.pos + 1;
        g := self!.currentList[self!.pos];
        if self!.i = self!.j then
          if self!.ti <> act(self!.ti, g) then
            return [act(self!.ti, g), self!.ti];
          fi;
        else
          return [act(self!.ti, g), self!.tj];
        fi;
      od;
      self!.currentList := [];
      self!.pos := 0;
      if self!.j <= 1 then
        self!.i := self!.i + 1;
        self!.ti := self!.T[self!.i];
        self!.r := PARTITION_RIGHT_COSETS(self!.G, self!.GS,
                 Stabiliser(G, self!.ti, act));
        self!.j := self!.i;
        self!.tj := self!.T[self!.j];
        l := PARTITION_LEFT_COSETS(self!.G, self!.GS,
                 Stabiliser(G, self!.tj, act));
        lP := PartsOfPartitionDS(l);
        self!.currentList := FIND_JOIN_I(self!.GS, l, self!.r, self!.invParts,
                            lP);
      else
        self!.j := self!.j - 1;
        self!.tj := self!.T[self!.j];
        l := PARTITION_LEFT_COSETS(self!.G, self!.GS,
                 Stabiliser(G, self!.tj, act));
        lP := PartsOfPartitionDS(l);
        self!.currentList := FIND_JOIN_IJ(self!.GS, self!.r, lP);
      fi;
    od;
  end;

  SCopy := function(self)
    return rec(
      IsDoneIterator := self!.IsDoneIterator,
      NextIterator   := self!.NextIterator,
      ShallowCopy    := self!.ShallowCopy,
      S           := self!.S,
      G           := self!.G,
      act         := self!.act,
      GS          := self!.GS,
      T           := self!.T,
      tLength     := self!.tLength,
      invPartUF   := self!.invPartUF,
      invParts    := self!.invParts,
      i           := self!.i,
      ti          := self!.ti,
      j           := self!.j,
      tj          := self!.tj,
      r           := self!.r,
      currentList := ShallowCopy(self!.currentList),
      pos         := self!.pos);
  end;

  return IteratorByFunctions(rec(
    IsDoneIterator := IsDone,
    NextIterator   := Next,
    ShallowCopy    := SCopy,
    G           := G,
    S           := S,
    act         := act,
    GS          := GS,
    T           := T,
    tLength     := tLength,
    invPartUF   := invPartUF,
    invParts    := invParts,
    i           := 0,
    ti          := T[1],
    j           := 0,
    tj          := T[1],
    r           := fail,
    currentList := [],
    pos         := 0));
end);

  # InstallGlobalFunction(IteratorOfOrbitsOfPairsWithCount,
  # function(G,S,act)
  #   local GS, T, A, invPartition, invPartUF, invParts, tLength, IsDone, Next,
          SCopy;
  #
  #   GS := Elements(G);
  #   T := List(Orbits(G, S, act),l -> l[1]);
  #   tLength := Length(T);
  #   A := List(T, t -> Stabiliser(G, t, act));
  #   invPartition := PARTITION_INVERSES(G);
  #   invPartUF := UF_FROM_PARTITION(GS, invPartition);
  #   invParts := PartsOfPartitionDS(invPartUF);
  #
  #   IsDone := function(self)
  #     return (Size(G) = 1)
  #         or ((self!.i = self!.tLength) and (self!.j = 1)
  #             and (self!.pos = Length(self!.currentList)))
  #         or self!.i > self!.tLength;
  #   end;
  #
  #   Next := function(self)
  #     local g, lP, l;
  #     while true do
  #       while self!.pos < Length(self!.currentList) do
  #         self!.pos := self!.pos + 1;
  #         g := self!.currentList[self!.pos];
  #         if self!.i = self!.j then
  #           if self!.ti <> act(self!.ti, g) then
  #             return [[act(self!.ti, g), self!.ti], Size(Intersection(
  #                      List(A[self!.i], a -> act(a, g)), A[self!.i]))];
  #           fi;
  #         else
  #           return [[act(self!.ti, g), self!.tj], Size(Intersection(List(
  #                    A[self!.i], a -> act(a, g)), A[self!.j]))];
  #         fi;
  #       od;
  #       self!.currentList := [];
  #       self!.pos := 0;
  #       if self!.j <= 1 then
  #         self!.i := self!.i + 1;
  #         self!.ti := self!.T[self!.i];
  #         self!.r := PARTITION_RIGHT_COSETS(self!.G, self!.GS,
  #                  Stabiliser(G, self!.ti, act));
  #         self!.j := self!.i;
  #         self!.tj := self!.T[self!.j];
  #         l := PARTITION_LEFT_COSETS(self!.G, self!.GS,
  #                  Stabiliser(G, self!.tj, act));
  #         lP := PartsOfPartitionDS(l);
  #         self!.currentList := FIND_JOIN_I(self!.GS, l, self!.r,
  #                            self!.invParts, lP);
  #       else
  #         self!.j := self!.j - 1;
  #         self!.tj := self!.T[self!.j];
  #         l := PARTITION_LEFT_COSETS(self!.G, self!.GS,
  #                  Stabiliser(G, self!.tj, act));
  #         lP := PartsOfPartitionDS(l);
  #         self!.currentList := FIND_JOIN_IJ(self!.GS, self!.r, lP);
  #       fi;
  #     od;
  #   end;
  #
  #   SCopy := function(self)
  #     return rec(
  #       IsDoneIterator := self!.IsDoneIterator,
  #       NextIterator   := self!.NextIterator,
  #       ShallowCopy    := self!.ShallowCopy,
  #       S           := self!.S,
  #       G           := self!.G,
  #       A           := self!.A,
  #       act         := self!.act,
  #       GS          := self!.GS,
  #       T           := self!.T,
  #       tLength     := self!.tLength,
  #       invPartUF   := self!.invPartUF,
  #       invParts    := self!.invParts,
  #       i           := self!.i,
  #       ti          := self!.ti,
  #       j           := self!.j,
  #       tj          := self!.tj,
  #       r           := self!.r,
  #       currentList := ShallowCopy(self!.currentList),
  #       pos         := self!.pos
  #     );
  #   end;
  #
  #   return IteratorByFunctions(rec(
  #     IsDoneIterator := IsDone,
  #     NextIterator   := Next,
  #     ShallowCopy    := SCopy,
  #     G           := G,
  #     S           := S,
  #     A           := A,
  #     act         := act,
  #     GS          := GS,
  #     T           := T,
  #     tLength     := tLength,
  #     invPartUF   := invPartUF,
  #     invParts    := invParts,
  #     i           := 0,
  #     ti          := T[1],
  #     j           := 0,
  #     tj          := T[1],
  #     r           := fail,
  #     currentList := [],
  #     pos         := 0
  #   ));
  # end);
  #
