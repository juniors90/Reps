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
#!
#! @Chapter Commands for homomorphisms
#!
#! @Section Methods
#!
#! @Arguments rep
#!
#! @Returns a group homomorphism by images.
#!
#! @Description
#!   Converts a representation to a group homomorphism by images.
DeclareGlobalFunction( "RepToGHBI" );

#! @Arguments rep1, rep2
#!
#! @Returns a basis for the space of module homomorphisms $A \to B$.
#!
#! @Description
#!   `HomBasis` returns a basis for the space of module homomorphisms
#!  $A \to B$. The elements of this basis are matrices.
DeclareGlobalFunction( "HomBasis" );
DeclareGlobalFunction( "GroupHomBasis" );
DeclareGlobalFunction( "OldHomBasis" );

#! @Arguments rep1, rep2
#!
#! @Returns a dimension for the space of module homomorphisms $A \to B$.
#!
#! @Description
#!    `DimHom( rep1, rep2)` returns the dimension of the space of 
#! module homomorphisms $rep1 \to rep2$.
DeclareGlobalFunction( "DimHom" );

#! @Arguments rep1, rep2, mat
#!
#! @Returns `true` or `false`
#!
#! @Description
#!   `IsHom` returns `true` if the matrix mat represents a homomorphism
#! from `rep1` to `rep1` and `false` otherwise.
DeclareGlobalFunction( "IsHom" );

#! @Arguments rep1, rep2
#!
#! @Returns a basis for the space of module homomorphisms $A \to B$
#!          which factor through a projective module
#!
#! @Description
#!   ProjectiveHomBasis returns a basis for the space of module
#! homomorphisms $A \to B$ which factor through a projective module.
#! The elements of this basis are matrices.
DeclareGlobalFunction( "ProjectiveHomBasis" );
DeclareGlobalFunction( "OldProjectiveHomBasis" );

#! @Arguments mat1, mat2
#!
#! @Returns the matrix of the tensor product of two morphisms.
#!
#! @Description
#!   `TensorProductMorphism` returns the matrix of the tensor
#! product of two morphisms, using the same basis
#! as `TensorProductRep`.
DeclareGlobalFunction( "TensorProductMorphism" );
DeclareGlobalFunction( "OldTensorProductMorphism" );

#! @Arguments G, H, rep
#!
#! @Returns the natural homomorphism
#!
#! @Description
#!   Given `G`, `H`, `rep` (group, subgroup and represenation
#! of subgroup, respectively), `InducedInclusion` returns the
#! natural homomorphism from rep to `RestrictedRep(G, H,
#! InducedRep( G, H, rep ) )`.
DeclareGlobalFunction( "InducedInclusion" );

#! @Arguments G, H, rep
#!
#! @Returns returns the natural projection.
#!
#! @Description
#!   Given `G`, `H`, `rep` (group, subgroup and represenation
#! of subgroup, respectively), `InducedProjection` returns the
#! natural projection from `RestrictedRep(G, H, InducedRep( G,
#! H, rep ) )` to rep.
DeclareGlobalFunction( "InducedProjection" );