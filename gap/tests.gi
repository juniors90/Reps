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

InstallGlobalFunction( IsIrreducibleRep, function(rep)
    if rep.dimension = 0 then
        return(false);
    fi;
    return( MTX.IsIrreducible( RepToMeataxeModule( rep ) ) );
end );

InstallGlobalFunction( IsAbsolutelyIrreducibleRep, function(rep)
    if rep.dimension = 0 then
        return(false);
    fi;
    return( MTX.IsAbsolutelyIrreducible( RepToMeataxeModule( rep ) ) );
end );

##############################################################################
##
## IsProjectiveRep(rep) returns true if the representation is a projective
## module, and false otherwise. The algorithm restricts the representation
## to a Sylow p-subgroup and tests whether |G| times the rank of the norm
## map equals the dimension of the representation.
##
##############################################################################

InstallGlobalFunction( IsProjectiveRep, function( rep )
    local s, resrep, n;
    if Characteristic(rep.field) = 0 then
        return(true);
    fi;
    s := SylowSubgroup( rep.group, Characteristic( rep.field ) );
    # s:=Subgroup(rep.group, SmallGeneratingSet(s)); This line is for permutation groups
    resrep := RestrictedRep(rep.group, s, rep);
    n := NormRep(resrep);
    if Rank(n) * Size(s) = rep.dimension then
        return(true);
    else
        return(false);
    fi;
end );

######################################
##
##  IsIsomorphicSummand(rep1,rep2) only works when rep1 is indecomposable of dimension prime to the field characteristic. 
##  It returns true if rep1 is isomorphic to a direct summand of rep2, false otherwise. It relies on a result of Benson
## and Carlson. Written by Peter Webb Feb 2020.
##
######################################


InstallGlobalFunction( IsIsomorphicSummand, function( rep1, rep2 )
    local hom, vecs, d;
    if rep1.dimension mod Characteristic(rep1.field) = 0 then
        Error("The dimension needs to be prime to the characteristic.");
    fi;
    if rep1.dimension <> rep2.dimension then
        return false;
    fi;
    hom := TensorProductRep(DualRep(rep1),rep2);
    vecs := FixedQuotient(hom);
    d := Length(vecs);
    vecs := SafeBaseMat( Concatenation(vecs, FixedPoints@( hom ) ) );
    return Length(vecs) > d;
end );