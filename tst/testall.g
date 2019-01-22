#
# BSGSKit: A collection of Base and Strong Generating Set Algorithms
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "BSGSKit" );

TestDirectory(DirectoriesPackageLibrary( "BSGSKit", "tst" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
