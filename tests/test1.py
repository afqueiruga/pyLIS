import numpy as np
import scipy.sparse as sp

import pylis
pylis.wr.pylis_initialize(["-omp_num_threads","1"])

N = 20
R = np.ones((20,),dtype=np.double)
x = np.ones((20,),dtype=np.double)
K = sp.eye(N).tocsr()

# pylis.wr.pylis_finalize()
