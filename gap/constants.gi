# ***************************************************************************
#                                   Reps
#       Copyright (C) 2005 Peter Webb 
#       Copyright (C) 2006 Peter Webb, Robert Hank, Bryan Simpkins 
#       Copyright (C) 2007 Peter Webb, Dan Christensen, Brad Froehle
#       Copyright (C) 2020 Peter Webb, Moriah Elkin
#       Copyright (C) 2022 Ferreira Juan David
#
#  Distributed under the terms of the GNU General Public License (GPL)
#                  http://www.gnu.org/licenses/
#
#  The overall structure of the reps package was designed and most of it
#  written by Peter Webb <webb@math.umn.edu>, who is also the maintainer. 
#  Contributions were made by
#  Dan Christensen, Roland Loetscher, Robert Hank, Bryan Simpkins,
#  Brad Froehle and others.
# ***************************************************************************
#
# Reps: The GAP package for handling representations
#       of groups and categories in positive characteristic.

GroupRepOps:=rec();

##############################################################################
##
## FixedPoints. . . . . produce a basis for the fixed points of a module
##
## Improvement by Dan Christensen of code originally by Peter Webb.
##
##############################################################################

FixedPoints@:=function(rep)
    local v, one, i, j;
	if IsBound(rep.fixedPoints) then
		return rep.fixedPoints;
	fi;
    if IsTrivial(rep.group) then
        return(IdentityMat(rep.dimension,rep.field));
    fi;
    v:=[];
    one:=One(rep.field);
    for i in [1..rep.dimension] do 
        v[i] := Concatenation(List(rep.genimages, m->m[i]));
        for j in [0..Length(rep.genimages)-1] do 
            v[i][i+rep.dimension*j] := v[i][i+rep.dimension*j] - one;
        od;
    od;
    v:=NullspaceMat(v);
    rep.fixedPoints:=v;
    return(v);
end;

