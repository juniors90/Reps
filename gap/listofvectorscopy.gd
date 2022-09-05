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

#! @Chapter Commands that return lists of vectors

#! FixedQuotient(rep) returns a basis for augmentation ideal . module.
#! Handles trivial groups and zero-dimensional reps.
DeclareGlobalFunction( "FixedQuotient" );

#! SubFixedQuotient(rep, list of vecs)
#! returns a basis for augmentation ideal . submodule spanned by the vecs.
#! The span of the vecs must be a submodule, and this is not checked.
#! Handles trivial groups, zero-dimensional reps and empty u.
DeclareGlobalFunction( "SubFixedQuotient" );

#! BrauerTraceImage(representation, p-subgroup of rep.group) returns a list
#! of vectors that is a basis for the sum of the images of traces from proper
#! subgroups of the p-group.  Written by Peter Webb June 2016.
DeclareGlobalFunction( "BrauerTraceImage" );

#! Spin(rep, veclist) returns a basis for the submodule generated by the
#! vectors in veclist, which must be a list of vectors.
#!
#! GroupSpin is called by Spin(rep, veclist) when rep is a
#! group representation.
DeclareGlobalFunction( "Spin" );
DeclareGlobalFunction( "GroupSpin" );

#! CoSpin(rep, veclist) . . .returns a basis for the largest submodule
#! contained in the vector subspace spanned by veclist.
#!
#! GroupCoSpin is called by CoSpin(rep, veclist) when rep is a
#! group representation.
DeclareGlobalFunction( "CoSpin" );
DeclareGlobalFunction( "GroupCoSpin" );

#! SumOfImages(rep,rep) . . returns a basis for the sum of images of all 
#! module homomorphisms A -> B
#!
#! GroupSumOfImages is called by SumOfImages(rep,rep) when rep is a
#! group representation.
#!
#! Updated by Peter Webb Sep 11, 2007
DeclareGlobalFunction( "SumOfImages" );
DeclareGlobalFunction( "GroupSumOfImages" );

#! KernelIntersection(rep,rep) . . returns a basis for the intersection of the kernels of all 
#! module homomorphisms A -> B
#! Created by Peter Webb May 8, 2019. Corrected April 18, 2020.
#! This uses a version of SafeNullspaceMat with two arguments, the second being the field.
DeclareGlobalFunction( "KernelIntersection" );

#! Decompose(rep) . . returns a list of bases of direct summands of rep which
#! are probably indecomposable.
#!
#! DecomposeGroupRep is called by Decompose(rep) when rep
#! is a group representation.
#!
#! This code was written by Bryan Simpkins and Robert Hank, University of
#! Minnesota, April 2006.
#! It was modified by Dan Christensen and Peter Webb August 2007 so that indecomposable
#! representations are only checked once (before they were checked twice),
#! so as to use space more economically, and so that the result is stored
#! in rep.summands.
DeclareGlobalFunction( "Decompose" );
DeclareGlobalFunction( "DecomposeGroupRep" );

#! DecomposeSubmodule(repn, basis) . . probably returns a list of two bases 
#! for summands of 
#! the submodule of repn spanned by basis, if the module is decomposable, and
#! if the module is indecomposable it returns a list whose only element is the
#! given basis.
#!
#! GroupDecomposeSubmodule is called by DecomposeSubmodule(repn, basis) when repn
#! is a group representation.
#!
#! This code was written by Bryan Simpkins and Robert Hank, University of
#! Minnesota, April 2006. A related approach was taken by Michael Smith in
#! code written in 1993.
#! It was tidied up by Dan Christensen, University of Western Ontario, Aug 2007.
#! In July 2016 Craig Corsi, University of Minnesota, made a change so that
#! decompositions over fields larger than the field of definition of the 
#! representation are found.
DeclareGlobalFunction( "DecomposeSubmodule" );
DeclareGlobalFunction( "GroupDecomposeSubmodule" );

#! ProjectiveDecomposition(rep) returns a list of two bases, for a submodule
#! which is projective, and for a submodule with probably no non-zero projective summands,
#! whose direct sum is the whole representation. 
DeclareGlobalFunction( "ProjectiveDecomposition" );

#! ProjectiveSummand(rep) returns a basis for a maximal projective direct summand of
#! rep. It is only guaranteed to work when the group is a p-group in characteristic p.
#! In other cases it may give a correct answer, and if it does not then an error
#! message is returned. It does not use Decompose. Written by Peter Webb February 2020.
DeclareGlobalFunction( "ProjectiveSummand" );

#! ProperSubmodule(rep) calls the meataxe command MTX.ProperSubmoduleBasis
#! and returns a basis for a proper submodule, or [] if there is none.
DeclareGlobalFunction( "ProperSubmodule" );
DeclareGlobalFunction( "RadicalRep" );
DeclareGlobalFunction( "SocleRep" );

#! RadicalSeries(rep) returns a list with two entries [bases, reps] where 
#! bases is a list of bases of the successive powers of the radical
#! `rep = rad^0(rep)`, `rad^1(rep)`, ...
#! in descending order. The last term in the list is the empty list.
#! reps is a list of the representations on the radical quotients
#! `rep/rad^1(rep)`, `rad^1(rep)/rad^2(rep)`. ...
#! all of which are semisimple. The last term is the last nonzero 
#! representation, and so the list is one shorter than bases.
#! Written by Peter Webb July 2016.

DeclareGlobalFunction( "RadicalSeries" );

#! SocleSeries(rep) returns a list with two entries [bases, reps] where 
#! bases is a list of bases of the higher socles
#! `rep = soc^t(rep)`, `soc^(t-1)(rep)`, ...
#! in DESCENDING order. The last term in the list is the empty list.
#! reps is a list of the representations on the socle quotients
#! `rep/soc^(t-1)(rep)`, `soc^(t-1)(rep)/soc^(t-2)(rep)`. ...
#! all of which are semisimple. The last term is the last nonzero 
#! representation, and so the list is one shorter than bases.
#! Written by Peter Webb July 2016.
DeclareGlobalFunction( "SocleSeries" );

#! ButterflyFactors(rep, descending filtration, descending filtration) 
#! returns a matrix whose entries are the representations that appear as
#! sections in Zassenhaus' Butterfly Lemma.
#! Each descending filtration is a list of bases of submodules of rep, forming
#! a descending chain. The representations in the output are the factors in
#! a common refinement of the two filtrations, fand their position in the 
#! refinement is indicated by their position in the matrix.
#! Written by Peter Webb July 2016
DeclareGlobalFunction( "ButterflyFactors" );
DeclareGlobalFunction( "BasesCompositionSeriesRep" );

#! MatrixOfElement(rep,group element) returns the matrix which represents
#! the group element.
DeclareGlobalFunction( "MatrixOfElement" );

#! MatricesOfElements(rep,list of group elements) returns the list of matrices 
#! which represent the group elements.
DeclareGlobalFunction( "MatricesOfElements" );