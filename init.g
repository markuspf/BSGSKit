#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# Reading the declaration part of the package.
#
_PATH_SO:=Filename(DirectoriesPackagePrograms("BSGSKit"), "BSGSKit.so");
if _PATH_SO <> fail then
    LoadDynamicModule(_PATH_SO);
fi;
Unbind(_PATH_SO);


ReadPackage( "BSGSKit", "gap/Random.gd");
ReadPackage( "BSGSKit", "gap/SchreierTree.gd");
ReadPackage( "BSGSKit", "gap/StabChain.gd");
ReadPackage( "BSGSKit", "gap/BSGSKit.gd");
