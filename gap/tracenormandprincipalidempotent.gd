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

#! @Chapter Trace, norm and principal idempotent
#!
#! @Section Methods
#!
#! @Arguments G, H, rep
#!
#! @Returns the matrix of the relative trace map.
#!
#! @Description
#!   Given `G`, `H`  and `rep` (group, subgroup and representation,
#! repectively), `RelativeTrace` returns the matrix of the
#! relative trace map. This should only be applied to fixed points
#! for it to be well-defined.
DeclareGlobalFunction( "RelativeTrace" );

#! @Arguments rep
#!
#! @Returns the matrix which represents the sum of the group elements.
DeclareGlobalFunction( "NormRep" );
DeclareGlobalFunction( "OldNormRep" );

#! @Section Methods
#!
#! @Arguments G, prime
#!
#! @Returns the matrix of the relative trace map.
#!
#! @Description
#!   PrincipalIdempotent(group, prime). . returns a vector
#! in the representation space of RegularRep(group, GF(prime))
#! that is the block idempotent of the principal block.
DeclareGlobalFunction( "PrincipalIdempotent" );