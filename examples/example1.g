# LogTo("test.log");Read("C:/gap-4.11.1/pkg/Reps-1.0.0/tst/testall.g");
gap> # We load Reps either by having it available as a 
gap> # package or by creating a file in the home directory 
gap> # called reps containing the routines.
gap> LoadPackage( "Reps", "0", false  );
true
gap> # This assumes that the GAP code for the routines to
gap> # be used is stored in the file reps.
gap> g := SymmetricGroup( 4 );
Sym( [ 1 .. 4 ] )
gap> GeneratorsOfGroup( g );
[ (1,2,3,4), (1,2) ]
gap> # Before constructing the 6-dimensional representation
gap> # we will investigate, we construct the irreducible 
gap> # 2-dimensional representation over GF( 2 ). This can 
gap> # be done in various ways.
gap> # One way which works with small groups is to 
gap> # construct the regular representation and find 
gap> # its composition factors.
gap> reg := RegularRep( g, GF( 2 ) );;
gap> comp := CompositionFactorsRep( reg );;
gap> List( comp, x -> x.dimension );
[ 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 2, 1, 1, 2 ]
gap> two := comp[3];
rec( dimension := 2, field := GF(2), 
  genimages := [ <an immutable 2x2 matrix over GF2>, <an immutable 2x2 matrix over GF2> ], group := Sym( [ 1 .. 4 ] ),
  isRepresentation := true, 
  operations := rec( CoSpin := function( rep, veclist ) ... end, Decompose := function( rep ) ... end, 
      DecomposeSubmodule := function( repn, basis ) ... end, DirectSumRep := function( rep1, rep2 ) ... end, 
      HomBasis := function( M, N ) ... end, QuotientRep := function( rep, v ) ... end, 
      Spin := function( rep, veclist ) ... end, SubmoduleRep := function( rep, vecs ) ... end, 
      SumOfImages := function( g, h ) ... end, TensorProductRep := function( g, h ) ... end ) )
gap> # We may print a representation more nicely 
gap> # using PrintRep.
gap> PrintRep( two );
Representation( SymmetricGroup( [ 1 .. 4 ] ), Images 
[ [  0,  1 ],
  [  1,  0 ] ]
[ [  1,  1 ],
  [  0,  1 ] ]
 )
gap> # For larger groups it would be heavy-handed to take
gap> # composition factors of the regular representation.
gap> # Just to illustrate, we now construct the 
gap> # 2-dimensional simple module from the natural 
gap> # permutation representation of S_4. This representation 
gap> # is uniserial with composition factors 1, 2, 1.
gap> four := PermutationRep( g, GeneratorsOfGroup( g ), GF( 2 ) );;
gap> PrintRep( four );
Representation( SymmetricGroup( [ 1 .. 4 ] ), Images 
[ [  0,  1,  0,  0 ],
  [  0,  0,  1,  0 ],
  [  0,  0,  0,  1 ],
  [  1,  0,  0,  0 ] ]
[ [  0,  1,  0,  0 ],
  [  1,  0,  0,  0 ],
  [  0,  0,  1,  0 ],
  [  0,  0,  0,  1 ] ]
 )
gap> FixedQuotient( four );
[ <an immutable GF2 vector of length 4>, <an immutable GF2 vector of length 4>, <an immutable GF2 vector of length 4> 
 ]
gap> # These three vectors span a submodule which has as its
gap> # quotient the largest image with trivial action. The
gap> # submodule is uniserial with composition factors 1,2.
gap> three:=SubmoduleRep( four, last );;
gap> PrintRep( three );
Representation( SymmetricGroup( [ 1 .. 4 ] ), Images 
[ [  0,  1,  0 ],
  [  0,  0,  1 ],
  [  1,  1,  1 ] ]
[ [  1,  0,  0 ],
  [  1,  1,  0 ],
  [  0,  0,  1 ] ]
 )
gap> FixedPoints@Reps( three );
[ <an immutable GF2 vector of length 3> ]
gap> two:=QuotientRep( three, last );;
gap> PrintRep( two );
Representation( SymmetricGroup( [ 1 .. 4 ] ), Images 
[ [  0,  1 ],
  [  1,  0 ] ]
[ [  1,  1 ],
  [  0,  1 ] ]
 )
