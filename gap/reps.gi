

CatRepOps:=rec();



#***************************************************************************
#                       Catreps
#           Copyright (C) 2008 Peter Webb
#       Copyright (C) 2011 Peter Webb, Fan Zhang
#       Copyright (C) 2020 Moriah Elkin
#
#  Distributed under the terms of the GNU General Public License (GPL)
#                  http://www.gnu.org/licenses/
#
#  The overall structure of the catreps package was designed and most if it
#  written by Peter Webb <webb@math.umn.edu>, who is also the maintainer. 
#  Contributions were made by Dan Christensen,
#  Fan Zhang and Moriah Elkin.
#***************************************************************************


##############################################################################
##
## SupportOfMorphism(m) returns the list of positions at which the 
## list m is defined.
##
##############################################################################
SupportOfMorphism:=function(m)
    local s, i;
    s:=[];
    for i in [1..Length(m)] do
        if IsBound(m[i]) then Add(s,i);
        fi;
    od;
    return(s);
end;

##############################################################################
##
## IdentityMorphism(l) returns the identity morphism on the set l.
## A morphism is stored as a list of the images of its values on a set
## of numbers, which form its domain of definition, and are taken to be
## an object in a concrete category. At elements of other objects the
## morphism will be undefined.
##
##############################################################################
IdentityMorphism:=function(l)
    local m, i;
    m:=[];
    for i in l do
        m[i]:=i;
    od;
    return(m);
end;

##############################################################################
##
## Composition(f,g) returns the composition of the functions f and g, expressed
## as lists of their values.
##
##############################################################################
Composition:=function(f,g)
    local i, h;
    h:=[];
    for i in [1..Length(f)] do
        if IsBound(f[i]) then
            if IsBound(g[f[i]]) then
                h[i]:=g[f[i]];
            else return(false);
            fi;
        fi;
    od;
    return(h);
end;

##############################################################################
##
## IsComposable(f,g) returns true if the functions f and g, expressed
## as lists of their values, can be composed and false otherwise.
##
##############################################################################
IsComposable:=function(f,g)
    local i;
    for i in [1..Length(f)] do
        if IsBound(f[i]) then
            if not IsBound(g[f[i]]) then return(false);
            fi;
        fi;
    od;
    return(true);
end;

##############################################################################
##
## Objects(cat) returns the objects of the concrete category cat, as a list
## of sets. At the moment it will not work unless for every object there
## is at least one generator morphism whose support is that object.
##
##############################################################################
Objects:=function(cat)
    local m;
    if IsBound(cat.objects) then return(cat.objects);
    fi;
    cat.objects:=[];
    for m in cat.generators do
        Add(cat.objects,SupportOfMorphism(m));
    od;
    cat.objects:=SSortedList(cat.objects);
    return(cat.objects);
end;

##############################################################################
##
## Origin(cat,m) returns the position in cat.objects of the domain of the
## morphism m.
##
##############################################################################
Origin:=function(cat,m)
    local k, x;
    k:=PositionBound(m);
    for x in [1..Length(cat.objects)] do
         if k in cat.objects[x] then
              return(x);
         fi;
    od;
end;

##############################################################################
##
## Terminus(cat,m) returns the position in cat.objects of the domain of the
## morphism m.
##
##############################################################################
Terminus:=function(cat,m)
    local k, x;
    k:=m[PositionBound(m)];
    for x in [1..Length(cat.objects)] do
         if k in cat.objects[x] then
              return(x);
         fi;
    od;
end;



Domains:=function(C)
Objects(C);
C.domain:=List(C.generators,x->Origin(C,x));
C.codomain:=List(C.generators,x->Terminus(C,x));
end;

##############################################################################

ConcreteCategoryOps:=rec();

##############################################################################
##
## ConcreteCategory(list of functions, (list of sets))
## There are optionally one or two arguments. The first is a list of generating
## functions of the category, the second is a list of the objects of the category.
## The function starts a record for a concrete category.
## If there is only one argument, the objects are taken to be the domains of the
## generator morphisms, so for every object there should be
## at least one generator morphism whose support is that object.
## It could be the identity morphisms, but doesn't have to be.
##
## Written by Peter Webb 2008, Moriah Elkin 2018.
##
##############################################################################

ConcreteCategory:=function(arg)
    local output, domains, codomains, x, m, cod, dom, included, obj, nums;
    output:=rec(generators:=arg[1], operations:=ConcreteCategoryOps);
    if Length(arg)=2 then
        #Checks if object sets overlap or entries repeated (catches ([1,2],[2,3,4]) or ([1,2,2]))
        nums:=[];
        for x in arg[2] do
            for m in x do
                if not (m in nums) then
                    Add(nums,m);
                else
                    Error("One or more entries is duplicated within one or more objects.");
                fi;
            od;
        od;

        #Computes domains/codomains of morphisms
        domains:=[];
        for m in arg[1] do
            Add(domains,SupportOfMorphism(m));
        od;
        domains:=SSortedList(domains);
        codomains:=[];
        for x in domains do
            for m in output.generators do
                if SupportOfMorphism(m)=x then
                    Add(codomains, List(x,a->m[a]));
                fi;
            od;
        od;
        codomains:=SSortedList(codomains);
        
        #Ensures domains/codomains of morphisms in provided objects list
        for dom in domains do
            included:=false;
            for obj in arg[2] do
                if IsSubset(obj,dom) then
                    included:=true;
                    break;
                fi;
            od;
            if included=false then
                Error("One or more morphisms have domains not included in objects list.");
            fi;
        od;
        for cod in codomains do
            included:=false;
            for obj in arg[2] do
                if IsSubset(obj,cod) then
                    included:=true;
                    break;
                fi;
            od;
            if included=false then
                Error("One or more morphisms have codomains not included in objects list.");
            fi;
        od;

        output.objects:=SSortedList(arg[2]);
    
    elif Length(arg)=1 then
        Objects(output);
    fi;

    Domains(output);
    return(output);
end;

##############################################################################
##
## EmptyMat(r,s) returns an r x s matrix in which each entry is [].
##
##############################################################################
EmptyMat:=function(r,s)
    local mat, i, j;
    mat:=[];
    for i in [1..r] do
    mat[i]:=[];
        for j in [1..s] do
            mat[i][j]:=[];
        od;
    od;
    return(mat);
end;

