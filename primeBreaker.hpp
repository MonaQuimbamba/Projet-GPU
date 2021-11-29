#ifndef __PREMEBREAKER_HPP
#define __PREMEBREAKER_HPP

#include <stdint.h>
#include <iostream>
#include <cstdlib>
#include <cstdint>
#include "utils/common.hpp"
#include "utils/chronoCPU.hpp"
#include "utils/chronoGPU.hpp"
#include <bits/stdc++.h>
#include "Reference.hpp"


using namespace std;

/** /brief
   Cette fonction va  tester la primalité d’un nombre de
  - L’algorithme consiste à vérifier pour un nombre N, si tous les nombres inférieurs ne le divisent pas
*/
__global__ void isPrimeGPU_naif(uint64_t *const dev_N,unsigned int  *const isPrime, uint64_t const N);
// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelIsPrimeGPU(const uint64_t N,unsigned int &isPrime)
{
					 isPrime=1;
					// prepare data to send to GPU , soit N un numero on fait un tableau avec des numeros inférieurs à N
					// pour 0 et 1 on met 2 , exemple pour 10 on a [9,8,7,6,5,4,3,2,2,2]
					  uint64_t *dev_N;
						uint64_t  *tab;

						size_t taille = sqrt(N)+1;
						tab = (uint64_t*)malloc( N*sizeof(uint64_t) );
						for (uint64_t i= 0; i < N; i++)
						{
									if(i==0 || i==1)
									{
										tab[i]=2;
									}
									else{
										tab[i]=i;
									}

						}

						HANDLE_ERROR(cudaMalloc( (void**)&dev_N,  N*sizeof(uint64_t) ));
						HANDLE_ERROR(cudaMemcpy(dev_N,tab,N*sizeof(uint64_t), cudaMemcpyHostToDevice ));
						// Set grid and block dimensions
						unsigned int dimBlock;
						unsigned int dimGrid;

						// on va ajouter les versions ici
						switch ( numKernel )
						{
								case 0: // V0
									dimBlock = 256;
									dimGrid =(N+dimBlock-1)/dimBlock;
									break;
								default:
									break;
						}

						verifyDimGridBlock( dimGrid, dimBlock, N ); // Are you reasonable ?
						unsigned int *host_partialIsPrime;
						host_partialIsPrime = (unsigned int*)malloc( N*sizeof(unsigned int) );
						size_t sizeSMem			= dimBlock * sizeof(unsigned int);

						std::cout << "Computing on " << dimGrid << " block(s) and "
					  << dimBlock << " thread(s) - shared memory size = "
				   	<< sizeSMem << std::endl;
						// on rempli le tableau partial avec que des 1
						// (1) on suppose que par defaut n'importe quel N est premier
						for( unsigned int i =0; i < N ; i++)
						{	host_partialIsPrime[i]=1;}

						  unsigned int *dev_partialIsPrime;
							HANDLE_ERROR( cudaMalloc( (void**) &dev_partialIsPrime, N*sizeof(unsigned int) ) );
							HANDLE_ERROR( cudaMemcpy(dev_partialIsPrime,host_partialIsPrime,N*sizeof(unsigned int), cudaMemcpyHostToDevice ));

							ChronoGPU chrGPU;
							chrGPU.start();
							isPrimeGPU_naif<<<dimGrid, dimBlock,sizeSMem>>>(dev_N,dev_partialIsPrime,N);
							chrGPU.stop();
							HANDLE_ERROR( cudaMemcpy( host_partialIsPrime,dev_partialIsPrime,N*sizeof(unsigned int), cudaMemcpyDeviceToHost ) );
							// on verifie si (1) est vrai
							// verifier s'il y'a des zeros dans le tableau partial , si oui c'est pas premier
							bool isPrimeBool =true;
							for(int i =0; i < N && isPrimeBool ; i++)
							{
									if(host_partialIsPrime[i]==0) // si il y'a un Zero c-à-d que le numéro n'est pas premier
									{
												isPrime=0;
												isPrimeBool=false; // on arrête la boucle
									}
							}
							free(host_partialIsPrime);
						  cudaFree( dev_partialIsPrime );
							free(tab);
							cudaFree(dev_N);

	return chrGPU.elapsedTime();
}


__global__ void facGPU(uint64_t *const dev_N,uint64_t *const facteurs, uint64_t const N, unsigned int const taille);
template<int numKernel> __host__
float launchKernelFactGPU(const uint64_t N,vector<uint64_t> primesNumbers, vector<cell> *facteursPrimes)
{

					  uint64_t *dev_N;
						uint64_t  *tab;  // la liste des nombres premiers
						size_t taille = primesNumbers.size(); // la taille da la liste des nombres premiers
						std::cout << "/* voir  */"<< taille << '\n';
						tab = (uint64_t*)malloc( taille*sizeof(uint64_t) );
						for (uint64_t i= 0; i < taille; i++)
						{	tab[i]=primesNumbers.at(i);}

						HANDLE_ERROR(cudaMalloc( (void**)&dev_N, taille*sizeof(uint64_t) ));
						HANDLE_ERROR(cudaMemcpy(dev_N,tab,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));
						// Set grid and block dimensions
						unsigned int dimBlock;
						unsigned int dimGrid;

						// on va ajouter les versions ici
						switch ( numKernel )
						{
								case 0: // V0
									dimBlock = 256;
									dimGrid =(taille+dimBlock-1)/dimBlock;
									break;
								default:
									break;
						}

						verifyDimGridBlock( dimGrid, dimBlock, taille); // Are you reasonable ?
						uint64_t *host_FactPrime;
						host_FactPrime = (uint64_t*)malloc( taille*sizeof(uint64_t) );


						std::cout << "Computing on " << dimGrid << " block(s) and " << dimBlock  << std::endl;
						uint64_t *dev_FactPrime;
						HANDLE_ERROR( cudaMalloc( (void**) &dev_FactPrime, taille*sizeof(uint64_t) ) );
						HANDLE_ERROR( cudaMemcpy(dev_FactPrime,host_FactPrime,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));

							ChronoGPU chrGPU;
							chrGPU.start();
							facGPU<<<dimGrid, dimBlock>>>(dev_N,dev_FactPrime,N,taille);
							chrGPU.stop();
							HANDLE_ERROR( cudaMemcpy( host_FactPrime,dev_FactPrime,taille*sizeof(uint64_t), cudaMemcpyDeviceToHost ) );

							// ajouter les facteurs premiers dans un vector de cell
							for(int i=0 ; i < taille; i++ )
							{
								 if(host_FactPrime[i]!=1)
								 {
									 	cell c;
										c.base=host_FactPrime[i];
										c.expo=1;
										addCell(c,facteursPrimes);
								  }
							}


							free(host_FactPrime);
						  cudaFree( dev_FactPrime);
							free(tab);
							cudaFree(dev_N);

	return chrGPU.elapsedTime();
}

#endif
