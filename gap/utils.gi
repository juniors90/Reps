##############################################################################
##
## MakeIsoToPermGroup(rep) creates fields rep.permgroup and rep.isotopermgroup
## which are used by routines which are written to work only with permutation
## groups, typically involving an algorithm which goes down a stabilizer
## chain.
##
##############################################################################

#! MakeIsoToPermGroup is utils for:
#! - Commands for Trace, norm and principal idempotent.
#! - Commands that return lists of vectors:

InstallGlobalFunction( MakeIsoToPermGroup, function(rep)
    if IsBound(rep.permgroup) then
        return;
    fi;
    rep.isotopermgroup:=IsomorphismPermGroup(rep.group);
    rep.permgroup:=Image(rep.isotopermgroup,rep.group);
    return;
end );

##############################################################################
##
## SafeNullspaceMat(mat, F) returns a basis for the nullspace of mat, defined 
## over F. This works also when the domain or codomain are the zero vector space.
##
##############################################################################

#! SafeNullspaceMat is utils for:
#! - Catreps PKG.
#! - Commands that return lists of vectors.

InstallGlobalFunction( SafeNullspaceMat, function(mat, F)
    if mat=[] then
        return([]);
    fi;
    if mat[1]=[] then
        return(IdentityMat(Length(mat),F));
    fi;
    return(NullspaceMat(mat));
end );

##############################################################################
##
## SafeBaseMat(M) returns a list a basis vectors for the space spanned
## by the rows of M.  If M is an empty list, so M has no rows, or if
## the elements of M are empty lists, so M has no columns, then the
## empty list is returned.  
##
##############################################################################

#! SafeNullspaceMat is utils for:
#! - Catreps PKG.
#! - Test.
#! - Commands that return lists of vectors.
#! - Commands that return representations.
#! - Commands that return homomorphisms.

InstallGlobalFunction( SafeBaseMat, function(M)
    if IsEmpty(M) or IsEmpty(M[1]) then
        return [];
    else
        return BaseMat(M);
    fi;
end );

##############################################################################
##
## SafeIdentityMat(n, F) returns an nxn identity matrix over the field F.
## When n = 0, returns an empty list.
##
##############################################################################

#! SafeIdentityMat is utils for:
#! - Catreps PKG.
#! - Commands that return lists of vectors.

InstallGlobalFunction( SafeIdentityMat, function(n, F)
    if n=0 then
        return [];
    else
        return IdentityMat(n, F);
    fi;
end );


##############################################################################
##
## SafeMatrixMult(A, B, n) returns the product of matrices A and B,
## where A is kxm and B is mxn.  n is passed in because if B has no
## rows, then we can not determine n.
##
## If k=0, returns an empty list, i.e. the matrix with 0 rows and n columns.
## If n=0, returns the matrix with k rows and 0 columns.
## If m=0, then returns the kxn zero matrix.
##
##############################################################################


#! SafeMatrixMult is utils for:
#! - Commands that return lists of vectors.
#! - Commands that return representations.


InstallGlobalFunction( SafeMatrixMult, function(A, B, n)
    if IsEmpty(A) then     # k = 0
        return [];
    elif n=0 then          # n = 0
        return List(A, row->[]);
    elif IsEmpty(B) then   # m = 0
        return NullMat(Length(A), n);
    else
        return A*B;
    fi;
end );

#########################################################
## SocleNullspaceMat(matrix, dimension, field)
## returns a list of vectors forming a basis for the nullspace of the matrix,
## and deals with the situation where the matrix may have no rows, etc.
## It is used in SocleSeries(rep); SafeNullspaceMat works in other instances.
## Written by Peter Webb July 2016.
#########################################################

#! SocleNullspaceMat is utils for:
#! - Commands that return lists of vectors.

InstallGlobalFunction( SocleNullspaceMat, function(M,n,F)
    if n=0 or IsEmpty(M) then
        return SafeIdentityMat(n,F);
    else
        return NullspaceMat(M);
    fi;
end );

##############################################################################
##
## InverseGenImages(rep) returns the list of matrices which are the inverses
## of the matrices in rep.genimages. Two algorithms were tried: in
## OldInverseGenImages, rather than invert the matrices, they
## are raised to a power Order(g)-1 for each generator g. In fact, it appears
## on testing this out that GAP is faster at doing x -> x^-1.
##
##############################################################################

#! InverseGenImages is utils for:
#! - Commands that return representations.

InstallGlobalFunction( InverseGenImages, function(rep)
    if IsBound(rep.inversegenimages) then
        return(rep.inversegenimages);
    fi;    
    rep.inversegenimages:=List(rep.genimages, x->x^-1);
    return(rep.inversegenimages);
end );

