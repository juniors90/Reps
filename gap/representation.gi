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

#############################################################################
## Rep(group,matrices,optional field)
## This function creates a representation provided the group is not the
## identity group and the representation is not the zero representation.
## Modification by Craig Corsi and Peter Webb (University of Minnesota)
## 2016 to allow the optional field argument.
##############################################################################

InstallGlobalFunction( Rep, function(arg)
    local G, L, rep;
    G:=arg[1];L:=arg[2];
    if L=[] then 
        Error("Identity group encountered: creating representations is not properly set up for the identity group.");
        return;    
    fi;
    rep:=rec(
            group:=G,
            genimages:=L,
            isRepresentation:=true,
            dimension:=Length(L[1]),
            operations:=GroupRepOps
            );
    if Length(arg)=2 then
        rep.field:=Field(L[1][1]);
    else
        rep.field:=arg[3];
    fi;
    return rep;
end ); 

##############################################################################
##
## PermutationRep(group,list of permns,field) returns the representation
## on the permutation module determined by the permutation representation
## in which the group generators act as the permutations in the list.
##
##############################################################################

InstallGlobalFunction( PermutationRep, function( group, perms, field )
    local d;
    d := Maximum( List( perms, LargestMovedPointPerm ) );
    return Rep( group, List( perms, x->PermutationMatrix( x, d, field ) ) );
end );

#########################################################
## PermutationRepOnCosets(group,subgroup,field) returns the representation
## which is the permutation module determined by the right cosets
## of the subgroup in the group.
## Modification by Craig Corsi (University of Minnesota)
## 2016 to make sure the field is correctly recorded.
##
#########################################################

InstallGlobalFunction( PermutationRepOnCosets, function(G,H,F)
    local n , L, M, phi, g, i, j, R, k;
    L:=[]; R:=[];
    L:=RightCosets(G,H);
    n:=Length(L);
    for k in [1..Length(GeneratorsOfGroup(G))] do
        g:=GeneratorsOfGroup(G)[k];
        M:=NullMat(n,n,F);
        for i in [1..n] do
            j:=0;
            repeat j:=j+1;
            until L[i]*g=L[j];
            M[i][j]:=Z(Size(F))^0;
        od;
        R[k]:=M;
    od;
    phi:=Rep(G,R,F);
    return phi;
end );

#############################################################################
##
## PermGroupToRep . . transforms a permutation group to a permutation
##                                representation
#############################################################################

InstallGlobalFunction( PermGroupToRep, function( permgrp, field )

        local   matrix, g, p, d, mgens;

        d := LargestMovedPoint(permgrp);
        mgens:=[];
        for g in GeneratorsOfGroup(permgrp) do
                matrix:=NullMat(d,d,field);
                for p in [1..d] do
                        matrix[p][p^g]:=One(field);
                od;
                Add(mgens,matrix);
        od;
        return(Rep(permgrp,mgens));
end );

##############################################################################
##
## RegularRep(group, field) returns the group ring as a
## representation.
## 
## The basis is given by the elements of G, in the order given
## by RightCosetReps(G, Group(Identity(G)), which is not necessarily
## the order given by Elements(G).
##
## Code written by Dan Christensen, University of Western Ontario,August 2007
##
##############################################################################

InstallGlobalFunction( RegularRep, function(G, field)
    return PermutationRepOnCosets(G, Group(Identity(G)), field);
end );

##############################################################################
##
## FreeRep(group, field, n) returns the direct sum of n copies
## of the group ring as a representation.
##
## Code written by Dan Christensen, University of Western Ontario,August 2007
##
##############################################################################

InstallGlobalFunction( FreeRep, function(G, field, n)
    return TensorProductRep(TrivialRepN(G, field, n), RegularRep(G, field));
end );

##############################################################################
##
## TrivialRep(group,field)
##
## This works even when the group is the identity group.
##
##############################################################################

