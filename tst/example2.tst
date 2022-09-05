gap> # We examine the projective modules for the
gap> # alternating group A_5 over GF(2). This
gap> # illustrates some things which can happen
gap> # with Decompose which can be puzzling, and
gap> # which arise because GF(2) is not a splitting
gap> # field for A_5.
gap> a5 := AlternatingGroup( 5 );
Alt( [ 1 .. 5 ] )
gap> reg := RegularRep( a5, GF( 2 ) );;
gap> # Having constructed the regular representation,
gap> # we now construct the augmentation ideal.
gap> aug := SubmoduleRep( reg, FixedQuotient( reg ) );;
gap> Decompose( aug );;
gap> # Note that Decompose stores its output as
gap> # aug.summands. The output is a list of bases
gap> #of summands of aug which are probably indecomposable.
gap> List( aug.summands, Length );
[ 16, 4, 4, 4, 11, 4, 16 ]
gap> # The augmentation ideal breaks up as the direct
gap> # sum of the indecomposable projectives other than
gap> # the projective cover P_1 of the trivial module,
gap> # direct sum the radical of P_1. From a knowledge
gap> # of the representation theory of A_5 the result
gap> #may be a surprise because over a splitting field
gap> #in characteristic 2 A_5 has the trivial representation,
gap> # two irreducibles of dimension 2 and a block of defect
gap> # zero of dimension 4. Over a splitting field this gives
gap> # 9 summands of the regular representation (each projective
gap> # occurs with multiplicity equal to the degree of the
gap> # corresponding irreducible representation).
gap> # In fact over GF(2) there is a 4-dimensional simple
gap> # module which over GF(4) is the direct sum of the 
gap> # two 2-dimensional simple modules. The computational
gap> # output shows that reg has 7 summands, of the
gap> # dimensions indicated.
gap> four:=SubmoduleRep( aug, aug.summands[1] );;
gap> PrintRep( four );
Representation( AlternatingGroup( [ 1 .. 5 ] ), Images 
[ [  1,  0,  0,  0,  0,  1,  1,  1,  0,  0,  1,  1,  0,  0,  0,  0 ],
  [  0,  1,  1,  1,  1,  0,  0,  0,  0,  1,  0,  1,  0,  0,  0,  0 ],
  [  1,  1,  1,  0,  0,  0,  1,  1,  0,  1,  1,  0,  0,  0,  0,  0 ],
  [  1,  1,  0,  0,  0,  1,  0,  0,  1,  1,  1,  1,  0,  0,  0,  0 ],
  [  0,  1,  1,  1,  1,  0,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0 ],
  [  0,  1,  1,  0,  1,  0,  0,  1,  0,  1,  1,  0,  0,  0,  0,  0 ],
  [  1,  1,  0,  1,  0,  1,  1,  0,  1,  1,  1,  0,  0,  0,  0,  0 ],
  [  0,  1,  0,  1,  0,  1,  1,  1,  0,  1,  0,  0,  0,  0,  0,  0 ],
  [  1,  1,  0,  0,  0,  0,  0,  1,  1,  1,  0,  0,  0,  0,  0,  0 ],
  [  0,  1,  1,  0,  1,  0,  1,  0,  0,  1,  0,  1,  0,  0,  0,  0 ],
  [  0,  1,  0,  1,  0,  0,  0,  1,  0,  1,  1,  1,  0,  0,  0,  0 ],
  [  0,  0,  0,  1,  0,  1,  1,  0,  0,  1,  1,  0,  0,  0,  0,  0 ],
  [  0,  1,  1,  0,  1,  1,  0,  1,  0,  0,  1,  0,  1,  0,  0,  0 ],
  [  1,  1,  0,  1,  1,  0,  1,  0,  1,  1,  1,  1,  0,  1,  0,  0 ],
  [  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0 ],
  [  0,  0,  0,  0,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  1 ] ]
[ [  1,  1,  1,  0,  0,  1,  1,  1,  1,  1,  0,  1,  0,  1,  0,  0 ],
  [  0,  0,  0,  0,  0,  1,  1,  0,  1,  1,  0,  0,  1,  0,  0,  0 ],
  [  0,  0,  0,  0,  1,  0,  1,  1,  1,  0,  0,  1,  0,  1,  0,  0 ],
  [  0,  0,  1,  1,  1,  1,  0,  0,  1,  1,  0,  1,  0,  0,  1,  0 ],
  [  1,  0,  1,  1,  1,  0,  0,  0,  0,  0,  1,  1,  0,  0,  0,  0 ],
  [  1,  0,  1,  1,  0,  1,  0,  1,  0,  0,  1,  1,  1,  0,  1,  1 ],
  [  0,  0,  1,  1,  1,  0,  0,  1,  1,  0,  0,  1,  1,  1,  0,  0 ],
  [  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  0,  1,  0,  0,  1,  0 ],
  [  1,  1,  1,  1,  1,  1,  0,  0,  1,  0,  1,  0,  0,  1,  0,  1 ],
  [  1,  1,  0,  0,  1,  1,  0,  1,  1,  1,  0,  1,  1,  1,  0,  0 ],
  [  0,  0,  0,  1,  0,  1,  0,  1,  1,  0,  1,  0,  0,  0,  0,  0 ],
  [  0,  0,  0,  0,  0,  1,  1,  0,  1,  1,  1,  1,  0,  1,  0,  1 ],
  [  0,  1,  1,  1,  1,  0,  0,  0,  1,  1,  0,  0,  1,  1,  0,  1 ],
  [  1,  0,  0,  0,  1,  0,  0,  0,  1,  1,  0,  1,  1,  1,  0,  0 ],
  [  1,  1,  0,  1,  0,  1,  0,  0,  0,  1,  1,  1,  0,  1,  1,  0 ],
  [  1,  1,  0,  0,  0,  1,  0,  1,  0,  1,  1,  1,  0,  1,  1,  0 ] ]
 )
gap> IsProjectiveRep( four );
true
gap> # We see from this that four is the block of
gap> # defect zero. We now construct the other
gap> # 4-dimensional irreducible module.
gap> sixteen:=SubmoduleRep( aug, aug.summands[4] );;
gap> socle:=SubmoduleRep( sixteen, SocleRep( sixteen ) );;
gap> IsIrreducibleRep( socle );
true
gap> DimHom( four, socle );
0
gap> # Thus four and socle are not isomorphic.
gap> # The following shows that splitting fields
gap> # for four and socle have degrees 1 and 2
gap> # over GF(2).
gap> IsAbsolutelyIrreducibleRep( four );
false
gap> IsAbsolutelyIrreducibleRep( socle );
true
gap> DimHom( socle, socle );
1
gap> # Next we examine P_1. Over a splitting field
gap> # its radical modulo its socle is the direct
gap> # sum of two uniserial modules. Over GF(2)
gap> # this module has simple socle and radical
gap> # quotient isomorphic to the representation
gap> # called socle, as the following implies.
gap> eleven := SubmoduleRep( aug, aug.summands[6] );;
gap> ten := QuotientRep( eleven, FixedPoints@Reps( eleven ) );;
gap> ten.dimension;
4
gap> FixedPoints@Reps( ten );
[  ]
gap> Length( FixedQuotient( ten ) );
4
gap> quit;
