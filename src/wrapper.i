%module lis_wrapper
%{
#define SWIG_FILE_WITH_INIT
#include "lis.h"
#include "string.h"
%}

%include "numpy.i"
%init %{
  import_array();
  //import_managed();
%}
%apply (int DIM1, int* IN_ARRAY1) {
  (int Nptr,LIS_INT * ptr),
  (int Nindex,LIS_INT * index)
 };
%apply (int DIM1, double* IN_ARRAY1) {
  (int Nvalue,LIS_SCALAR * value),
    (int NR, LIS_SCALAR * Rin)
};
%apply (int DIM1, double* INPLACE_ARRAY1) {
  (int Nx,LIS_SCALAR * xin)
};

/* argv typemap from swig's documentation
   http://www.swig.org/Doc1.3/Python.html
*/
%typemap(in) (int argc, char **argv) {
  /* Check if is a list */
  if (PyList_Check($input)) {
    int i;
    $1 = PyList_Size($input);
    $2 = (char **) malloc(($1+1)*sizeof(char *));
    for (i = 0; i < $1; i++) {
      PyObject *o = PyList_GetItem($input,i);
      if (PyString_Check(o))
	$2[i] = PyString_AsString(PyList_GetItem($input,i));
      else {
	PyErr_SetString(PyExc_TypeError,"list must contain strings");
	free($2);
	return NULL;
      }
    }
    $2[i] = 0;
  } else {
    PyErr_SetString(PyExc_TypeError,"not a list");
    return NULL;
  }
}
%typemap(freearg) (int argc, char **argv) {
  free((char *) $2);
}
/* end citation */

%inline %{
  void pylis_initialize(int argc, char **argv) {
    printf("pylis got %d %s\n",argc,argv[0]);
    lis_initialize(&argc,&argv);
  }
  void pylis_finalize() { // Just for naming
    lis_finalize();
  }
  void pylis_solve_csr_mat(/* The matrix in CSR format */
			   int Nptr,LIS_INT * ptr, int Nindex,LIS_INT * index,
			   int Nvalue,LIS_SCALAR * value, 
			   /* x. Initial condition and output */
			   int Nx, LIS_SCALAR * xin,
			   /* R */
			   int NR, LIS_SCALAR * Rin) {
    LIS_MATRIX K;
    LIS_VECTOR x, R;
    LIS_SOLVER solver;
    
    int N=Nptr-1, nnz=Nindex;
    /* Copy the data because LIS likes to free it */
    LIS_INT *cptr, *cindex;
    LIS_SCALAR *cvalue; //, *cxin, *cRin;
#define dup(x,y,size) {\
      (x) = malloc( (size) );\
      memcpy( (x), (y), (size) );\
    }
    dup(cptr, ptr, Nptr*sizeof(LIS_INT));
    dup(cindex, index, nnz*sizeof(LIS_INT));
    dup(cvalue, value, nnz*sizeof(LIS_SCALAR));
    /* dup(cxin, xin, nnz*sizeof(LIS_SCALAR)); */
    /* dup(cRin, Rin, nnz*sizeof(LIS_SCALAR)); */
#undef dup

    // Set up 
    lis_matrix_create(0, &K);
    lis_matrix_set_size(K, N,0);
    lis_matrix_set_csr(nnz,cptr,cindex,cvalue, K);
    lis_matrix_assemble(K);

    //Set up vector objects
    lis_vector_create(0, &x);
    lis_vector_set_size(x, N,0);
    lis_vector_scatter(xin, x);
    lis_vector_create(0, &R);
    lis_vector_set_size(R, N,0);
    lis_vector_scatter(Rin, R);
    
    // Solve
    lis_solver_create(&solver);
    lis_solver_set_optionC(solver);
    lis_solve(K,R, x, solver);

    // Retrieve the result
    lis_vector_gather(x, xin);
    
    lis_matrix_destroy(K); 
    lis_vector_destroy(x);
    lis_vector_destroy(R);
    lis_solver_destroy(solver);
  }
%}