##############################################################################
##
## Morphisms(cat) returns an l x l matrix, where l is the number of objects
## in the category cat, and where the i,j entry is a list of the
## morphisms from object i to
## object j.
##
##############################################################################
Morphisms:=function(cat)
    local n, genmat, g, mormat, oldlength, newlength, i, j, k, h, templist;
    if IsBound(cat.morphisms) then return(cat.morphisms);
    fi;
    if not IsBound(cat.objects) then Objects(cat);
    fi;
    n:=Length(cat.objects);
    genmat:=EmptyMat(n,n);
    mormat:=EmptyMat(n,n);
    for g in cat.generators do
        Add(genmat[Origin(cat,g)][Terminus(cat,g)],g);
    od;
    for i in [1..n] do
        Add(mormat[i][i],IdentityMorphism(cat.objects[i]));
    od;
    oldlength:=0;
    newlength:=Sum(List(mormat,x->Sum(List(x,Length))));
    while oldlength < newlength do
        oldlength:=newlength;
        for i in [1..n] do
            for j in [1..n] do
                templist:=[];
                for k in [1..n] do
                    for g in genmat[k][j] do
                        for h in mormat[i][k] do
                            Add(templist, Composition(h,g));
                        od;
                    od;
                 od;
                 Append(mormat[i][j],templist);
                 mormat[i][j]:=SSortedList(mormat[i][j]);
            od;
        od;
        newlength:=Sum(List(mormat,x->Sum(List(x,Length))));
    od;
    cat.morphisms:=mormat;
    return(mormat);
end;



##############################################################################
##
## CatRep(category, matrices, field)
## This function creates a representation of a category where the generators 
## are represented by the matrices in the list.
##
##############################################################################

CatRep:=function(C,L,F)
    local dimvec, i;
    dimvec:=List(Objects(C),x->0);
    for i in [1..Length(C.generators)] do
        if IsBound(L[i]) then
            dimvec[C.domain[i]]:=Length(L[i]);
        fi;
    od;
    return rec(
     category:=C,
     genimages:=L,
     field:=F,
     dimension:=dimvec,
     operations:=CatRepOps
     );
end; 


##############################################################################
##
## YonedaRep(category, object number, field)
## This returns the representation of the category on the subspace of the
## category algebra spanned by the morphisms whose domain is the specified
## object. The representation is projective, by Yoneda's lemma.
##
##############################################################################

YonedaRep:=function(cat,object,F)
    local genmatrices, mor, dimvec, i, j, k, f, matrix;
    genmatrices:=[];
    mor:=Morphisms(cat);
    dimvec:=List(mor[object],Length);
    for i in [1..Length(cat.generators)] do
        if dimvec[cat.domain[i]]>0 then
            matrix:=List([1..dimvec[cat.domain[i]]],x->List([1..dimvec[cat.codomain[i]]],y->Zero(F)));
            for j in [1..Length(mor[object][cat.domain[i]])] do
                f:=Composition(mor[object][cat.domain[i]][j],cat.generators[i]);
                k:=Position(mor[object][cat.codomain[i]],f);
                matrix[j][k]:=One(F);
            od;
            genmatrices[i]:=matrix;
        else genmatrices[i]:=[];
        fi;
    od;
    return rec(
     category:=cat,
     genimages:=genmatrices,
     field:=F,
     dimension:=dimvec,
     operations:=CatRepOps
     );
end; 

##############################################################################
##
## YonedaDualRep(category, object number, field)
## This returns the representation of the category on the dual of the subspace of the
## category algebra spanned by the morphisms whose codomain is the specified
## object. The representation is injective, because its dual is projective, by Yoneda's lemma.
##
##############################################################################

YonedaDualRep:=function(cat,object,F)
    local genmatrices, mor, dimvec, i, j, k, f, matrix;
    genmatrices:=[];
    mor:=Morphisms(cat);
    dimvec:=List(mor, x->Length(x[object]));
    for i in [1..Length(cat.generators)] do
        if dimvec[cat.domain[i]]>0 then
            matrix:=List([1..dimvec[cat.domain[i]]],x->List([1..dimvec[cat.codomain[i]]],y->Zero(F)));
            for j in [1..dimvec[cat.codomain[i]]] do
                f:=Composition(cat.generators[i],mor[cat.codomain[i]][object][j]);
                k:=Position(mor[cat.domain[i]][object],f);
                matrix[k][j]:=One(F);
            od;
            genmatrices[i]:=matrix;
        else genmatrices[i]:=[];
        fi;
    od;
    return rec(
     category:=cat,
     genimages:=genmatrices,
     field:=F,
     dimension:=dimvec,
     operations:=CatRepOps
     );
end;

#############################################################################
##
## ZeroCatRep(cat,field) returns the zero representation of the category.
##
#############################################################################

ZeroCatRep:=function(cat,F)
    local dimvec;
    dimvec:=List(Objects(cat),x->0);
    return rec(
     category:=cat,
     genimages:=List(cat.generators,x->[]),
     field:=F,
     dimension:=dimvec,
     operations:=CatRepOps
     );
end;

#############################################################################
##
## ConstantRep(cat,field) returns the constant (or trivial) representation of the category.
##
#############################################################################

ConstantRep:=function(cat,F)
    local dimvec;
    dimvec:=List(Objects(cat),x->1);
    return rec(
     category:=cat,
     genimages:=List(cat.generators,x->[[One(F)]]),
     field:=F,
     dimension:=dimvec,
     operations:=CatRepOps
     );
end; 


##############################################################################
##
## TensorProductMatrix(mat,mat) . . . Tensor product of two matrices
##
## The GAP command KroneckerProduct seems inexplicably slow and in tests on
## two 60 x 60 matrices takes about twice as long as the following code.
##
##############################################################################

TensorProductMatrix:=function(A,B)
    local u, v, matrix;
    matrix:=[];
    for u in A do
        for v in B do
            Add(matrix,Flat(List(u,x->x*v)));
        od;
    od;
    return(matrix);
end;

##############################################################################
##
## TensorProductCatRep(rep,rep) . . . Kronecker product of two representations
## Called by TensorProductRep(rep,rep) if rep is a category representation
##
##############################################################################

TensorProductCatRep:=function(g,h)
    local mgens, i;
    mgens:=[];
    for i in [1..Length(g.genimages)] do
    if IsBound(g.genimages[i]) and IsBound(h.genimages[i]) then
    mgens[i]:=TensorProductMatrix(g.genimages[i],h.genimages[i]);
    fi;
    od;
    return CatRep(g.category,mgens, g.field);
end;

##############################################################################
##
## ExtractHom(vec, dimension vector 1, dimension vector 2)
## takes a vector and returns it repackaged as a list of dimvec1[i] by dimvec2[i] matrices.
##
##############################################################################


ExtractHom:=function(vec,dimvec1,dimvec2)
    local n, hom, l, i, j, mat;
    n:=0;
    hom:=[];
    for l in [1..Length(dimvec1)] do
        mat:=[];
        for i in [1..dimvec1[l]] do
            mat[i]:=[];
            for j in [1..dimvec2[l]] do
                n:=n+1;
                mat[i][j]:=vec[n];
            od;
        od;
        Add(hom,mat);
    od;
    return(hom);
