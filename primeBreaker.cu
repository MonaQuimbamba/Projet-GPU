
#include "primeBreaker.hpp"
#include <bits/stdc++.h>

__global__ void isPrimeGPU(uint64_t *const dev_N,const uint64_t N,unsigned int  *const isPrime)
{
        int global_id = threadIdx.x +  blockIdx.x*blockDim.x;
      	int t_id = threadIdx.x;
      	extern __shared__ unsigned int cache[];
      	cache[t_id]= global_id < N ? (floor(N/dev_N[global_id]) == N/dev_N[global_id]) : 0; // ajouter 2 au cas où
      	__syncthreads();
      	unsigned int i = blockDim.x/2;
      	while(i!=0)
      	{
      		 if(t_id < i)
      		 {
      			  cache[t_id]=umax( cache[t_id], cache[t_id + i] );
      		 }
      		 __syncthreads();
      		 i/=2;
      	}

      	if(t_id==0) isPrime[blockIdx.x] = cache[0];
}
