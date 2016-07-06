%module lis_wrapper
%{
#define SWIG_FILE_WITH_INIT
#include "lis.h"
%}

%include "numpy.i"
%init %{
  import_array();
  //import_managed();
%}

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
  void pylis_initailize(int argc, char *argv[]) {
    lis_initialize(&argc,&argv);
  }
  void pylis_finalize() { // Just for naming
    lis_finalize();
  }
  void pylis_solve_csr_mat(/* The matrix in CSR format */
			   int Nptr,LIS_INT * ptr, int Nindex,LIS_INT * index,
			   int Nvalue,LIS_SCALAR * value, 
			   /* x. Initial condition and output */
			   int Nx, LIS_SCALAR * x,
			   /* R */
			   int NR, LIS_SCALAR * R) {
    LIS_MATRIX K;
    LIS_VECTOR x, R;

    int N=Nptr, nnz=Nindex;
    lis_matrix_create(0, &K);
    lis_matrix_set_size(K, N,0);
    lis_matrix_set_csr(nnz,ptr,index,value, K);
    lis_matrix_assemble(A);
  }
%}