end;

##############################################################################
##
## HomBasis(M, N) returns a basis for the space of 
## kC-module homomorphisms M -> N. Each element of the output list is a
## list of matrices, which the ith matrix is a map M[i] -> N[i].
##
## The algorithm used finds homomorphisms X so that Xg-gX=0 for all category generators
## g. The code is an elaboration by Peter Webb (October 2008) of code written 
## for group representations
## by Dan Christensen in August 2007.
##
## CatHomBasis is called by HomBasis(M, N) when M is a
## category representation.
##
##############################################################################

CatHomBasis:=function(M,N)
    local dimM, dimN, dM, dN, dMN, dimsumM, dimsumN, dimsumMN, r, s, i, j, k, l, v, f, domain, codomain;
#    dimM := M.dimension;
#    dimN := N.dimension;
dimsumM:=[];
dimsumM[1]:=0;
dimsumN:=[];
dimsumN[1]:=0;
dimsumMN:=[];
dimsumMN[1]:=0;
domain:=M.category.domain;
codomain:=M.category.codomain;
    r := Length(M.genimages);
    dM:=0;
    dN:=0;
    dMN:=0;
    for i in [1..Length(M.dimension)] do
    dM:=dM+M.dimension[i];
    dN:=dN+N.dimension[i];
    dMN:=dMN+M.dimension[i]*N.dimension[i];
    Add(dimsumM,dM);
    Add(dimsumN,dN);
    Add(dimsumMN,dMN);
    od;
    dimM:=dimsumM[Length(M.dimension)+1];
    dimN:=dimsumN[Length(M.dimension)+1];
    v:=NullMat(dimsumMN[Length(M.dimension)+1], dimM*dimN*r, M.field);
    for l in [1..r] do
        for s in [1..N.dimension[codomain[l]]] do
            for j in [1..N.dimension[domain[l]]] do
                for i in [1..M.dimension[domain[l]]] do
                    v[dimsumMN[domain[l]]+(i-1)*N.dimension[domain[l]]+j]
                    [(l-1)*dimM*dimN+dimsumM[domain[l]]*dimN+M.dimension[domain[l]]*dimsumN[codomain[l]]+(i-1)*N.dimension[codomain[l]]+s]
                    :=v[dimsumMN[domain[l]]+(i-1)*N.dimension[domain[l]]+j]
                    [(l-1)*dimM*dimN+dimsumM[domain[l]]*dimN+M.dimension[domain[l]]*dimsumN[codomain[l]]+(i-1)*N.dimension[codomain[l]]+s]
                    - N.genimages[l][j][s];
                od;
            od;
        od;
        for r in [1..M.dimension[domain[l]]] do
            for j in [1..N.dimension[codomain[l]]] do
                for i in [1..M.dimension[codomain[l]]] do
                    v[dimsumMN[codomain[l]]+(i-1)*N.dimension[codomain[l]]+j]
                    [(l-1)*dimM*dimN+dimsumM[domain[l]]*dimN+M.dimension[domain[l]]*dimsumN[codomain[l]]+(r-1)*N.dimension[codomain[l]]+j]
                    :=v[dimsumMN[codomain[l]]+(i-1)*N.dimension[codomain[l]]+j]
                    [(l-1)*dimM*dimN+dimsumM[domain[l]]*dimN+M.dimension[domain[l]]*dimsumN[codomain[l]]+(r-1)*N.dimension[codomain[l]]+j]
                    + M.genimages[l][r][i];
                od;
            od;
        od;
    od;
    f := SafeNullspaceMat(v, M.field);
    return(List(f,x->ExtractHom(x,M.dimension,N.dimension)));
end;

##############################################################################
##
## SumOfImages(rep,rep) . . returns a list of bases which give the sum of images of all 
## module homomorphisms A -> B. Term i in the list is a basis for the subspace of the 
## value of representation B at object i which is part of the sum of images.
##
## CatSumOfImages is called by SumOfImages(rep,rep) when rep is a
## category representation.
##
##############################################################################

CatSumOfImages:=function(M,N)
    local  homs, basis, l, h;
    homs:=HomBasis(M,N);
    basis:=[];
    for l in [1..Length(M.dimension)] do
        basis[l]:=[];
        for h in homs do
            Append(basis[l],h[l]);
        od;
        if not(basis[l]=[]) then
            basis[l]:=List(SafeBaseMat(basis[l]),x->x);
        fi;
    od;
    return(basis);
end;

#############################################################################
##
## SubmoduleRep(rep, list of lists of vecs) . .  returns the representation which gives
## the action on the submodule spanned at each object by the corresponding
## list of vectors. Each list of vectors must be a basis. This is not checked.
##
## SubmoduleCatRep is called by SubmoduleRep(rep, list of lists of vecs) when rep is a
## category representation.
##
#############################################################################

SubmoduleCatRep:=function(rep,v)
    local dimvec, vs, base, i, newimages, mat, domain, codomain;
    domain:=rep.category.domain;
    codomain:=rep.category.codomain;
    dimvec:=List(v,Length);
    vs:=[];
    base:=[];
    for i in [1..Length(v)] do
        if not(v[i]=[]) then
            vs[i]:=VectorSpace(rep.field,v[i]);
            base[i]:=Basis(vs[i],v[i]);
        fi;
    od;
    newimages:=[];
    for i in [1..Length(rep.genimages)] do
        mat:=List(v[domain[i]],x->[]);
        if not(v[codomain[i]]=[] or v[domain[i]]=[]) then
            mat:=List(base[domain[i]], 
            b->Coefficients(base[codomain[i]], b*rep.genimages[i]));
        fi;
        Add(newimages, mat);
    od;
    return rec(
        category:=rep.category,
        genimages:=newimages,
        field:=rep.field,
        dimension:=dimvec,
        isRepresentation:=true,
        operations:=CatRepOps
        );
end;

#############################################################################
##
## QuotientRep(rep, basis structure) . . . returns the representation giving the
## action on the quotient by an invariant subspace.
##
## At the moment this does not work if the basis structure is for the zero subspace.
##
## QuotientCatRep is called by QuotientRep(rep, basis structure) when rep is a
## category representation.
##
#############################################################################

