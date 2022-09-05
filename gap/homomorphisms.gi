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
## RepToGHBI(rep) turns a representation into a GroupHomomorphismByImages
## with the corresponding data.
##
##############################################################################

InstallGlobalFunction( RepToGHBI, function( rep )
    local glg, h;
    glg := GLG( rep.dimension, Size( rep.field ) );
    h := GroupHomomorphismByImagesNC( rep.group, glg, GeneratorsOfGroup( rep.group ), rep.genimages );
    #   h.isMapping:=true;
    #   h.isHomomorphism:=true;
    #   h.isGroupHomomorphism:=true;
   return h; 
end );

##############################################################################
##
## HomBasis(M, N) returns a basis for the space of 
## kG-module homomorphisms M -> N. The elements of this basis are matrices.
##
## The algorithm used finds matrices X so that Xg-gX=0 for all group generators
## g. This sets up a linear algebra problem more efficiently than solving
## gXg^-1=X, and was observed independently by John Pliam (1993),
## Michael Smith (1993) and Dan Christensen (2007).
## This code written by Dan Christensen, August 2007.
##
## GroupHomBasis is called by HomBasis(M, N) when M is a
## group representation.
##
##############################################################################

InstallGlobalFunction( HomBasis, function(M,N)
    return M.operations.HomBasis(M,N);
end );

InstallGlobalFunction( GroupHomBasis, function(M,N)
    local dimM, dimN, r, i, j, k, l, v, f, basis, m, u;
    dimM := M.dimension;
    dimN := N.dimension;
    r := Length(M.genimages);
    v := NullMat(dimM*dimN, dimM*dimN*r, M.field);
    for i in [1..dimM] do
        for k in [1..dimN] do
            for l in [1..r] do
                for j in [1..dimM] do
                    v[(j-1)*dimN+k][(l-1)*dimM*dimN+(i-1)*dimN+k] :=
                    v[(j-1)*dimN+k][(l-1)*dimM*dimN+(i-1)*dimN+k] + M.genimages[l][i][j];
                od;
                for j in [1..dimN] do
                    v[(i-1)*dimN+j][(l-1)*dimM*dimN+(i-1)*dimN+k] :=
                    v[(i-1)*dimN+j][(l-1)*dimM*dimN+(i-1)*dimN+k] - N.genimages[l][j][k];
                od;
            od;
        od;
    od;
    f := NullspaceMat(v);
    basis:=[];
    for m in f do
        u:=[];
        for i in [1..M.dimension] do
            u[i]:=[];
            for j in [1..N.dimension] do
                u[i][j]:=m[N.dimension*(i-1)+j];
            od;
        od;
        Add(basis, u);
    od;
    return(basis);
end );

##############################################################################
##
## OldHomBasis(rep1,rep2) . . returns a basis for the space of 
## module homomorphisms A -> B. The elements of this basis are matrices.
##
## This function is not as fast as the code for HomBasis written by 
## Dan Christensen, which has a more straightforward setup matrix whose
## nullspace we find.
##
##############################################################################

InstallGlobalFunction( OldHomBasis, function(g,h)
    local  f, basis, i, j, m, u;
    f := FixedPoints@(TensorProductRep(DualRep(g),h));
    basis := [];
    u := [];
    for m in f do
        for i in [1..g.dimension] do
            u[i] := [];
            for j in [1..h.dimension] do
                u[i][j] := m[h.dimension*(i-1)+j];
            od;
        od;
        Add(basis,ShallowCopy(u));
    od;
    return(basis);
end );

##############################################################################
##
## DimHom(rep1,rep2) . . returns the dimension of the space of 
## module homomorphisms $rep1 \to rep2$.
##
##############################################################################

InstallGlobalFunction( DimHom, function( rep1, rep2 )
    return Length( HomBasis( rep1, rep2 ) );
end );

