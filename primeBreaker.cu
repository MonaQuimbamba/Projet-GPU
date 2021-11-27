#include "primeBreaker.hpp"


__global__ void isPrimeGPU(uint64_t *const dev_N,unsigned int  *const isPrime, uint64_t const N)
{
       int global_t_id = threadIdx.x +  blockIdx.x*blockDim.x;
      int t_id = threadIdx.x;
      extern __shared__ unsigned int cache[];
      while( global_t_id < N)
      {
          	cache[t_id]=  (N%dev_N[global_t_id])==0 ? 0 : 1;
            //printf("%d le val , le cache val %d \n",dev_N[global_t_id],cache[t_id] );
            global_t_id+=blockDim.x * gridDim.x;
        }

      	__syncthreads();
      /*  if(threadIdx.x==0)
        {
          for(int i=0 ; i< blockDim.x;i++)
          {
            printf(" le cache %d , le idThreads %d \n",cache[i],i );
          }
        }*/
       unsigned int i = 1;
      	while ( i < blockDim.x )
      	{

            int id = 2 * i * t_id;
        		if ( id < blockDim.x )
        		{

                  printf(" le cache %d , le idThreads %d \n",cache[id],i );
                //if(id+i<N)
                {
                    //printf("%d ",cache[id] );
        			     cache[id] =umin( cache[id], cache[id + i] );
                }
        		}
        		__syncthreads();
        		i *= 2;



      	}
        /*unsigned int i = blockDim.x/2;
      	while(i!=0)
      	{
      		 if(t_id < i)
      		 {
      			 cache[t_id]=umin( cache[t_id], cache[t_id + i] );
      		 }
      		 __syncthreads();
      		 i/=2;
      	}*/
        if(threadIdx.x==0) {
          isPrime[blockIdx.x] = cache[0];
          //printf("%d ",isPrime[blockIdx.x] );
        }

}