QuotientCatRep:=function(rep,v)
    local basestructure, d, zero,onemat,i,j,positions,b,p,g,
        mat,newb,newimages,baseinverse;
    if Length(v)=0 then
        return rep;
    fi;
    basestructure:=List(v,x->ShallowCopy(SafeBaseMat(x)));
    for g in basestructure do
        TriangulizeMat(g);
    od;
    d:=List(basestructure,Length);
    if d=rep.dimension then
        return ZeroCatRep(rep.category,rep.field);
    fi;
    zero:=Zero(rep.field);
    positions:=[];
    baseinverse:=[];
    for j in [1..Length(rep.dimension)] do
        onemat:=IdentityMat(rep.dimension[j],rep.field);
        i:=1;
        positions[j]:=[];
        for b in basestructure[j] do
            while b[i]=zero do
                Add(positions[j],i);
                i:=i+1;
            od;
            i:=i+1;
        od;
        Append(positions[j],[i..rep.dimension[j]]);
        for p in positions[j] do
            Add(basestructure[j], onemat[p]);
        od;
        if basestructure[j]=[] then
            baseinverse[j]:=[];
        else
            baseinverse[j]:=basestructure[j]^-1;
        fi;
    od;
    newimages:=[];
    for g in [1..Length(rep.genimages)] do
        mat:=[];
        for p in positions[rep.category.domain[g]] do
            if baseinverse[rep.category.codomain[g]] <> [] then
                b:=rep.genimages[g][p]*baseinverse[rep.category.codomain[g]];
            fi;
            newb:=[];
            for i in [d[rep.category.codomain[g]]+1..rep.dimension[rep.category.codomain[g]]] do
                Add(newb,b[i]);
            od;
            Add(mat,newb);
        od;
        Add(newimages, mat);
    od;
    return rec(
        category:=rep.category,
        genimages:=newimages,
        field:=rep.field,
        dimension:=rep.dimension-d,
        isRepresentation:=true,
        operations:=CatRepOps
        );
end;


##############################################################################
##
## DecomposeSubmodule(repn, basis structure) . . probably returns a list of two basis 
## structures for summands of the submodule of repn spanned by 
## the given basis structure, if the module is decomposable, and
## if the module is indecomposable it returns a list whose only element is the
## given basis.
##
## CatDecomposeSubmodule is called by DecomposeSubmodule(repn, basis structure) when repn is a
## category representation.
##
## This code was developed by Peter Webb from code for group representations
## written by Bryan Simpkins and Robert Hank, University of
## Minnesota, April 2006, related to an approach taken by Michael Smith in
## code written in 1993, and tidied up by Dan Christensen, University of Western Ontario, Aug 2007.
##
##############################################################################


CatDecomposeSubmodule:= function(M,basisstructure)
	local newrep, c, d, initlist, b, x, a, n, z, kernel, kdim, image ;
	newrep := SubmoduleRep(M, basisstructure);
	d:=Maximum(newrep.dimension);
	initlist := HomBasis(newrep,newrep);
	Add(initlist, List(initlist[1], u->u*0));
	b := Length(initlist);
	while b > 0 do;
		c := b - 1;
		while c > 0 do;
	        a:=initlist[b]+initlist[c];
			n:=1;
			while n < d do
				for z in [1..Length(a)] do
		    		if not(a[z]=[]) then
		        		a[z]:=a[z]*a[z];
		    		fi;
				od;
				n:=2*n;
			od;
			kernel:=List(a,u->SafeNullspaceMat(u,M.field));
		 	kdim:=Sum(List(kernel,Length));
			if not(kdim=0 or kdim=Sum(newrep.dimension)) then
				image:=List(a,SafeBaseMat);
				for z in [1..Length(a)] do
				    if image[z] <> [] then
				        image[z]:=image[z]*basisstructure[z];
				    fi;
				    if kernel[z]<>[] then
				        kernel[z]:=kernel[z]*basisstructure[z];
				    fi;
				od;
				return [kernel,image];
			fi;
	   		c := c - 1;
		od;
		b := b - 1;
	od;
	return [basisstructure];
end;
	
	
##############################################################################
##
## Decompose(rep) . . returns a list of basis structures of direct summands of rep which
## are probably indecomposable.
##
## DecomposeCatRep is called by Decompose(rep) when rep is a category representation.
##
## This code was developed by Peter Webb from code for group representations
## written by Bryan Simpkins and Robert Hank, University of
## Minnesota, April 2006, related to an approach taken by Michael Smith in
## code written in 1993, and tidied up by Dan Christensen, University of Western Ontario, Aug 2007.
##
##############################################################################

DecomposeCatRep:=function(rep)
	local summands, result, q;
	if IsBound(rep.summands) then return(rep.summands);
	fi;
	summands := [List(rep.dimension, x->SafeIdentityMat(x,rep.field))];
	q := 1;
	# We maintain the following invariants:
	# - summands is a list of basis structures; the 'union' of these
	#   lists forms a basis structure for rep.
        # - the summands at positions < q appear to be indecomposable;
	#   those at positions >= q haven't been investigated completely.
	while IsBound(summands[q]) do;
		result := DecomposeSubmodule(rep, summands[q]);
		if Length(result) = 2 then
			summands[q] := result[1];
			Add(summands, result[2]);
		else
			q := q + 1;
		fi;
	od;
	rep.summands:=summands;
	return summands;
end;

##############################################################################
##
## Spin(rep, list of lists of vectors)
## returns a basis for the subrepresentation generated by the vectors in the lists.
## There is one entry in the list (of lists of vectors) for each object in the category,
## and it is a list of vectors which all belong to the representation space at that object.
##
## CatSpin is called by Spin(rep, list of lists of vectors) when rep is a
## category representation.
##
## This is code which was developed from code written by
## Fan Zhang (University of Minnesota), March 2011.
##
##############################################################################


CatSpin:=function(rep,veclistlist)
local basis, olddim, dim, newlist, g, n, v;
basis:=List(veclistlist,SafeBaseMat);
dim:=Sum(List(basis,Length));
olddim:=dim-1;
while dim>olddim do
    olddim:=dim;
    newlist:=List(basis,x->List(x,y->y));
    for n in [1..Length(rep.genimages)] do
        g:=rep.genimages[n];
        for v in basis[rep.category.domain[n]] do
            Add(newlist[rep.category.codomain[n]],v*g);
        od;
    od;
    basis:=List(newlist,SafeBaseMat);
    dim:=Sum(List(basis,Length));
od;
return basis;
end;

##############################################################################
##
## OrthogonalComplement(list of vectors, dim, field)
## returns a basis for the orthgonal complement of the space spanned by the
## list of vectors, in a space of dimension dim (put there in case the list
## of vectors is empty).
##
##############################################################################

OrthogonalComplement:=function(veclist,n,field)
if veclist=[] then
    return(IdentityMat(n,field));
else return NullspaceMat(TransposedMat(veclist));
fi;
end;


