import numpy as np
import scipy.sparse as sp

import pylis
pylis.initialize("-omp_num_threads 1")

N = 20
R = np.ones((20,),dtype=np.double)
x = np.zeros((20,),dtype=np.double)
K = sp.eye(N).tocsr()

print x
pylis.solve(K,x,R)
print x

pylis.finalize()
