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
## Pretty print for matrices
##
##############################################################################

InstallGlobalFunction( DisplayMatrix, function (matrix)
    PrintArray (List (matrix, x -> List (x, Int)));
end );

##############################################################################
##
## PrintRep(rep) prints a representation nicely.
##
##############################################################################

InstallGlobalFunction( PrintRep, function ( rep )
    local g;
    if IsBound( rep.name )  then
        Print( rep.name );
    elif IsBound(rep.longprint) and rep.longprint then
        Print( "Representation( ", rep.group, ", ", rep.genimages, " )\n" );
    else
        Print( "Representation( ", rep.group, ", Images \n");
        for g in rep.genimages do
            DisplayMatrix(g);
        od;
        Print( " )\n" );
    fi;
end );