InstallGlobalFunction( TrivialRep, function( group, field )
    local mats,onemat;
    onemat:=IdentityMat(1,field);
    mats:=List(GeneratorsOfGroup(group), g->onemat);
    return rec(
        group:=group,
        genimages:=mats,
        field:=field,
        dimension:=1,
        isRepresentation:=true,
        operations:=GroupRepOps
        );
end );

##############################################################################
##
## TrivialRepN(group,field,n): trivial action on n-dimensional vector space
##
## Code written by Dan Christensen, modified by Peter Webb Aug 2007 to work
## also with the identity group.
##
##############################################################################

InstallGlobalFunction( TrivialRepN, function( group, field, n )
    local mats,mat;
    mat:=IdentityMat(n,field);
    mats:=List(GeneratorsOfGroup(group), g->mat);
    return rec(
        group:=group,
        genimages:=mats,
        field:=field,
        dimension:=1,
        isRepresentation:=true,
        operations:=GroupRepOps
        );
end );

##############################################################################
##
## ZeroGroupRep(group,field)
##
##############################################################################

InstallGlobalFunction( ZeroGroupRep, function( group, field )
    return rec(
        group := group,
        genimages := List( GeneratorsOfGroup( group ), g -> [] ),
        field := field,
        dimension := 0,
        isRepresentation := true,
        operations := GroupRepOps
    );
end );

#############################################################################
##
## DualRep(rep) 
##
## Updated Aug 2007 by Peter Webb using the function InverseGenImages.
##
##############################################################################

InstallGlobalFunction( DualRep, function(rep)
    if rep.dimension=0 then
        return(rep);
    fi;
    return rec(
        group:=rep.group,
        genimages:=List(InverseGenImages(rep), TransposedMat),
        field:=rep.field,
        dimension:=rep.dimension,
        isRepresentation:=true,
        operations:=GroupRepOps
    );
end );

##############################################################################
##
## DirectSumGroupRep(rep1,rep2) returns the representation that is the direct sum of 
## representations rep1 and rep2 for the same group. Written by Peter Webb February 2020.
##
## DirectSumGroupRep is called by DirectSumRep(rep1,rep2) when rep1 and rep2 are
## group representations.
##
#############################################################################

InstallGlobalFunction( DirectSumRep, function( rep1, rep2 )
    return rep1.operations.DirectSumRep(rep1, rep2);
end );

InstallGlobalFunction( DirectSumGroupRep, function(rep1,rep2)
    local i, gimages, x, zerovec1, zerovec2, padded1, padded2;
    if rep1.field<>rep2.field or rep1.group<>rep2.group then
        Error("Representations incompatible.");
    fi;
    zerovec1:=Zero(rep1.field)*[1..rep1.dimension];
    zerovec2:=Zero(rep2.field)*[1..rep2.dimension];
    gimages:=[];
    for i in [1..Length(rep1.genimages)] do
    padded1:=List(rep1.genimages[i],x->Concatenation(x,zerovec2));
    padded2:=List(rep2.genimages[i],x->Concatenation(zerovec1,x));
    gimages[i]:=Concatenation(padded1,padded2);
    od;
    return rec(group:=rep1.group, genimages:=gimages, field:=rep1.field, dimension:=rep1.dimension+rep2.dimension,isRepresentation:=true,operations:=GroupRepOps);
end );

##############################################################################
##
## TensorProductRep(rep,rep) . . . Kronecker product of two representations
##
## TensorProductGroupRep is called by TensorProductRep(rep,rep) when rep is a
## group representation.
##
##############################################################################

InstallGlobalFunction( TensorProductRep, function(g,h)
    return g.operations.TensorProductRep(g,h);
end );

InstallGlobalFunction( TensorProductGroupRep, function(g,h)
    local mgens;
    if g.group <> h.group then
        Error("You must have two representations of the same group");
        return;
    fi;
    mgens:=List([1..Length(g.genimages)],
                i->TensorProductMatrix(g.genimages[i],h.genimages[i]));
    return Rep(g.group,mgens);
end );

