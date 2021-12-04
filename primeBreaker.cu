#include "primeBreaker.hpp"



__device__ void lock(int *mutex) {while (atomicCAS(mutex, 0, 1) != 0);}
__device__ void unlock(int *mutex) {	atomicExch(mutex, 0); }



/** \brief
    je suis la fonction qui permet de decomposeur un numero en facteurs premiers
*/
__global__ void facGPU(uint64_t  N,uint64_t *const dev_primes,cell *const dev_facteurs,int *mutex)
{
      int gid = threadIdx.x +  blockIdx.x*blockDim.x;

      while(gid<N)
      {

              while (N!=1)
              {
                      if(dev_primes[gid]!=0)
                      {
                          printf(" N= [%lld] val[%lld] \n",N,dev_primes[gid]);
                          if(N%dev_primes[gid]==0)
                          {
                                dev_facteurs[gid].expo+=1;
                              //  bool leave = true;
                                //while (leave)
                                {
                                  if (atomicCAS(mutex, 0, 1) == 0)
                                  {
                                    N=N/dev_primes[gid];
                                    //leave = false;
                                    atomicExch(mutex, 0);
                                  }
                                  //break;
                                }
                                //lock(mutex);

                                //unlock(mutex);
                           }
                      }
                }

            gid+=blockDim.x * gridDim.x;

          }





}