############################################################################
##
## IsHom(rep1, rep2, mat) returns true if the matrix mat represents a
## homomorphism from rep1 to rep2.  Quite useful for testing.
##
## Code written by Dan Christensen, University of Western Ontario,August 2007
##
############################################################################

InstallGlobalFunction( IsHom, function(rep1, rep2, mat)
    local i;
    if rep1.group <> rep2.group then
        Error("You must have two representations of the same group");
    fi;
    for i in [1..Length(rep1.genimages)] do
        if rep1.genimages[i] * mat <> mat * rep2.genimages[i] then
            return false;
        fi;
    od;
    return true;
end );

##############################################################################
##
## ProjectiveHomBasis(rep1,rep2) returns a list of matrices which form a basis for
## the space of module homomorphisms from rep1 to rep2 which factor through
## a projective module. The algorithm computes the image of the norm map
## applied to the representation Dual(rep1) tensor rep2.
##
##############################################################################

InstallGlobalFunction( ProjectiveHomBasis, function( rep1, rep2 )
    local  f, basis, i, j, m, u;
    f:=SafeBaseMat(NormRep(TensorProductRep(DualRep(rep1),rep2)));
    basis:=[];
    for m in f do
        u:=[];
        for i in [1..rep1.dimension] do
        u[i]:=[];
            for j in [1..rep2.dimension] do
                u[i][j]:=m[rep2.dimension*(i-1)+j];
            od;
        od;
        Add(basis,u);
    od;
    return(basis);
end );

InstallGlobalFunction( OldProjectiveHomBasis, function(rep1, rep2)
    local  f, basis, i, j, m, u;
    f := SafeBaseMat(OldNormRep(TensorProductRep(DualRep(rep1),rep2)));
    basis := [];
    u := [];
    for m in f do
        for i in [1..rep1.dimension] do
        u[i]:=[];
            for j in [1..rep2.dimension] do
                u[i][j]:=m[rep2.dimension*(i-1)+j];
            od;
        od;
        Add( basis, ShallowCopy(u) );
    od;
    return(basis);
end );

##############################################################################
##
## TensorProductMorphism(M1,M2) Kronecker product of two morphisms
##
## Function introduced August 2007 by Dan Christensen.
##
##############################################################################

InstallGlobalFunction( TensorProductMorphism, function( M1, M2)
    return TensorProductMatrix( M1, M2 );
end );

InstallGlobalFunction( OldTensorProductMorphism, function( M1, M2 )
    return KroneckerProduct( M1, M2 );
end );

############################################################################
##
## InducedInclusion(group, subgroup, rep of subgroup) computes the natural
## homomorphism from rep to RestrictedRep(G, H, InducedRep(G, H, rep)).
## With the basis conventions chosen here, this is just a matrix of the
## form [ I | Z ], where I is an identity matrix and Z is a zero matrix.
##
##
## Code written by Dan Christensen, University of Western Ontario,August 2007
##
############################################################################

InstallGlobalFunction( InducedInclusion, function(G,H,rep)
    local dim, index, M, F, i;
    F := rep.field;
    dim := rep.dimension;
    index := Index(G,H);
    M := NullMat(dim, dim*index, F);
    for i in [1..dim] do
        M[i][i] := One(F);
    od;
    return M;
end );

############################################################################
##
## InducedProjection(group, subgroup, rep of subgroup) computes the natural
## projection from RestrictedRep(G, H, InducedRep(G, H, rep)) to rep.
## With the basis conventions chosen here, this is just a matrix of the
## form [ I ], where I is an identity matrix and Z is a zero matrix.
##      [ Z ]
##
## Code written by Dan Christensen, University of Western Ontario,August 2007
##
############################################################################

InstallGlobalFunction( InducedProjection, function(G,H,rep)
   local dim, index, M, F, i;
   F := rep.field;
   dim := rep.dimension;
   index := Index(G,H);
   M := NullMat(dim*index, dim, F);
   for i in [1..dim] do
      M[i][i] := One(F);
   od;
   return M;
end );