InstallGlobalFunction( OldTensorProductRep, function(g,h)
    local mgens;
    if g.group <> h.group then
        Error("You must have two representations of the same group");
        return;
    fi;
    mgens:=List([1..Length(g.genimages)],
                i->KroneckerProduct(g.genimages[i],h.genimages[i]));
    return Rep(g.group,mgens);
end );


#############################################################################
##
## SubmoduleRep(rep, list of vecs) . .  returns the representation that gives
## the action on an invariant subspace. The list of vectors must be a basis
## for an invariant subspace. This is not checked.
##
## The code was tidied up by Dan Christensen Aug 2007 with the use of List
## and made to work for the identity group by Peter Webb Aug 2007.
## In Feb 2020 Peter Webb changed Size(rep.group) to rep.dimension, apparently
## correcting an error.
##
## SubmoduleGroupRep is called by SubmoduleRep(rep, list of vecs) when rep is a
## group representation.
##
#############################################################################

InstallGlobalFunction( SubmoduleRep, function(rep,vecs)
    return rep.operations.SubmoduleRep(rep,vecs);
end );

InstallGlobalFunction( SubmoduleGroupRep, function(rep,vecs)
    local vs, base, newimages, g;
    vs:=VectorSpace( rep.field, vecs, [1..rep.dimension]*Zero( rep.field ) );
    base:=Basis(vs, vecs);
    newimages := [];
    for g in rep.genimages do
        Add( newimages, List( base, b -> Coefficients( base, b * g ) ) );
    od;
    return rec(
        group:=rep.group,
        genimages:=newimages,
        field:=rep.field,
        dimension:=Length(base),
        isRepresentation:=true,
        operations:=GroupRepOps
	);
end );

#############################################################################
##
## QuotientRep(rep, list of vecs) . . . returns the representation giving the
## action on the quotient by an invariant subspace.
##
## The code includes a correction made by Roland Loetscher in March 2007 and
## was made to work for the identity group by Peter Webb in August 2007.
##
## QuotientGroupRep is called by QuotientRep(rep, list of vecs) when rep is a
## group representation.
##
#############################################################################

InstallGlobalFunction( QuotientRep, function(rep,v)
    return rep.operations.QuotientRep(rep,v);
end );

InstallGlobalFunction( QuotientGroupRep, function(rep,v)
    local base,d,n,zero,onemat,i,positions,b,p,g,
        mat,newb,newimages,baseinverse, vs, tempbase;
    if Length(v)=0 then
        return rep;
    fi;
    base:=ShallowCopy(BaseMat(v));
    TriangulizeMat(base);
    d:=Length(base);
    n:=rep.dimension;
    if d=n then
        return ZeroGroupRep(rep.group,rep.field);
    fi;
    zero:=Zero(rep.field);
    onemat:=IdentityMat(n,rep.field);
    i:=1;
    positions:=[];
    for b in base do
        while b[i]=zero do
            Add(positions,i);
            i:=i+1;
        od;
        i:=i+1;
    od;
    Append(positions,[i..n]);
    for p in positions do
        Add(base, onemat[p]);
    od;
    baseinverse:=base^-1;
    newimages:=[];
    for g in rep.genimages do
        mat:=[];
        for p in positions do
            b:=g[p]*baseinverse;
            newb:=[];
            for i in [d+1..n] do
                Add(newb,b[i]);
            od;
            Add(mat,newb);
        od;
        Add(newimages, mat);
    od;
    return rec(
        group:=rep.group,
        genimages:=newimages,
        field:=rep.field,
        dimension:=n-d,
        isRepresentation:=true,
        operations:=GroupRepOps
        );
end );

