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

##############################################################################
##
## RelativeTrace(group,subgroup,rep) computes the matrix that corresponds to the mapping
## tr_Q^P(v)=v(sum gi), where Q is a subgroup
## of P, v is a vector in a P-representation phi, and the gi are a
## complete list of representatives of right cosets of Q in P.
##
## The real use of this function is to apply the mapping to vectors which
## are fixed by the subgroup, and then the result is fixed by the whole group.
##
## The algorithm is not very clever, and if the index of the subgroup is large
## it would be better to construct a chain of subgroups between the two groups
## and compute the relative trace as the product of the relative traces between
## pairs of groups in the chain. Such an algorithm is used in the command
## NormRep which returns the relative trace from the identity subgroup.
##
##############################################################################

InstallGlobalFunction( RelativeTrace, function(G, H, rep)
   local M, l, g, ghbi;
   M := NullMat( rep.dimension, rep.dimension, rep.field );
   l := RightCosetReps( G, H );
   ghbi := RepToGHBI( rep );
   for g in l do
      M := M + Image( ghbi, g );
   od;
   return M;
end );

##############################################################################
##
## NormRep(rep) . . returns the matrix which represents the sum of the group
##                  elements.
##
## NormRep calls MatsOfCosetReps recursively until the subgroup is the identity group, and
## multiplies the sums of the matrices of the coset representatives. 
## 
##############################################################################
 
InstallGlobalFunction( NormRep, function(rep)
    local output, newrep, temp, a, sum;
    output:=IdentityMat(rep.dimension,rep.field);
    MakeIsoToPermGroup(rep);
    newrep:=rec(
        group:=rep.permgroup,
        genimages:=rep.genimages,
        field:=rep.field,
        dimension:=rep.dimension,
        isRepresentation:=true,
        operations:=GroupRepOps
    );
    while Size(newrep.group)>1 do
        temp:=MatsOfCosetReps(newrep);
        newrep:=temp[1];
        sum:=NullMat(rep.dimension,rep.dimension,rep.field);
        for a in temp[2] do
            sum:=sum+a;
        od;
        output:=sum*output;
    od;
    return output;
end );

InstallGlobalFunction( OldNormRep, function(rep)
        local p, currentgroup, stablist, subgroup, replist, norm;
        currentgroup := rep.group;
        p := RepToGHBI(rep);
        norm := IdentityMat(rep.dimension,rep.field);
        while not IsTrivial(currentgroup) do;
             stablist := StabChain(currentgroup);
             subgroup := Subgroup(currentgroup,stablist.stabilizer.generators);
             replist := RightCosetReps(currentgroup, subgroup);
             replist := List( replist, x -> ImagesRepresentative(p, x));
             norm := Sum(replist) * norm;
             currentgroup := subgroup;
        od;
        return norm;
end );

################################################
#
# PrincipalIdempotent( group, prime ) returns a vector in the representation space of 
# RegularRep(group, GF(prime)) that is the block idempotent of the principal block. Thus if b is 
# this idempotent and e denotes the vector in the regular representation corresponding to the
# identity elements, the vector b.e is returned. Spinning it gives a basis for the principal block. 
# This idempotent is constructed using a formula of B. Kulshammer Arch. Math 56 (1991) 313-319.
# Code written by Peter Webb February 2020.
#
################################################

InstallGlobalFunction( PrincipalIdempotent, function( group, prime )
    local els, primepart, coeffs, pels, qels, qelspos, x, y, position; 
    els := RightCosetReps(group, Group(Identity(group)));
    primepart := prime^LogInt(Size(group),prime);
    coeffs := List(els,x->0);
    pels := ShallowCopy(els);
    for x in [1..Length(pels)] do
        if RemInt(primepart,Order(pels[x])) <>0 then
            Unbind(pels[x]);
        fi;
    od;
    # pels:=Compacted(pels);
    qels := ShallowCopy(els);
    qelspos := List(qels,x->1);
    for x in [1..Length(qels)] do
        if GcdInt(Order(qels[x]),prime)<>1 then
            Unbind(qels[x]);
            qelspos[x] := 0;
        fi;
    od;
    # qels:=Compacted(qels);
    for x in pels do
        for y in qels do
            position := Position(els, x*y);
            coeffs[position]:=coeffs[position]+qelspos[position];
        od;
    od;
    coeffs := (Length(qels)*Z(prime)^0)^-1*coeffs;
    return(coeffs);
end );