##############################################################################
##
## CoSpin(rep, list of lists of vectors)
## returns a basis for the largest subrepresentation contained in the
## subspaces spanned by the vectors in the lists.
## There is one entry in the list (of lists of vectors) for each object in the category,
## and it is a list of vectors which all belong to the representation space at that object.
##
## CatCoSpin is called by CoSpin(rep, list of lists of vectors) when rep is a
## category representation.
##
##############################################################################

CatCoSpin:=function(rep,veclistlist)
local basis, olddim, dim, newlist, g, n, v, output, i, transposedimages;
transposedimages:=List(rep.genimages,TransposedMat);
basis:=[];
for i in [1..Length(rep.dimension)] do
    basis[i]:=OrthogonalComplement(veclistlist[i],rep.dimension[i],rep.field);
od;
dim:=Sum(List(basis,Length));
olddim:=dim-1;
while dim>olddim do
    olddim:=dim;
    newlist:=List(basis,x->List(x,y->y));
    for n in [1..Length(rep.genimages)] do
        g:=transposedimages[n];
        for v in basis[rep.category.codomain[n]] do
            Add(newlist[rep.category.domain[n]],v*g);
        od;
    od;
    basis:=List(newlist,SafeBaseMat);
    dim:=Sum(List(basis,Length));
od;
output:=[];
for i in [1..Length(rep.dimension)] do
    output[i]:=OrthogonalComplement(basis[i],rep.dimension[i],rep.field);
od;
return output;
end;

##############################################################################
##
## EndomorphismGroup(cat, obj) returns the group of the endomorphisms of obj in
## cat, in permutation form. It assumes every endomorphism is invertible and that the generators of the 
## endomorphism group appear among the generators of the category.
##
## Written by Moriah Elkin July 2018.
##
##############################################################################

EndomorphismGroup:=function(cat,obj)
    local i, g, generators, permutations;
    permutations:=[];
    generators:=StructuralCopy(cat.generators);
    for g in generators do
        if Origin(cat,g)=obj and Terminus(cat,g)=obj then
            #add identity
            i:=1;
            for i in [1..Length(g)] do
                if not IsBound(g[i]) then
                    g[i]:=i;
                fi;
                i:=i+1;
            od;
            #convert to permutation and add to list
            Add(permutations,PermList(g));
        fi;
    od;
    if Length(permutations)>0 then
        return Group(permutations);
    fi;
    return Group([],());
end;
    
##############################################################################
##
## EndomorphismGroups(cat) returns a list containing the endomorphism group for
## each object in the category cat.
##
## Written by Moriah Elkin July 2018.
##
##############################################################################
    
EndomorphismGroups:=function(cat)
    cat.endomorphismgroups:=List(cat.objects,x->EndomorphismGroup(cat,x));
end;


    
##############################################################################
##
## FI(n) and FI2(n) interchangeably return a record for the category FI with
## objects 0...n. O is represented by the first object ( [1] ), and its morphisms
## correspond to the first element in every object, which is otherwise ignored
## (first elements only map to first elements). The category FI is the category of finite sets with
## injective maps that has featured in the theory of representation stability.
##
## Written by Moriah Elkin July 2018.
##
##############################################################################

FI:=function(n)
    local objectlist, morphismlist, i, j, x, m;
    morphismlist:=[];
    
    objectlist:=[];
    j:=0;
    for i in [1..n+1] do
        Add(objectlist, [j+1..j+i]);
        j:=j+i;
    od;
    
    for x in objectlist do
        if Length(x)<=n then
            m:=[];
            for i in x do
                m[i]:=i+Length(x);
            od;
            Add(morphismlist,m);
        fi;
        
        if Length(x)>=3 then
            m:=[];
            for i in x do
                m[i]:=i;
            od;
            m[x[2]]:=x[2]+1;
            m[x[3]]:=x[3]-1;
            Add(morphismlist,m);
        fi;
        
        if Length(x)>=4 then
            m:=[];
            m[x[1]]:=x[1];
            m[x[Length(x)]]:=x[2];
            for i in [x[2]..x[Length(x)-1]] do
                m[i]:=i+1;
            od;
            Add(morphismlist,m);
        fi;
    od;
    
    return ConcreteCategory(morphismlist, objectlist);
end;

FI2:=function(n)
    local objectlist, morphismlist, i, j, k, m;
    morphismlist:=[];
    objectlist:=[];
    j:=0;
    for i in [1..n+1] do
        Add(objectlist, [j+1..j+i]);
        
        if i<=n then
            m:=[];
            for k in [j+1..j+i] do
                m[k]:=k+i;
            od;
            Add(morphismlist,m);
        fi;
        
        if i>=3 then
            m:=[];
            for k in [j+1..j+i] do
                m[k]:=k;
            od;
            m[j+2]:=j+3;
            m[j+3]:=j+2;
            Add(morphismlist,m);
        fi;
        
        if i>=4 then
            m:=[];
            m[j+1]:=j+1;
            m[j+i]:=j+2;
            for k in [j+2..j+i-1] do
                m[k]:=k+1;
            od;
            Add(morphismlist,m);
        fi;
        j:=j+i;
    od;
    
    return ConcreteCategory(morphismlist, objectlist);
end;

##############################################################################
##
## DirectSumCatRep(rep1, rep2) returns the representation that is the direct
## sum of the representations rep1 and rep2 of the category rep1.category.
##
## Written by Moriah Elkin July 2018.
##
## DirectSumCatRep is called by DirectSumRep(rep1,rep2) when rep1 and rep2 are
## group representations.
##
##############################################################################

DirectSumCatRep:=function(rep1,rep2)
    local i, row, col, newmat, gimages, dDim1, dDim2, cDim1, cDim2, cat;
    if rep1.field<>rep2.field or rep1.category<>rep2.category then
        Error("Representations incompatible.");
    fi;
    cat:=rep1.category;
    gimages:=[];
    for i in [1..Length(cat.generators)] do
        dDim1:=rep1.dimension[cat.domain[i]];
        dDim2:=rep2.dimension[cat.domain[i]];
        cDim1:=rep1.dimension[cat.codomain[i]];
        cDim2:=rep2.dimension[cat.codomain[i]];
        newmat:=EmptyMat(dDim1+dDim2,cDim1+cDim2);
        if newmat<>[] and newmat[1]<>[] then
            for row in [1..Length(newmat)] do
                for col in [1..Length(newmat[1])] do
                    if row in [1..dDim1] and col in [1..cDim1] then
                        newmat[row][col]:=rep1.genimages[i][row][col];
                    elif row in [dDim1+1..dDim1+dDim2] and col in [cDim1+1..cDim1+cDim2] then
                        newmat[row][col]:=rep2.genimages[i][row-dDim1][col-cDim1];
                    else
                        newmat[row][col]:=Zero(rep1.field);
                    fi;
                od;
            od;
        fi;
        Add(gimages,newmat);
    od;
    return rec(category:=cat,genimages:=gimages,field:=rep1.field,dimension:=rep1.dimension+rep2.dimension, operations:=CatRepOps);