InstallGlobalFunction( OldInverseGenImages, function(rep)
    local orders, inverses, i;
    if IsBound(rep.inversegenimages) then
        return(rep.inversegenimages);
    fi;    
    orders:=List(GeneratorsOfGroup(rep.group),Order);
    inverses:=[];
    for i in [1..Length(orders)] do
        if orders[i]=infinity then
            inverses[i]:=rep.genimages[i]^-1;
        else
            inverses[i]:=rep.genimages[i]^(orders[i]-1);
        fi;
    od;
    rep.inversegenimages:=inverses;
    return(inverses);
end );


##############################################################################
##
## TensorProductMatrix(M1,M2) . . . Tensor product of two matrices
##
## The GAP command KroneckerProduct seems inexplicably slow and in tests on
## two 60 x 60 matrices takes about twice as long as the following code.
##
##############################################################################

#! TensorProductMatrix is utils for:
#! - Catreps PKG.
#! - Commands that return representations.
#! - Commands that return homomorphisms.

InstallGlobalFunction( TensorProductMatrix, function( M1, M2 )
    local u, v, matrix;
    matrix := [];
    for u in M1 do
        for v in M2 do
            Add( matrix, Flat( List(u, x -> x * v ) ) );
        od;
    od;
    return(matrix);
end );

#############################################################################
##
##PermutationMatrix(perm,d,field)  We specify d so that the permutation is
## regarded as permuting [1..d]
##
#############################################################################

#! PermutationMatrix is utils for:
#! - Commands that return representations.

InstallGlobalFunction( PermutationMatrix, function(perm,d, field)
    local m, p;
    m:=NullMat(d,d,field);
    for p in [1..d] do
        m[p][p^perm]:=One(field);
    od;
    return(m);
end );

#############################################################################
##
## PermToMatrixGroup( permgrp, field ) . . transforms a permutation group 
## to a group of permutation matrices
##
#############################################################################

## PermToMatrixGroup := function( permgrp, field )
## 
##         local   matrix, g, p, d, mgens;
## 
##         d := LargestMovedPoint(permgrp);
##         mgens:=[];
##         for g in GeneratorsOfGroup(permgrp) do
##                 matrix:=NullMat(d,d,field);
##                 for p in [1..d] do
##                         matrix[p][p^g]:=One(field);
##                 od;
##                 Add(mgens,matrix);
##         od;
##         return(Group(mgens));
## end;

##############################################################################
##
## CanRightRep(group,subgroup,list of elements, element)
## returns the first element in the list which represents the same
## coset as the element.
## It does not verify the validity of its input.
##
##############################################################################

#! CanRightRep is utils for:
#! - Commands that return representations.

InstallGlobalFunction( CanRightRep, function( G, H, L, g )
    local h, k;
    h := g^-1;
    for k in L do
        if k*h in H then
            return k;
        fi; 
    od;
end );

##############################################################################
##
## RightCosetReps(group,subgroup) gives a list of representatives  of the 
## right cosets of a group relative to a given subgroup.
##
##############################################################################

#! RightCosetReps is utils for:
#! - Trace Norm and principal idempotent
#! - Commands that return representations.
#! - Commands that return homomorphisms.

InstallGlobalFunction( RightCosetReps, function(G,H)
   return List(RightCosets(G,H), Representative);
end );

## The function that gives the permutation representation of an element g
## on a list L of right cosets of a subgroup has a built-in definition as
## Permutation(g,L,OnRightCosets), but the problem is that L has to be a list 
## whose elements are themselves lists, each containing the elements of
## a Right Coset (Cosets are not lists).

##############################################################################
##
## GLG(n,q) is a generalized version of GeneralLinearGroup
## which does accept the case of dimension 1. 
##
##############################################################################

#! GLG is utils for:
#! - Commands that return homomorphisms.

InstallGlobalFunction( GLG, function(n,q)
   if n=1 then
      return(Group(Z(q)*IdentityMat(1,GF(q))));
   else 
      return(GeneralLinearGroup(n,q));
   fi;
end );

############################################################################
##
## InducedMorphism(group, subgroup, matrix) computes the induced
## homomorphism of a map between representations of the subgroup.
##
## Code written by Dan Christensen, University of Western Ontario,August 2007
##
############################################################################

#! InducedMorphism is utils for:
#! - None

InstallGlobalFunction( InducedMorphism, function(G,H,S)
   local index;
   index := Index(G,H);
   return BlockMatrix(List([1..index], i->[i,i,S]), index, index);
   # Alternate implementation:
   # K := figure out the field
   # return KroneckerProduct(IdentityMat(index, K), S)
end );

