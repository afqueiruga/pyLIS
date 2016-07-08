import lis_wrapper as wr

def initialize(args):
    wr.pylis_initialize(args.split())
def finalize(): # Just for consistancy
    wr.pylis_finalize()

def solve(K,x,R):
    indices = K.indices
    indptr = K.indptr
    values = K.data

    wr.pylis_solve_csr_mat(indptr, indices, values,
                           x,
                           R)