end;

##############################################################################
##
## GeneratorDomains(cat) returns a l x l matrix, where l is the number of objects
## in the category cat, and where the i,j entry is a list of the indices of morphisms
## from object i to object j.
##
## Written by Moriah Elkin August 2018.
##
##############################################################################

GeneratorDomains:=function(cat)
    local M, i;
    if IsBound(cat.generatordomains) then
        return cat.generatordomains;
    fi;
    M:=EmptyMat(Length(cat.objects),Length(cat.objects));
    for i in [1..Length(cat.generators)] do
        Add(M[cat.domain[i]][cat.codomain[i]],i);
    od;
    cat.generatordomains:=M;
    return M;
end;

##############################################################################
##
## MorphismsRep(rep) returns a l x l matrix, where l is the number of objects
## in the category of rep, and where the i,j entry is a list of the matrices of
## morphisms from object i to object j.
##
## Written by Moriah Elkin (August 2018), based on code for categories written
## by Peter Webb.
##
##############################################################################

MorphismsRep:=function(rep)
    local cat, n, genmat, g, mormat, oldlength, newlength, i, j, k, h, templist;
    cat:=rep.category;
    if IsBound(rep.morphimgs) then return(rep.morphimgs);
    fi;
    if not IsBound(cat.objects) then Objects(cat);
    fi;
    n:=Length(cat.objects);
    genmat:=EmptyMat(n,n);
    mormat:=EmptyMat(n,n);
    for g in [1..Length(rep.genimages)] do
        Add(genmat[Origin(cat,cat.generators[g])][Terminus(cat,cat.generators[g])],rep.genimages[g]);
    od;
    for i in [1..n] do
        Add(mormat[i][i],SafeIdentityMat(rep.dimension[i],rep.field));
    od;
    oldlength:=0;
    newlength:=Sum(List(mormat,x->Sum(List(x,Length))));
    while oldlength < newlength do
        oldlength:=newlength;
        for i in [1..n] do
            for j in [1..n] do
                templist:=[];
                for k in [1..n] do
                    for g in genmat[k][j] do
                        for h in mormat[i][k] do
                            if h<>[] and g<>[] then
                                Add(templist, h*g);
                            fi;
                        od;
                    od;
                 od;
                 Append(mormat[i][j],templist);
                 mormat[i][j]:=SSortedList(mormat[i][j]);
            od;
        od;
        newlength:=Sum(List(mormat,x->Sum(List(x,Length))));
    od;
    rep.morphimgs:=mormat;
    return(mormat);
end;

##############################################################################
##
## SubConstant(rep) returns a list of bases for the largest subconstant
## representation of rep. The algorithm finds the common kernel of all differences
## of morphisms from a domain to all codomains.
##
## Written by Moriah Elkin August 2018.
##
##############################################################################

SubConstant:=function(rep)
    local morphisms, vecListList, obj1, obj2, m, m1, m2, perpMat, perpSum, vec;
    morphisms:=MorphismsRep(rep);
    vecListList:=[];
    if Length(morphisms)>0 then
        for obj1 in [1..Length(morphisms)] do
            perpSum:=[];

            for obj2 in [1..Length(morphisms)] do
                perpMat:=[];

                if obj1<>obj2 and Length(morphisms[obj1][obj2])>1 then
                    for m1 in morphisms[obj1][obj2] do
                        for m2 in morphisms[obj1][obj2] do
                            if m1<>m2 then
                                for vec in TransposedMat(m1-m2) do
                                    Add(perpMat,vec);
                                od;
                            fi;
                        od;
                    od;
                    Append(perpSum, SafeBaseMat(perpMat));

                elif obj1=obj2 then
                    for m in morphisms[obj1][obj1] do
                        if rep.dimension[obj1]<>0 then
                            for vec in TransposedMat(m-SafeIdentityMat(rep.dimension[obj1],rep.field)) do
                                Add(perpMat,vec);
                            od;
                        fi;
                    od;
                    Append(perpSum, SafeBaseMat(perpMat));
                fi;
            od;
            
            if perpSum<>[] then
            vecListList[obj1]:=SafeNullspaceMat(TransposedMat(perpSum),rep.field);
            else vecListList[obj1]:=SafeIdentityMat(rep.dimension[obj1],rep.field);
            fi;
        od;
    fi;

    return(vecListList);
end;

##############################################################################
##
## Evaluation(rep, obj) returns the representation of the endomorphism
## group of object obj on the value of the representation rep at obj. (In FI, obj is
## not the mathematical object in FI, but rather the object number in the category).
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
Evaluation:=function(rep, obj)
    local g, genMats;
    genMats:=[];
    for g in [1..Length(rep.genimages)] do
        if Origin(rep.category,rep.category.generators[g])=obj and Terminus(rep.category,rep.category.generators[g])=obj then
            Add(genMats, rep.genimages[g]);
        fi;
    od;
    return Rep(EndomorphismGroup(rep.category,obj),genMats,rep.field);
end;


##############################################################################
##
## SpinFixedPts(rep, obj) returns a list of lists of bases (lists of vectors),
## where list of bases i is the spin of the fixed points of the group representation
## that is the i'th summand of the evaluation of rep at object obj; item i in the list
## is an empty list when there are no generators or no fixed points in that summand of
## the evaluation.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
SpinFixedPts:=function(rep,obj)
    local pt, e, replist, toSpin, i, output, bases;
    output:=[];
    e:=Evaluation(rep,obj);
    bases:=Decompose(e);
    replist:=List(bases,x->SubmoduleRep(e,x));
    for i in [1..Length(replist)] do
        if IsEmpty(Flat(replist[i].genimages)) then
            output[i]:=[];
        else
            pt:=FixedPoints@(replist[i]);
            if pt=[] then
                output[i]:=[];
            else
                toSpin:=EmptyMat(1,Length(rep.dimension))[1];
                toSpin[obj]:=pt*bases[i];
                output[i]:=Spin(rep,toSpin);
            fi;
        fi;
    od;
    return output;
end;


##############################################################################
##
## SpinBasisVec(rep, obj) goes through each summand in the evaluation of rep at obj,
## takes the first vector in its basis, and returns a basis for the subfunctor generated
## by this vector (an empty list if the basis is empty). It returns a list of lists of
## bases, where the i'th list of bases corresponds to the i'th summand of the evaluation.
## It does not check that the summand does not have fixed points.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
SpinBasisVec:=function(rep,obj)
    local v, e, basislist, i, toSpin, output;
    output:=[];
    e:=Evaluation(rep,obj);
    basislist:=Decompose(e);
    for i in [1..Length(basislist)] do
        if IsZero(basislist) then
            output[i]:=[];
        else
            v:=basislist[i][1];
            toSpin:=EmptyMat(1,Length(rep.dimension))[1];
            toSpin[obj]:=[v];
            output[i]:=Spin(rep,toSpin);
        fi;
    od;
    return output;
