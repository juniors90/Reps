#***************************************************************************
#                                   Reps
#       Copyright (C) 2005 Peter Webb 
#       Copyright (C) 2006 Peter Webb, Robert Hank, Bryan Simpkins 
#       Copyright (C) 2007 Peter Webb, Dan Christensen, Brad Froehle
#       Copyright (C) 2020 Peter Webb, Moriah Elkin
#       Copyright (C) 2022 Juan David Ferreira
#
#  Distributed under the terms of the GNU General Public License (GPL)
#                  http://www.gnu.org/licenses/
#
#  The overall structure of the reps package was designed and most of it
#  written by Peter Webb <webb@math.umn.edu>, who is also the maintainer. 
#  Contributions were made by
#  Dan Christensen, Roland Loetscher, Robert Hank, Bryan Simpkins,
#  Brad Froehle and others.
#***************************************************************************
#! @Chapter Interface to the Meataxe
#!
#! In the following routines several of the meataxe commands available in GAP
#! are converted so that they take representations as arguments and return
#! representations, where the meataxe implementation would have returned
#! meataxe modules. Clearly more of the meataxe commands could be implemented
#! than is done below.
#!
#! @Section Commands that return a representation
#!
#! @Arguments args
#!
#! @Returns a meataxe module
#!
#! @Description
#!   Rep(group, list of matrices, (optional field)). . returns a representation in which the generators of the group act by the matrices in the list. This and the following commands are the basic way to input a representation. The function takes two or three arguments. If only two arguments are given the field is taken to be the field of the leading entry of the first matrix, which might be incorrect.
DeclareGlobalFunction( "Rep" );

#! @Arguments group, perms, field
#!
#! @Returns a permutation representation in which the group generators act via the permutations in the list
DeclareGlobalFunction( "PermutationRep" );

#! @Arguments group, perms, field
#!
#! @Returns a permutation representation on the cosets of a subgroup.
DeclareGlobalFunction( "PermutationRepOnCosets" );

#! @Arguments group, field
#!
#! @Returns the representation on the defining permutation representation.
#!
#! @Description
#!   PermGroupToRep(group, field). . returns .
DeclareGlobalFunction( "PermGroupToRep" );

#! @Arguments group, field
#!
#! @Returns the group ring as a representation.
DeclareGlobalFunction( "RegularRep" );

#! @Arguments group, field, n
#!
#! @Returns the direct sum of `n` copies of the group ring as a representation.
#!
DeclareGlobalFunction( "FreeRep" );

#! @Arguments group, field, n
#!
#! @Returns a trivial representation.
DeclareGlobalFunction( "TrivialRep" );

#! @Arguments group, field, n
#!
#! @Returns a trivial action on an n-dimensional vector space.
DeclareGlobalFunction( "TrivialRepN" );

#! @Arguments group, field
#!
#! @Returns the zero representation.
DeclareGlobalFunction( "ZeroGroupRep" );


#! @Arguments rep
#!
#! @Returns a representation which is the dual of rep.
DeclareGlobalFunction( "DualRep" );

#! @Arguments rep1, rep2
#!
#! @Returns a representation which is the direct sum of the two representations.
DeclareGlobalFunction( "DirectSumRep" );
DeclareGlobalFunction( "DirectSumGroupRep" );
 
#! @Arguments rep1, rep2
#!
#! @Returns a representation which is the tensor product of the two representations.
DeclareGlobalFunction( "TensorProductRep" );
DeclareGlobalFunction( "TensorProductGroupRep" );
DeclareGlobalFunction( "OldTensorProductRep" );

#! @Arguments rep, vecs
#!
#! @Returns the representation on the submodule spanned by the list of vectors.
#!
#! @Description
#!   SubmoduleRep(rep, list of vecs). . returns the representation on the 
#! submodule spanned by the list of vectors. The list of vectors must be a 
#! basis for an invariant subspace - this is not checked.
DeclareGlobalFunction( "SubmoduleRep" );
DeclareGlobalFunction( "SubmoduleGroupRep" );


