#include "primeBreaker.hpp"


/** \brief
    je suis la fonction qui permet de decomposeur un numero en facteurs premiers
*/
__global__ void facGPU(uint64_t const N,uint64_t *const dev_primes,cell *const dev_facteurs)
{
      int gid = threadIdx.x +  blockIdx.x*blockDim.x;

      while( gid < N)
      {
            if(N%dev_primes[gid]==0)
            {
                  facteurs[gid]->expo+=1;
            }

            gid+=blockDim.x * gridDim.x;
      }


}