gap> # Here two is the 2-dimensional simple module 
gap> # for S_4.
gap> # We could show that it is this module by computing
gap> # that it has zero fixed points or doing:
gap> IsIrreducibleRep( two );
true
gap> # We now construct a 6-dimensional permutation
gap> # representation.
gap> Orbit( g, [1,2], OnSets );
[ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], [ 1, 3 ], [ 1, 4 ], [ 2, 4 ] ]
gap> Action( g, last, OnSets );
Group([ (1,2,3,5)(4,6), (2,4)(5,6) ])
gap> gens := GeneratorsOfGroup( last );;
gap> six := PermutationRep( g, gens, GF( 2 ) );;
gap> PrintRep( six );
Representation( SymmetricGroup( [ 1 .. 4 ] ), Images 
[ [  0,  1,  0,  0,  0,  0 ],
  [  0,  0,  1,  0,  0,  0 ],
  [  0,  0,  0,  0,  1,  0 ],
  [  0,  0,  0,  0,  0,  1 ],
  [  1,  0,  0,  0,  0,  0 ],
  [  0,  0,  0,  1,  0,  0 ] ]
[ [  1,  0,  0,  0,  0,  0 ],
  [  0,  0,  0,  1,  0,  0 ],
  [  0,  0,  1,  0,  0,  0 ],
  [  0,  1,  0,  0,  0,  0 ],
  [  0,  0,  0,  0,  0,  1 ],
  [  0,  0,  0,  0,  1,  0 ] ]
 )
gap> # We will now analyze the structure of the 
gap> # represenntation six.
gap> FixedPoints@Reps( six );
[ <an immutable GF2 vector of length 6> ]
gap> DimHom( two, six );
1
gap> # We conclude that the socle of six is the 
gap> # direct sum of 1 and 2. This could also have 
gap> # been done using the meataxe socle command
gap> # and decomposing it:
gap> socle:=SubmoduleRep( six, SocleRep( six ) );;
gap> Decompose( socle );
[ [ <a GF2 vector of length 3> ], [ <a GF2 vector of length 3>, <a GF2 vector of length 3> ] ]
gap> IsIrreducibleRep( SubmoduleRep( socle, last[2] ) );
true
gap> # In a similar way we analyze the radical quotient of six.
gap> DimHom( six, two );
1
gap> FixedQuotient( six );
[ <an immutable GF2 vector of length 6>, <an immutable GF2 vector of length 6>, <an immutable GF2 vector of length 6>,
  <an immutable GF2 vector of length 6>, <an immutable GF2 vector of length 6> ]
gap> # We conclude that the radical quotient of six 
gap> # is also the direct sum of 1 and 2. We now construct 
gap> # a 4-dimension section of 6 called sub.
gap> FixedPoints@Reps( six );
[ <an immutable GF2 vector of length 6> ]
gap> quot:=QuotientRep( six, last );;
gap> FixedPoints@Reps( quot );
[  ]
gap> FixedQuotient( quot );
[ [ Z(2)^0, Z(2)^0, 0*Z(2), 0*Z(2), 0*Z(2) ], [ 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2) ], 
  [ 0*Z(2), 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0 ], [ 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0, Z(2)^0 ] ]
gap> sub:=SubmoduleRep( quot, last );;
gap> DimHom( two, sub );
1
gap> DimHom( sub, two );
1
gap> FixedQuotient( sub );
[ [ Z(2)^0, Z(2)^0, 0*Z(2), 0*Z(2) ], [ 0*Z(2), 0*Z(2), Z(2)^0, 0*Z(2) ], [ 0*Z(2), Z(2)^0, 0*Z(2), 0*Z(2) ], 
  [ 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0 ] ]
gap> FixedPoints@Reps( sub );
[  ]
gap> # From this we conclude that sub is a uniserial
gap> # module with composition factors 2,2. This means
gap> #! (in this situation) that the extension of 2 by 2 
gap> #! is non-split. We next factor out a submodule 2 from six.
gap> SumOfImages( two, six );
[ [ Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0 ], [ 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0 ] ]
gap> quot:=QuotientRep( six, last );;
gap> FixedPoints@Reps( quot );
[ <an immutable GF2 vector of length 4>, <an immutable GF2 vector of length 4> ]
gap> # The fact that the fixed points have dimension 2 shows 
gap> # that the extension of 1 by 1 is split. From all this 
gap> # we may deduce also that six is indecomposable: if it 
gap> # were a direct sum, enumeration of the possible structures 
gap> # of direct summands leads to contradiction in every case.
gap> quit;