##############################################################################
##
## DecomposeOnce(rep) . . probably returns a list of two bases for summands
## of the representation rep if it is decomposable, and returns a list whose
## only element is the standard basis if it is indecomposable. 
##
## This code was written by Bryan Simpkins and Robert Hank, University of
## Minnesota, April 2006
##
##############################################################################

#! DecomposeOnce is utils for:
#! - None

InstallGlobalFunction( DecomposeOnce, function(rep)
	return DecomposeSubmodule(rep, IdentityMat(rep.dimension, rep.field));
end );

##############################################################################
##
## MatsOfCosetReps(rep) . . returns a list
##
## [rep of a proper subgroup, 
## list of matrices of right coset representatives of the subgroup,
## list of right coset representatives of the subgroup].
##
## The coset representatives are a Schreier
## transversal for the stabilizer of a point, and the stabilizer subgroup has Schreier
## generators for the stabilizer. At the same time matrices which
## represent the elements which arise are stored.
##
## This function is called by NormRep, MatrixOfElement and RestrictedRep.
## 
##############################################################################

#! SafeNullspaceMat is utils for:
#! - Commands that return lists of vectors.
#! - Commands that return representations.

InstallGlobalFunction( MatsOfCosetReps, function(rep)
    local s, orbit, positions, mats, inversemats, perms, gens, q, x, j, ximage, table,
    subgroupgens, subgroupgenimages;
    s:=SmallestMovedPoint(rep.group);
    orbit:=[s];
    positions:=[];
    mats:=[];
    mats[s]:=IdentityMat(rep.dimension,rep.field);
    inversemats:=[];
    inversemats[s]:=IdentityMat(rep.dimension,rep.field);
    perms:=[];
    perms[s]:=();
    gens:=GeneratorsOfGroup(rep.group);
    InverseGenImages(rep);
    table:=[];
    for j in [1..Length(gens)] do
        table[j]:=[];
    od;
    q:=1;
    while IsBound(orbit[q]) do
        x:=orbit[q];
        for j in [1..Length(gens)] do
            ximage:=x^gens[j];
            if not ximage in orbit then
                Add(orbit,ximage);
                positions[ximage]:=j;
                perms[ximage]:=perms[x]*gens[j];
                mats[ximage]:=mats[x]*rep.genimages[j];
                inversemats[ximage]:=rep.inversegenimages[j]*inversemats[x];
                else table[j][x]:=perms[x]*gens[j]*perms[ximage]^-1;
            fi;
        od;
        q:=q+1;
    od;
    subgroupgens:=[];
    subgroupgenimages:=[];
    for j in [1..Length(gens)] do
        for x in orbit do
            if IsBound(table[j][x]) and
            Size(Group(subgroupgens,()))<
            Size(Group(Concatenation(subgroupgens,[table[j][x]])))
                then Add(subgroupgens,table[j][x]);
                Add(subgroupgenimages,mats[x]*rep.genimages[j]*inversemats[x^gens[j]]);
            fi;
        od;
    od;
    return ([rec(
        group:=Group(subgroupgens,()),
        genimages:=subgroupgenimages,
        field:=rep.field,
        dimension:=rep.dimension,
        isRepresentation:=true,
        operations:=GroupRepOps
        ),
        mats,perms]);
end );

##############################################################################
##
## IsProjectiveMorphism(rep1, rep2, f) returns whether or not
## the morphism f: rep1 --> rep2 factors through a projective.
## f is assumed to be a kG-module homomorphism.
##
##############################################################################

#! IsProjectiveMorphism is utils for:
#! - None

InstallGlobalFunction( IsProjectiveMorphism, function(M,N,f)
    local mat, n;
    mat:=ProjectiveHomBasis(M,N);
    n:=Length(mat);
    Add(mat,f);
    mat:=List(mat,Flat);
    return RankMat(mat)=n;
end );

##############################################################################
##
## RepToMatGroup(rep) returns the matrix group which is the image of the
## representation.
##
##############################################################################

#! RepToMatGroup is utils for:
#! - None

InstallGlobalFunction( RepToMatGroup, function(phi)
    return(Group(phi.genimages,IdentityMat(phi.dimension,phi.field)));
end );

GroupRepOps:=rec(Decompose:=DecomposeGroupRep,
                            SubmoduleRep:=SubmoduleGroupRep,
                            QuotientRep:=QuotientGroupRep,
                            Spin:=GroupSpin,
                            CoSpin:=GroupCoSpin,
                            HomBasis:=GroupHomBasis,
                            DecomposeSubmodule:=GroupDecomposeSubmodule,
                            SumOfImages:=GroupSumOfImages,
                            TensorProductRep:=TensorProductGroupRep,
                            DirectSumRep:=DirectSumGroupRep			
                            );