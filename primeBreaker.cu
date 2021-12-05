#include "primeBreaker.hpp"


/**	\brief Je suis une fonction d'évaluation partielle de la primalité d'un nombre premier.
  */
__global__
void isPrime(
		uint64_t *possibles_premiers,
		unsigned int *res_operations,
		uint64_t N,
		uint64_t sqrtN
		){

	int gid = threadIdx.x + blockIdx.x * blockDim.x;
	int initial_gid = gid;
	int bid = blockIdx.x;
	int tid = threadIdx.x;
	extern __shared__ unsigned int cache[];

	cache[tid] = 1;
	while (gid < sqrtN){
		cache[tid] = (N%possibles_premiers[gid] != 0); // Si il n'y a pas de reste (le nombre est divisé entièrement par un autre nombre) j'inscrit zero dans le cache 

		__syncthreads();

		int offset = blockDim.x/2;
		while (offset > 1) {
			if (tid < offset) {
				cache[tid] = umin ( cache[tid], cache[tid+offset] );
			}
			__syncthreads();
			offset /=2;
		}
		
		if (tid == 0) { res_operations[bid] = cache[0]; }
		
		gid += gridDim.x * blockDim.x;	
	}

	if (initial_gid < gridDim.x)
		res_operations[0] = ((res_operations[0] != 0) && (res_operations[initial_gid] != 0));
}

/*
__global__ void searchPrimeGPU(
		uint64_t *const dev_possiblesPremiers,
		uint64_t  *const dev_primes,
		uint64_t const limit,
		int const taille
		)
{
    int gid = threadIdx.x + blockIdx.x*blockDim.x;

    while(gid < taille)
    {

        //isPrimeGPU(dev_tab_possibles_diviseurs,dev_resOperations,N,taille);

      //  dev_primes[gid]=dev_resOperations[0];
        gid+=blockDim.x*gridDim.x;
    }

}
*/

/** \brief
    je suis la fonction qui permet de decomposeur un numero en facteurs premiers
*/
__global__ 
void facGPU(
		uint64_t  N,
		uint64_t *const dev_primes,
		cell *const dev_facteurs
)
{
}
