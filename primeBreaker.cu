#include "primeBreaker.hpp"


/** \brief
      je suis la focntion qui verifie la primalité d'un numero ,
      exemple d'éxecution : chaque thread verifie un numero inférieu à N peut diviser N
      si oui on ajout 0 dans le tableu de la memoire partage sinon on ajoute 1 , et au final on fait
      une reduction pour verifier si y'a des 0 dans la memoire partagée et on retourne un tableu de la taille
      d'un block avec que des 0 et 1 et dans CPU on verifie si ya des 0 c-à-d qu'il n'est pas premier sinon oui
*/
__global__ void isPrimeGPU(uint64_t *const dev_tab_possibles_diviseurs,unsigned int  *const dev_resOperations, uint64_t const N,size_t const taille)
{
      int gid = threadIdx.x +  blockIdx.x*blockDim.x;
      int tid = threadIdx.x;
      extern __shared__ unsigned int cache[];
      cache[tid]= 1;
      while( gid < taille)
      {

          if((N%dev_tab_possibles_diviseurs[gid])==0 )
            cache[tid]= 0;
          gid+=blockDim.x * gridDim.x;
      }

      // une reduction sur le cache pour trouver  le mimimun du cache 
      __syncthreads();
      unsigned int i = blockDim.x/2;
      	while(i!=0)
      	{
      		 if(tid < i)
      		 {
      			 cache[tid]=umin( cache[tid], cache[tid + i] );
      		 }
      		 __syncthreads();
      		 i/=2;
      	}
       if(threadIdx.x==0)  dev_resOperations[blockIdx.x] = cache[0];

     // une reduction final, sur le tableau des operations
       __syncthreads();
       unsigned int j = blockDim.x/2;
        while(i!=0)
        {
           if(tid < j)
           {   dev_resOperations[tid]=umin( dev_resOperations[tid], dev_resOperations[tid + j] );}
           __syncthreads();
           j/=2;
        }

}