end;

##############################################################################
##
## IsDirectSum(summands,sum) takes in a list of bases (lists of vectors), summands, and a
## basis (list of vectors), sum, and returns true if the direct sum of summands is sum. 
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
IsDirectSum:=function(summands,sum)
    local i, summandMat, bigMat;
    summandMat:=[];
    for i in [1..Length(summands)] do
        Append(summandMat,summands[i]);
    od;
    bigMat:=Concatenation(summandMat,sum);
    return RankMat(bigMat)=RankMat(summandMat) and RankMat(summandMat)=Length(summandMat) and RankMat(sum)=Length(sum) and Length(summandMat)=Length(sum);
end;

##############################################################################
##
## TestOneFixedPt(rep) tests whether there is at most one fixed point in the summands
## of the evaluations of rep at each object. It returns true if there is, false if
## there is not.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
TestOneFixedPt:=function(rep)
    local i, j, e, replist;
    for i in [1..Length(rep.dimension)] do
        e:=Evaluation(rep,i);
        replist:=List(Decompose(e),x->SubmoduleRep(e,x));
        for j in [1..Length(replist)] do
            if not IsEmpty(Flat(replist[j].genimages)) and Length(FixedPoints@(replist[j]))>1 then
                return false;
            fi;
        od;
    od;
    return true;
end;


##############################################################################
##
## DisplayButterflyDims(sn,subGens) takes in the symmetric group of a certain dimension
## and the generators for a subgroup corresponding to a partition. It displays the
## ButterflyFactors matrix (without decomposing), and returns the ButterflyFactors.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
DisplayButterflyDims:=function(sn,subGens)
    local m, b;
    m:=PermutationRepOnCosets(sn,Subgroup(sn,subGens),GF(2));
    b:=ButterflyFactors(m,SocleSeries(m)[1],RadicalSeries(m)[1]);
    DisplayMatrix(List(b,x->List(x,y->y.dimension)));
    return b;
end;

##############################################################################
##
## ButterflyDimsRep(rep) takes in a representation, displays the ButterflyFactors matrix
## (without decomposing), and returns the ButterflyFactors.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
ButterflyDimsRep:=function(rep)
    local b;
    b:=ButterflyFactors(rep,SocleSeries(rep)[1],RadicalSeries(rep)[1]);
    DisplayMatrix(List(b,x->List(x,y->y.dimension)));
    return b;
end;

##############################################################################
##
## npButterflyDimsRep(rep) takes in a representation and returns the ButterflyFactors
## (without printing anything).
##
## Written by Moriah Elkin Spring 2020.
##
##############################################################################
npButterflyDimsRep:=function(rep)
    return ButterflyFactors(rep,SocleSeries(rep)[1],RadicalSeries(rep)[1]);
end;

##############################################################################
##
## SafeFixedPoints(rep) finds the fixed points of a representation rep; if rep
## has dimension 0, it returns an empty list.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
SafeFixedPoints:=function(rep)
    if rep.dimension=0 then
        return [];
    else
        return FixedPoints@(rep);
    fi;
end;

##############################################################################
##
## SafeDimHom(rep) returns the dimension of the space of module homomorphisms
## rep1 -> rep2. If rep has dimension 0, it returns 0.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
SafeDimHom:=function(d,rep)
    if rep.dimension=0 then
        return 0;
    else
        return DimHom(d,rep);
    fi;
end;

##############################################################################
##
## ExamineButterflyFactors(b,dRec) takes in a ButterflyFactors matrix and a record of
## possible factors. It displays the original dimension matrix, and then an ordered list of
## matrices, where the dimensions in each matrix correspond to the dimensions of the
## homomorphisms between that element in the ButterflyFactors matrix and the factor in the
## list, or the number of fixed points in that element in the ButterflyFactors matrix.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
ExamineButterflyFactors:=function(b,dRec)
    local name;
    Print("Original matrix:\n");
    DisplayMatrix(List(b,x->List(x,y->y.dimension)));
    Print("\n\nFixed points:\n");
    DisplayMatrix(List(b,x->List(x,y->Length(SafeFixedPoints(y)))));
    Print("\n\nFactors:\n");
    for name in RecNames(dRec) do
        Print(name);
        Print("\n");
        DisplayMatrix(List(b,x->List(x,y->SafeDimHom(dRec.(name),y))));
        Print("\n");
    od;
end;



##############################################################################
##
## FISummandEvalReps(n,obj) returns a list of the representations of the summands of the
## evaluations of the summands of the Yoneda representation over GF(2) of FI(n) at the
## mathematical object obj. There will be 3 levels of lists: the overall list will contain
## a list for each submodule of the Yoneda representation, each of which will contain a list
## of submodule representations for each object at which it has been evaluated.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
FISummandEvalReps:=function(n,obj)
    local catreplist, yr, i, e, j, output;
    output:=[];
    yr:=YonedaRep(FI(n),obj+1,GF(2));
    catreplist:=List(Decompose(yr),x-> SubmoduleRep(yr,x));
    for i in [1..Length(catreplist)] do
        output[i]:=[];
        for j in [1..n+1] do
            e:=Evaluation(catreplist[i],j);
            output[i][j]:=List(Decompose(e),x-> SubmoduleRep(e,x));
        od;
    od;
    return output;
end;

##############################################################################
##
## ProjSummands(n,obj) returns whether the summands in FISummandEvalReps(n,obj,GF(2))
## are projective: each column of the output is the evaluation at a different mathematical
## object, each row is a different summand of the YonedaRep of FI(n) at obj, and each
## element in the matrix is a list with whether the summands of the evaluation are
## projective, in order. Representations with no generators display "fail."
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
ProjSummands:=function(n, obj)
    local summands, output, i, j, k;
    summands:=FISummandEvalReps(n,obj,GF(2));
    output:=[];
    for i in [1..Length(summands)] do
        output[i]:=[];
        for j in [1..Length(summands[i])] do
            output[i][j]:=[];
            for k in [1..Length(summands[i][j])] do
                if IsEmpty(Flat(summands[i][j][k].genimages)) then
                    output[i][j][k]:=fail;
                else
                    output[i][j][k]:=IsProjectiveRep(summands[i][j][k]);
                fi;
            od;
        od;
    od;
    return output;
end;