#########################################################
## SectionRep(rep, list of vectors, list of vectors) returns the representation
## on the quotient of the submodule spanned by the first list of vectors, by
## the submodule spanned by the second list of vectors.
## The two lists should be independent sets, and should be bases for
## submodules of rep, the second submodule contained in the first.
## This is not checked.
## Written by Peter Webb July 2016.
#########################################################

InstallGlobalFunction( SectionRep, function( rep, vectorsa, vectorsb )
    local  repa, v, b, newvecsb ;
    repa:=SubmoduleRep(rep,vectorsa);
    v:=VectorSpace(rep.field,vectorsa, [1..rep.dimension]*Zero(rep.field));
    b:=Basis(v,vectorsa);
    newvecsb:=List(vectorsb,x->Coefficients(b, x));
    return(QuotientRep(repa,newvecsb));
end );

##############################################################################
##
## RestrictedRep(group, subgroup, rep of group) computes the restriction
## of a rep from a group to a subgroup.
##
## This code has been rewritten September 2007 by Peter Webb.
## The algorithm calls the function MatricesOfElements which finds the
## matrices representing the generators of the subgroup by working down a
## stabilizer chain for the group and at each stage computing matrices
## which represent the coset representatives of the stabilizer subgroups
## and also the generators of the stabilizers. This approach is more 
## economical that expressing each subgroup generator as a word in the 
## generators of the big group and then evaluating that word on matrices, because
## in such words there are repeated subwords which get evaluated again and
## again.
##
## The previous implementation of this function appears as OldRestrictedRep.
##
################################################################################

InstallGlobalFunction( RestrictedRep, function(G,H,rep)
    local R;
    R:=MatricesOfElements(rep,GeneratorsOfGroup(H));
    return rec(
        group:=H,
        genimages:=R,
        field:=rep.field,
        dimension:=rep.dimension,
        isRepresentation:=true,
        operations:=GroupRepOps
        );
end );

InstallGlobalFunction( OldRestrictedRep, function( G, H, phi )
    local ghbiphi, R;
    ghbiphi := RepToGHBI( phi );
    R:=List( GeneratorsOfGroup( H ), g -> ImagesRepresentative( ghbiphi, g ) );
    return rec(
        group:=H,
        genimages:=R,
        field:=phi.field,
        dimension:=phi.dimension,
        isRepresentation:=true,
        operations:=GroupRepOps
    );
end );

############################################################################
##
##
## InducedRep(group, subgroup, rep of subgroup) computes the induction
## of a rep from a subgroup to a group.
##
## In more detail, InducedRep(G, H, M) is M tensor_{kH} kG.
## If m_1, ..., m_n is the standard basis for M and g_1, ..., g_r
## are the coset representatives of the set {Hg} of right cosets,
## then the basis chosen for the induced representation is
##
##   m_1 tensor g_1, m_2 tensor g_1, ..., m_n tensor g_1,
##   m_1 tensor g_2, m_2 tensor g_2, ..., m_n tensor g_2,
##   ...
##   m_1 tensor g_r, m_2 tensor g_r, ..., m_n tensor g_r,
##
## in that order. 
##
############################################################################

InstallGlobalFunction( InducedRep, function( G, H, phi )
    local L, n, F, R, Q, g, i, j, h, S, k, l, ghbiphi;
    ghbiphi:=RepToGHBI(phi);
    R:=[]; n:=phi.dimension; F:=phi.field;
    L:=RightCosetReps(G,H);
    for g in GeneratorsOfGroup(G) do
        Q:=NullMat(n*Length(L),n*Length(L),F);
        for i in [1..Length(L)] do
            j:=Position(L,CanRightRep(G,H,L,L[i]*g));
            h:=L[i]*g*(L[j]^-1);
            S:=ImagesRepresentative(ghbiphi,h);
            for k in [1..n] do
                for l in [1..n] do
                    Q[k+(i-1)*n][l+(j-1)*n]:=S[k][l];
                od;
            od;
        od;
        Add(R, Q);
    od;
    return Rep(G,R);
end );

