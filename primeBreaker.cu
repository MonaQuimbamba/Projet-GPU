#include "primeBreaker.hpp"



__device__ uint64_t atomicExch_d(uint64_t* address, uint64_t val)
{
  uint64_t old = *address;

 do{
    *address = val;

  }while (old==val);

  return old;
}

/** \brief
    je suis la fonction qui permet de decomposeur un numero en facteurs premiers
*/
__global__ void facGPU(uint64_t  N,uint64_t *const dev_primes,cell *const dev_facteurs)
{
      int gid = threadIdx.x +  blockIdx.x*blockDim.x;

      while( gid < N)
      {
            if(N%dev_primes[gid]==0)
            {
              //__threadfence_system();
                  dev_facteurs[gid].expo+=1;
                  //N=N/dev_primes[gid];
                  atomicExch_d(&N,N/dev_primes[gid]);
            }

            gid+=blockDim.x * gridDim.x;
      }


}
