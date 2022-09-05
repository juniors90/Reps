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
#! @Section Methods
#!
#! The purpose of these commands is to allow further meataxe commands,
#! other than the ones already listed above, to be used.
#!
#! @Arguments rep
#!
#! @Returns a meataxe module
#!
#! @Description
#!   RepToMeataxeModule(rep) converts a representation `rep` to a meataxe
#! module.
DeclareGlobalFunction( "RepToMeataxeModule" );

#! @Arguments rep, meataxemodule
#!
#! @Returns a representation
#!
#! @Description
#!   `MeataxeModuleToRep` converts a meataxe module `meataxemodule` to
#! a representation. Because the meataxe module does not store the group
#! being represented, this is obtained from a representation called rep
#! whose only property is that rep.group is the required group.
DeclareGlobalFunction( "MeataxeModuleToRep" );