##############################################################################
##
## SymmetricPowerRep(rep, n) computes the action of rep on the n-th symmetric power
## of the vector space V associated with rep.
## This routine was written by Brad Froehle at the University of Minnesota, January 2007.
##
##############################################################################

InstallGlobalFunction( SymmetricPowerRep, function(rep, n)
	local Sn;

	## Define a function Sn which can be called repeatedly for each matrix corresponding to a generator of the group.
	Sn := function(A, n)
		local MyProduct, DualList, dimV, expEnd, dimOut, output, waysToSum, dual, i, j, l;

		## MyProduct(A, x, y)
		## 
		## Assumptions: A is a square n-by-n matrix, x and y are lists of the same length
		## whose entries are elements of [1..n]
		##
		## Output: the product A[x[1]][y[1]] * A[x[2]][y[2]] * A[x[3]][y[3]] * ...
		## 
		MyProduct := function(A, x, y)
			local output, i;
			output := 1;
			for i in [1..Length(x)]
				do
				output := output * A[x[i]][y[i]];
			od;
			return output;
		end;
		
		## DualList(A) 
		##
		## Assumptions: A is a list.
		##
		## Output: A list in which 1 is repeated A[1] times, 2 is repeated A[2] times, etc...
		##
		DualList := function(A)
			local i, output;
			output := [];
			for i in [1..Length(A)]
				do
				Append(output, List([1..A[i]], x->i));
			od;
			return output;
		end;

		## Define some variables which are used repeatedly:
		##  * dimV is the dimension of the initial representation.
		##  * expEnd is a list whose elements describe all possible monomials of total degree dimV.
		##  * dimOut is the dimension of the output representation, i.e. the number of monomials in expEnd.
		##
		dimV := Size(A);
		expEnd := Reversed(OrderedPartitions(dimV+n,dimV)-1);
		dimOut := Size(expEnd);
		
		## Initialize output to a dimOut x dimOut matrix of all zeros
		##
		output := [];
		for i in [1..dimOut]
			do
			output[i] := List([1..dimOut],x->0);
		od;

		## Iterate, calculating each entry of output individually.
		##
		for i in [1..dimOut]
			do
			# Because this next call (PermutationsList) might be slow, we calculate it as few times as possible.
			waysToSum := PermutationsList(DualList(expEnd[i]));
			for j in [1..dimOut]
				do
				# Calculate the ji-th entry here
				dual := DualList(expEnd[j]);
				for l in waysToSum
					do
					output[j][i] := output[j][i] + MyProduct(A, dual, l);
				od;
			od;
		od;
		return output;
	end;
	## End function Sn.
	
	return Rep(rep.group, List(rep.genimages, x-> Sn(x,n)));
end );

##############################################################################
##
## CompositionFactorsRep(rep) . .
##
##############################################################################

InstallGlobalFunction( CompositionFactorsRep, function( rep )
    local modules;
    if rep.dimension = 0 then
        return( [] );
    fi;
    modules := MTX.CompositionFactors( RepToMeataxeModule( rep ) );
    return( List( modules, x -> MeataxeModuleToRep( rep, x ) ) );    
end );

##############################################################################
##
## ProjectiveFreeCore(rep) returns the representation that is the largest direct summand of 
## rep with not projective summand. It is only guaranteed to work when the group is a p-group
## in characteristic p. In other cases it may give a correct answer, and if it does not then an error
## message is returned. Written by Peter Webb February 2020. There is another function 
## ProjectiveFreeSummand which invokes Decompose, and because of this will be more limited
##
##############################################################################

