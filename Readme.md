# pyLis

Alejandro F Queiruga

July 2016


A simple wrapper for Lis, [http://www.ssisc.org/lis/] ,
[https://github.com/anishida/lis/]
It takes in numpy arrays and scipy matrices, puts them into Lis data structures, uses Lis to solve the system, and returns the result in the numpy array. I have no intention in making this run with MPI for now, but Lis will spawn multiple threads.

## Installation

Lis needs to be installed first. The wrappers then needs to be compiled using SWIG using CMakeLists.txt.

## License

Copyright 2016 Alejandro Queiruga

This library is released under version 3 of the GNU Lesser General Public License, as per LICENSE.txt.
