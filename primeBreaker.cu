#include "primeBreaker.hpp"


/**	\brief Je suis une fonction d'évaluation de la primalité d'un nombre premier.
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
		while (offset != 0) {
			if (tid < offset) {
				cache[tid] = umin ( cache[tid], cache[tid+offset] );
			}
			__syncthreads();
			offset /= 2;
		}
		
		if (tid == 0) {
			res_operations[bid] = cache[0]; 
		}
		
		gid += gridDim.x * blockDim.x;	
	}

	
	if (initial_gid < ((sqrtN+blockDim.x-1)/blockDim.x))
		res_operations[0] = ((res_operations[0] != 0) && (res_operations[initial_gid] != 0));

}

/*	/brief	Je suis une fonction qui récupère les nombres premiers inférieur à une borne renseignée
		à paramètre.
  
 */
__global__ void searchPrimeGPU(
		uint64_t *possibles_premiers,
		uint64_t *square_roots,
		uint64_t borne_sup,
		uint64_t *premiers)
{
	int gid = threadIdx.x + blockIdx.x * blockDim.x;
	while (gid < borne_sup-2) {
		if (gid == 0) {
			premiers[gid] = 1;
		} else {
			int res_operations_size = ((square_roots[gid]+blockDim.x-1)/blockDim.x)+1;
			unsigned int *res_operations = (unsigned int*)malloc(sizeof(unsigned int)*res_operations_size);
			isPrime<<<gridDim.x,blockDim.x,blockDim.x*sizeof(unsigned int)>>>
				(possibles_premiers,
			 	res_operations,
			 	possibles_premiers[gid],
			 	square_roots[gid]
			 	);
			cudaDeviceSynchronize();
		
			premiers[gid] = res_operations[0];	
			free(res_operations);
		}
		gid += gridDim.x * blockDim.x;
	}
	
}


/** \brief
    je suis la fonction qui permet de decomposeur un numero en facteurs premiers
*/
__global__ 
void factGPU(
		uint64_t  N,
		uint64_t *const dev_primes,
		cell *const dev_facteurs,
               int const taille,
               uint64_t *val
)
{

	int gid = threadIdx.x+blockIdx.x*blockDim.x;
        while(gid < taille)
       {

        	if(N%dev_primes[gid]==0)
                {
                      
			dev_facteurs[gid].expo+=1;
                        val[0]=N/dev_primes[gid];
		 }
		
            gid+=blockDim.x*gridDim.x;
        }


  


}
