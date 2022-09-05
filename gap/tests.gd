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

#! @Chapter Test
#!
#! In the following routines several of the meataxe commands available in GAP
#! are converted so that they take representations as arguments and return
#! representations, where the meataxe implementation would have returned
#! meataxe modules. Clearly more of the meataxe commands could be implemented
#! than is done below.
#!
#! @Section Methods
#!
#! The purpose of these commands is to allow further meataxe commands,
#! other than the ones already listed above, to be used.
#!
#! @Arguments rep
#!
#! @Returns `true` or `false`
#!
#! @Description
#!   IsIrreducibleRep returns `true` if the representation `rep` is 
#!  irreducible and `false` otherwise. This function calls the meataxe
#!  routine MTX.IsIrreducible which is already implemented in GAP.
DeclareGlobalFunction( "IsIrreducibleRep" );

#! @Arguments rep
#!
#! @Returns `true` or `false`
#!
#! @Description
#!   IsAbsolutelyIrreducibleRep returns `true` if the representation `rep` is 
#!  irreducible and `false` otherwise. This function calls the meataxe
#!  routine MTX.IsIrreducible which is already implemented in GAP.
DeclareGlobalFunction( "IsAbsolutelyIrreducibleRep" );

#! @Arguments rep
#!
#! @Returns `true` or `false`
#!
#! @Description
#!   `IsProjectiveRep` returns `true` if the representation `rep` is
#! projective and `false` otherwise. This function restricts the
#! representation to a Sylow $p$-subgroup and tests whether its
#! dimension equals $|G|$ times the rank of the norm map.
DeclareGlobalFunction( "IsProjectiveRep" );

#! @Arguments rep1, rep2
#!
#! @Returns `true` or `false`
#!
#! @Description
#!   `IsIsomorphicSummand` returns `true` if `rep1` is isomorphic to a
#! direct summand of `rep`2`, `false` otherwise. It only works
#! when `rep1` is indecomposable of dimension prime to the field
#! characteristic. It relies on a result of Benson and Carlson.
DeclareGlobalFunction( "IsIsomorphicSummand" );