##############################################################################
##
## DimSummands(n,obj) returns the dimensions of the summands in
## FISummandEvalReps(n,obj,GF(2)): each column of the output is the evaluation at a
## different mathematical object, each row is a different summand of the YonedaRep of FI(n)
## at obj, and each element in the matrix is a list with the dimensions of the summands of 
## the evaluation in order.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
DimSummands:=function(n, obj)
    local summands, output, i, j, k;
    summands:=FISummandEvalReps(n,obj,GF(2));
    output:=[];
    for i in [1..Length(summands)] do
        output[i]:=[];
        for j in [1..Length(summands[i])] do
            output[i][j]:=[];
            for k in [1..Length(summands[i][j])] do
                output[i][j][k]:=summands[i][j][k].dimension;
            od;
        od;
    od;
    return output;
end;


##############################################################################
##
## FixedPtDims(n) returns a list of lists of lists of dimensions. The outer list contains a
## list for SpinFixedPts of the Yoneda Rep of FI(n) at mathematical object 2, at each object
## in FI(n); and each of those lists contains the dimensions of the corresponding list of
## bases at each object (an empty list if that summand has no fixed points).
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
FixedPtDims:=function(n)
    local yr, i, j, bases, output;
    output:=[];
    if n>1 then
        yr:=YonedaRep(FI(n),3,GF(2));
        for i in [1..n+1] do
            bases:=SpinFixedPts(yr,i);
            output[i]:=[];
            for j in [1..Length(bases)] do
                if bases[j]=[] then
                    output[i][j]:=[];
                else
                    output[i][j]:=List(bases[j],Length);
                fi;
            od;
        od;
    fi;
    return output;
end;

##############################################################################
##
## FixedPtBases(n) returns a list of lists of bases. The outer list contains a list for
## SpinFixedPts of the Yoneda Rep of FI(n) at mathematical object 2, at each object in
## FI(n); and each of those lists contains the corresponding list of bases at each object
## (taken at the summand that has fixed points).
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
FixedPtBases:=function(n)
    local yr, i, j, bases, output;
    output:=[];
    if n>1 then
        yr:=YonedaRep(FI(n),3,GF(2));
        for i in [1..n+1] do
            bases:=SpinFixedPts(yr,i);
            output[i]:=[];
            for j in [1..Length(bases)] do
                if not bases[j]=[] then
                    output[i]:=bases[j];
                    break;
                fi;
            od;
        od;
    fi;
    return output;
end;

##############################################################################
##
## BasisVecDims(n) returns a list of lists of lists of dimensions. The outer list contains a
## list for SpinBasisVec of the Yoneda Rep of FI(n) at mathematical object 2, at each object
## in FI(n); and each of those lists contains the dimensions of the corresponding list of
## bases at each object (where dimension list i contains the dimensions of
## SpinBasisVec(rep,i)) (an empty list if that summand's basis is empty). I.e.,
## BasisVecDims[i][j] contains the lengths of the bases generated by spinning the first
## vector in the basis for the jth summand of the evaluation of the Yoneda rep at object i.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
BasisVecDims:=function(n)
    local yr, i, j, bases, output;
    output:=[];
    if n>1 then
        yr:=YonedaRep(FI(n),3,GF(2));
        for i in [1..n+1] do
            bases:=SpinBasisVec(yr,i);
            output[i]:=[];
            for j in [1..Length(bases)] do
                output[i][j]:=List(bases[j],Length);
            od;
        od;
    fi;
    return output;
end;

##############################################################################
##
## BasisVecBases(n) returns a list of lists of lists of bases. The outer list contains a 
## list for SpinBasisVec of the Yoneda Rep of FI(n) at mathematical object 2, at each object
## in FI(n); and each of those lists contains the corresponding list of bases at each object
## (where list i contains SpinBasisVec(rep,i)) (an empty list if that summand's basis is
## empty). I.e., BasisVecBases[i][j] contains the list of bases generated by spinning the
## first vector in the basis for the jth summand of the evaluation of the Yoneda rep at
## object i.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
BasisVecBases:=function(n)
    local yr, i, j, bases, output;
    output:=[];
    if n>1 then
        yr:=YonedaRep(FI(n),3,GF(2));
        for i in [1..n+1] do
            output[i]:=SpinBasisVec(yr,i);
        od;
    fi;
    return output;
end;

##############################################################################
##
## TestYRSummand(basis,eval,summandi) takes in a basis, an evaluation of a Yoneda Rep over
## GF(2), and the index of the summand of that evaluation that the basis is thought to be
## equivalent to; it returns whether it is in fact equivalent.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
TestYRSummand:=function(basis,eval,summandi)
    local summands;
    summands:=Decompose(eval);
    summands[summandi]:=basis;
    return IsDirectSum(summands,BasisVectors(Basis(GF(2)^Length(basis[1]))));
end;

##############################################################################
##
## AllSpinDims(n, evalObj,outputRec) spins all vectors in the evaluation at math object
## evalObj of the Yoneda representation of FI(n) at math object 2 with respect to that
## Yoneda representation. If outputRec is false, returns a sorted list of the dimensions of
## the bases; if it is true, returns a record with each dimension list corresponding to the 
## list of vectors that generated it.
##
## Written by Moriah Elkin Spring 2019.
##
##############################################################################
AllSpinDims:=function(n,evalObj,outputRec)
    local yr, dim, i, v, output, spunDims, toSpin;
    yr:=YonedaRep(FI(n),3,GF(2));
    dim:=Evaluation(yr,evalObj+1).dimension;
    if outputRec then
        output:=rec();
        for v in GF(2)^dim do
            toSpin:=EmptyMat(1,n+1)[1];
            toSpin[evalObj+1]:=[v];
            spunDims:=String(List(Spin(yr,toSpin),Length));
            if IsBound(output.(spunDims)) then
                Append(output.(spunDims),[v]);
            else
                output.(spunDims):=[v];
            fi;
        od;
        return output;
    else
        output:=[];
        i:=0;
        for v in GF(2)^dim do
            i:=i+1;
            toSpin:=EmptyMat(1,n+1)[1];
            toSpin[evalObj+1]:=[v];
            output[i]:=List(Spin(yr,toSpin),Length);
        od;
        return SSortedList(output);
    fi;
end;

CatRepOps:=rec(Decompose:=DecomposeCatRep,
                            SubmoduleRep:=SubmoduleCatRep,
                            QuotientRep:=QuotientCatRep,
                            Spin:=CatSpin,
                            CoSpin:=CatCoSpin,
                            HomBasis:=CatHomBasis,
                            DecomposeSubmodule:=CatDecomposeSubmodule,
                            SumOfImages:=CatSumOfImages,
                            TensorProductRep:=TensorProductCatRep,
                            DirectSumRep:=DirectSumCatRep
                            );
