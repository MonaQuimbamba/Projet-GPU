#include "primeBreaker.hpp"

//__device__   int global_var;

/** \brief
      je suis la fonction qui verifie la primalité d'un numero ,
      exemple d'éxecution : chaque thread verifie un numero inférieu à N peut diviser N
      si oui on ajout 0 dans le tableu de la memoire partage sinon on ajoute 1 , et au final on fait
      une reduction pour verifier si y'a des 0 dans la memoire partagée et on retourne un tableu de la taille
      d'un block avec que des 0 et 1 et dans CPU on verifie si ya des 0 c-à-d qu'il n'est pas premier sinon oui
*/
__global__ void isPrimeGPU(uint64_t *const dev_N, unsigned int  *const isPrime, uint64_t const N, size_t const taille)
{
      int global_t_id = threadIdx.x +  blockIdx.x*blockDim.x;
      int t_id = threadIdx.x;
      extern __shared__ unsigned int cache[];
      cache[t_id]= 1;
      while( global_t_id < taille)
      {
          if((N%dev_N[global_t_id])==0 )
            cache[t_id]= 0;
          global_t_id+=blockDim.x * gridDim.x;
      }
      __syncthreads();
      unsigned int i = blockDim.x/2;
      while(i!=0)
      {
      		 if(t_id < i)
      		 {
      			 cache[t_id]=umin( cache[t_id], cache[t_id + i] );
      		 }
      		 __syncthreads();
      		 i/=2;
      }
      if(threadIdx.x==0)  isPrime[blockIdx.x] = cache[0];


}


__global__ void searchPrimeGPU(uint64_t *const dev_N,uint64_t  *const primesNumbers,uint64_t const N, int const taille)
{
      int global_t_id = threadIdx.x + blockIdx.x*blockDim.x;

      while(global_t_id < taille)
      {

            //launchKernelIsPrimeGPU<0>(dev_N[global_t_id],isPrime);
            if(N%dev_N[global_t_id]==0)
            {
                /*  unsigned int isPrime=1;
                    for (uint64_t val = dev_N[global_t_id] ;val >= 2; val-=1)
                    {
                        if (dev_N[global_t_id]%val== 0)
                        {isPrime=0;}
                    }
                    if(isPrime==1)*/
                      primesNumbers[global_t_id]=dev_N[global_t_id];
            }


            global_t_id+=blockDim.x*gridDim.x;
      }

}