#! @Arguments rep, vecs
#!
#! @Returns the representation on the quotient module by the submodule 
#! spanned by the list of vectors. The list `vecs` of vectors must be 
#! a basis for an invariant subspace - this is not checked.
DeclareGlobalFunction( "QuotientRep" );
DeclareGlobalFunction( "QuotientGroupRep" );
 
#! @Arguments rep, vectorsa, vectorsb
#!
#! @Returns the representation on the quotient of the submodule 
#! spanned by the first list of vectors, by the submodule spanned
#! by the second list of vectors. The two lists should be independent 
#! sets, and should be bases for submodules of rep, the second 
#! submodule contained in the first. This is not checked.
DeclareGlobalFunction( "SectionRep" );


#! @Arguments G, H, rep
#!
#! @Returns the restriction of the representation.
DeclareGlobalFunction( "RestrictedRep" );
DeclareGlobalFunction( "OldRestrictedRep" );

#! @Arguments G, H, phi
#!
#! @Returns the induced representation.
#!
#! @Description Computes the induction of a rep from a subgroup to a group.
#!
#! In more detail, `InducedRep(G, H, M)` is $M \otimes_{kH} kG$.
#! If $m_1, ..., m_n$ is the standard basis for $M$ and $g_1, ..., g_r$
#! are the coset representatives of the set $\{Hg\}$ of right cosets,
#! then the basis chosen for the induced representation is
#!
#!\begin{align}
#!   m_1\otimes g_1, m_2\otimes g_1, ..., m_n\otimes g_1\\,
#!   m_1\otimes g_2, m_2\otimes g_2, ..., m_n\otimes g_2\\,
#!   ...\\
#!   m_1\otimes g_r, m_2\otimes g_r, ..., m_n\otimes g_r,\\
#!\end{align}
#!
#! in that order. 
DeclareGlobalFunction( "InducedRep" );

#! @Arguments rep, n
#!
#! @Returns the representation on the nth symmetric power of the given representation.
#!
#! @Description This code was written by Brad Froehle.
DeclareGlobalFunction( "SymmetricPowerRep" );

#! @Arguments rep
#!
#! @Returns a list of representations which are the composition factors of `rep`. 
#!
#! @Description This function calls the meataxe routine MTX.CompositionFactors which is already implemented in GAP.
DeclareGlobalFunction( "CompositionFactorsRep" );

#! @Arguments rep
#!
#! @Returns a representation isomorphic to a maximal summand of rep that has no projective summand. 
#!
#! @Description It is only guaranteed to work when the group is a p-group in characteristic p. In other cases it may give a correct answer, and if it does not then an error message is returned. The algorithm uses fewer resources than ProjectiveFreeSummand.
DeclareGlobalFunction( "ProjectiveFreeCore" );

#! @Arguments rep
#!
#! @Returns a representation isomorphic to a maximal summand of rep that has no projective summand. 
#!
#! @Description The algorithm decomposes rep and tests summands for projectivity.
#!  This is computationally expensive..
DeclareGlobalFunction( "ProjectiveFreeSummand" );


#! @Arguments rep, gp
#!
#! @Returns the representation of the normalizer of the subgroup
#!   on the fixed points of the subgroup.
DeclareGlobalFunction( "FixedPointRep" );


#! @Arguments rep, p
#!
#! @Returns a representation.
#!
#! @Description the representation of the normalizer of the $p$-subgroup
#!    on the Brauer quotient at that subgroup (quotient of the fixed
#!    points by the images of trace maps from proper subgroups)
DeclareGlobalFunction( "BrauerRep" );

#! @Arguments rep1, rep2
#!
#! @Returns a representation.
#!
#! @Description Returns a representation object with the sum of all
#!   images of `rep2` in `rep1` factored out from `rep1`.
DeclareGlobalFunction( "RemoveFromBottom" );

#! @Arguments rep1, rep2
#!
#! @Returns a representation.
#!
#! @Description Returns a representation object that is the common
#!   kernel of all homomorphisms from `rep1` to `rep2`.
DeclareGlobalFunction( "RemoveFromTop" );