pylis
=====

Alejandro F Queiruga

July 2016


A simple wrapper for Lis, http://www.ssisc.org/lis/.
It takes in numpy arrays and scipy matrices, puts them into Lis data structures, uses Lis to solve the system, and returns the result in the numpy array. I have no intention in making this run with MPI for now, but Lis will spawn multiple threads.
