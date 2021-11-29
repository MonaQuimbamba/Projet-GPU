#include "primeBreaker.hpp"


/** \brief
      je suis la focntion qui verifie la primalité d'un numero ,
      exemple d'éxecution : chaque thread verifie un numero inférieu à N peut diviser N
      si oui on ajout 0 dans le tableu de la memoire partage sinon on ajoute 1 , et au final on fait
      une reduction pour verifier si y'a des 0 dans la memoire partagée et on retourne un tableu de la taille
      d'un block avec que des 0 et 1 et dans CPU on verifie si ya des 0 c-à-d qu'il n'est pas premier sinon oui
*/
__global__ void isPrimeGPU_naif(uint64_t *const dev_N,unsigned int  *const isPrime, uint64_t const N)
{
      int global_t_id = threadIdx.x +  blockIdx.x*blockDim.x;

      while( global_t_id < N)
      {
            isPrime[global_t_id]=((N%dev_N[global_t_id])==0 ) ? 0 : 1;
            global_t_id+=blockDim.x * gridDim.x;
      }


}


/** \brief
    je suis la fonction qui permet de decomposeur un numero en facteurs premiers
*/
__global__ void facGPU(uint64_t *const dev_N,uint64_t  *const facteurs, uint64_t const N, unsigned int const taille)
{
      int global_t_id = threadIdx.x +  blockIdx.x*blockDim.x;

      while( global_t_id < taille)
      {
            facteurs[global_t_id]=((N%dev_N[global_t_id])==0 ) ? dev_N[global_t_id] : 1; // si c'est un facteur premier on l'ajoute dans le tableau sionon on ajoute 1 
            global_t_id+=blockDim.x * gridDim.x;
      }


}
