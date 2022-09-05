
#! MakeIsoToPermGroup(rep) creates fields rep.permgroup and rep.isotopermgroup
#! which are used by routines which are written to work only with permutation
#! groups, typically involving an algorithm which goes down a stabilizer
#! chain.

#! MakeIsoToPermGroup is utils for:
# - Commands for Trace, norm and principal idempotent.
# - Commands that return lists of vectors:

DeclareGlobalFunction( "MakeIsoToPermGroup" );

#! SafeNullspaceMat(mat, F) returns a basis for the nullspace of mat, defined 
#! over F. This works also when the domain or codomain are the zero vector space.

#! SafeNullspaceMat is utils for:
# - Catreps PKG.
# - Commands that return lists of vectors.

DeclareGlobalFunction( "SafeNullspaceMat" );

#! SafeBaseMat(M) returns a list a basis vectors for the space spanned
#! by the rows of M.  If M is an empty list, so M has no rows, or if
#! the elements of M are empty lists, so M has no columns, then the
#! empty list is returned.

#! SafeNullspaceMat is utils for:
# - Catreps PKG.
# - Test.
# - Commands that return lists of vectors.
# - Commands that return representations.
# - Commands that return homomorphisms.

DeclareGlobalFunction( "SafeBaseMat" );


#! SafeIdentityMat(n, F) returns an nxn identity matrix over the field F.
#! When n = 0, returns an empty list.

#! SafeIdentityMat is utils for:
# - Catreps PKG.
# - Commands that return lists of vectors.

DeclareGlobalFunction( "SafeIdentityMat" );



#! SafeMatrixMult(A, B, n) returns the product of matrices A and B,
#! where A is kxm and B is mxn.  n is passed in because if B has no
#! rows, then we can not determine n.
#!
#! If k=0, returns an empty list, i.e. the matrix with 0 rows and n columns.
#! If n=0, returns the matrix with k rows and 0 columns.
#! If m=0, then returns the kxn zero matrix.


# SafeMatrixMult is utils for:
# - Commands that return lists of vectors.
# - Commands that return representations.

DeclareGlobalFunction( "SafeMatrixMult" );

#! SocleNullspaceMat(matrix, dimension, field)
#! returns a list of vectors forming a basis for the nullspace of the matrix,
#! and deals with the situation where the matrix may have no rows, etc.
#! It is used in SocleSeries(rep); SafeNullspaceMat works in other instances.
#! Written by Peter Webb July 2016.

# SocleNullspaceMat is utils for:
# - Commands that return lists of vectors.

DeclareGlobalFunction( "SocleNullspaceMat" );

#! InverseGenImages(rep) returns the list of matrices which are the inverses
#! of the matrices in rep.genimages. Two algorithms were tried: in
#! OldInverseGenImages, rather than invert the matrices, they
#! are raised to a power Order(g)-1 for each generator g. In fact, it appears
#! on testing this out that GAP is faster at doing x -> x^-1.

# InverseGenImages is utils for:
# - Commands that return representations.

DeclareGlobalFunction( "InverseGenImages" );
DeclareGlobalFunction( "OldInverseGenImages" );


#! TensorProductMatrix(M1,M2) . . . Tensor product of two matrices
#!
#! The GAP command KroneckerProduct seems inexplicably slow and in tests on
#! two 60 x 60 matrices takes about twice as long as the following code.

# TensorProductMatrix is utils for:
# - Catreps PKG.
# - Commands that return representations.
# - Commands that return homomorphisms.

DeclareGlobalFunction( "TensorProductMatrix" );

#!PermutationMatrix(perm,d,field)  We specify d so that the permutation is
#! regarded as permuting [1..d]


# PermutationMatrix is utils for:
# - Commands that return representations.

DeclareGlobalFunction( "PermutationMatrix" );

#! PermToMatrixGroup( permgrp, field ) . . transforms a permutation group 
#! to a group of permutation matrices

#! PermToMatrixGroup := function( permgrp, field )
#! 
#!         local   matrix, g, p, d, mgens;
#! 
#!         d := LargestMovedPoint(permgrp);
#!         mgens:=[];
#!         for g in GeneratorsOfGroup(permgrp) do
#!                 matrix:=NullMat(d,d,field);
#!                 for p in [1..d] do
#!                         matrix[p][p^g]:=One(field);
#!                 od;
#!                 Add(mgens,matrix);
#!         od;
#!         return(Group(mgens));
#! end;

#! CanRightRep(group,subgroup,list of elements, element)
#! returns the first element in the list which represents the same
#! coset as the element.
#! It does not verify the validity of its input.

# CanRightRep is utils for:
# - Commands that return representations.

DeclareGlobalFunction( "CanRightRep" );

#! RightCosetReps(group,subgroup) gives a list of representatives  of the 
#! right cosets of a group relative to a given subgroup.


# RightCosetReps is utils for:
# - Trace Norm and principal idempotent
# - Commands that return representations.
# - Commands that return homomorphisms.

DeclareGlobalFunction( "RightCosetReps" );

# GLG is utils for:
# - Commands that return homomorphisms.

DeclareGlobalFunction( "GLG" );

#! InducedMorphism(group, subgroup, matrix) computes the induced
#! homomorphism of a map between representations of the subgroup.
#!
#! Code written by Dan Christensen, University of Western Ontario,August 2007

# InducedMorphism is utils for:
# - None

DeclareGlobalFunction( "InducedMorphism" );
#! DecomposeOnce(rep) . . probably returns a list of two bases for summands
#! of the representation rep if it is decomposable, and returns a list whose
#! only element is the standard basis if it is indecomposable. 
#!
#! This code was written by Bryan Simpkins and Robert Hank, University of
#! Minnesota, April 2006

# DecomposeOnce is utils for:
# - None

DeclareGlobalFunction( "DecomposeOnce" );

#! MatsOfCosetReps(rep) . . returns a list
#!
#! [rep of a proper subgroup, 
#! list of matrices of right coset representatives of the subgroup,
#! list of right coset representatives of the subgroup].
#!
#! The coset representatives are a Schreier
#! transversal for the stabilizer of a point, and the stabilizer subgroup has Schreier
#! generators for the stabilizer. At the same time matrices which
#! represent the elements which arise are stored.
#!
#! This function is called by NormRep, MatrixOfElement and RestrictedRep.

# SafeNullspaceMat is utils for:
# - Commands that return lists of vectors.
# - Commands that return representations.

DeclareGlobalFunction( "MatsOfCosetReps" );

#! IsProjectiveMorphism(rep1, rep2, f) returns whether or not
#! the morphism f: rep1 --> rep2 factors through a projective.
#! f is assumed to be a kG-module homomorphism.

# IsProjectiveMorphism is utils for:
# - None

DeclareGlobalFunction( "IsProjectiveMorphism" );

#! RepToMatGroup(rep) returns the matrix group which is the image of the
#! representation.

# RepToMatGroup is utils for:
# - None

DeclareGlobalFunction( "RepToMatGroup" );