InstallGlobalFunction( ProjectiveFreeCore, function(rep)
    local n, resrep, vectors, sub;
    resrep:=RestrictedRep(rep.group, SylowSubgroup(rep.group,Characteristic(rep.field)),rep);
    n:=NormRep(resrep);
    if Length(n)=0 then
        return(rep);
    fi;
    vectors:=BaseSteinitzVectors(IdentityMat(rep.dimension,rep.field),NullspaceMat(n));
    sub:=Spin(rep,vectors.factorspace);
    if IsProjectiveRep(SubmoduleRep(rep,sub))=false then
        Error("The routine tried to factor out a non-projective module. It only works for p-groups.");
    fi;
    return( QuotientRep( rep, sub ) );
end );

##############################################################################
##
## ProjectiveFreeSummand(rep) returns a summand of rep which is probably 
## projective free.  The complementary summand is guaranteed to be 
## projective, so the returned rep is stably isomorphic to the original rep.
##
##############################################################################

InstallGlobalFunction( ProjectiveFreeSummand, function(rep)
    local comps, comp, pfbasis;
    comps:=Decompose(rep);
    pfbasis:=[];
    for comp in comps do
        if not IsProjectiveRep(SubmoduleRep(rep, comp)) then
            Append(pfbasis, comp);
        fi;
    od;
    return SubmoduleRep(rep, pfbasis);
end );

##########################################################
##
## FixedPointRep(representation, subgroup of rep.group) returns the 
## representation of the normalizer of the subgroup on the fixed points
## of the subgroup.  Written by Peter Webb June 2016.
##
##########################################################

InstallGlobalFunction( FixedPointRep, function(rep,gp)
   local n, resn, resgp;
   n:=Normalizer(rep.group,gp);
   resn:=RestrictedRep(rep.group,n,rep);
   resgp:=RestrictedRep(rep.group,gp,rep);
   return(SubmoduleRep(resn,FixedPoints@(resgp)));
end );

##########################################################
##
## BrauerRep(representation, p-subgroup of rep.group) returns the 
## representation of the normalizer of the subgroup on the fixed points
## of the subgroup modulo the image of traces from proper subgroups of 
## the p-group.  Written by Peter Webb June 2016.
##
##########################################################

InstallGlobalFunction( BrauerRep, function(rep,p)
    local n, resn, resp, fp, fprep, maxsub, traceimages, h, M, resh, v, b;
    n:=Normalizer(rep.group,p);
    resn:=RestrictedRep(rep.group,n,rep);
    resp:=RestrictedRep(rep.group,p,rep);
    fp:=FixedPoints@(resp);
    fprep:=SubmoduleRep(resn,fp);
    maxsub:=MaximalSubgroups(p);
    traceimages:=[];
    for h in maxsub do
        M:=RelativeTrace(p,h,resp);
        resh:=RestrictedRep(resp.group,h,resp);
        Append(traceimages,SafeMatrixMult(FixedPoints@(resh),M,rep.dimension));
    od;
    traceimages:=SafeBaseMat(traceimages);
    v:=VectorSpace(rep.field,fp);
    b:=Basis(v,fp);
    traceimages:=List(traceimages,x->Coefficients(b, x));
    return QuotientRep(fprep, traceimages);
end );

##############################################################################
##
## RemoveFromBottom(rep1, rep2) takes representations rep1 and rep2.
## It returns a representation with all images of rep2 removed from the bottom
## of rep1.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################

InstallGlobalFunction( RemoveFromBottom, function(rep1,rep2)
    local newrep;
    newrep := QuotientRep( rep1, SumOfImages( rep2, rep1 ) );
    return newrep;
end );
    
##############################################################################
##
## RemoveFromTop(rep1,rep2) returns the representation that is the common kernel
## of all homomorphisms from rep1 to rep2.
##
## Written by Peter Webb Spring 2020 
##
##############################################################################

InstallGlobalFunction( RemoveFromTop, function( rep1, rep2 )
    local  newrep;
    newrep := SubmoduleRep( rep1, KernelIntersection( rep1, rep2 ) );
    return newrep;
end );