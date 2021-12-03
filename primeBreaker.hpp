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


using namespace std;

/** /brief
   Cette fonction va  tester la primalité d’un nombre de
  - L’algorithme consiste à vérifier pour un nombre N, si tous les nombres inférieurs ne le divisent pas
*/
__global__ void isPrimeGPU(uint64_t *const dev_N,unsigned int  *const isPrime, uint64_t const N,size_t const taille);
// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelIsPrimeGPU(const uint64_t N,unsigned int &isPrime)
{
					 isPrime=1;
					 if(N!=2 && N!=3) // pour s'assurer qu'on lance pas le kernel si le N est 2 ou 3
					 {
										// prepare data to send to GPU , soit N un numero on fait un tableau avec des numeros inférieurs à N
										// pour 0 et 1 on met 2 , exemple pour 10 on a [9,8,7,6,5,4,3,2,2,2]
										  uint64_t *dev_N;
											uint64_t  *tab_possibles_diviseurs;
											int taille = sqrt(N)+1;
											tab_possibles_diviseurs = (uint64_t*)malloc( taille*sizeof(uint64_t) );
										  uint64_t n=2;
											for (uint64_t i= 0; i < taille; i++)
											{
														tab_possibles_diviseurs[i]=n;
														n++;
											}

											HANDLE_ERROR(cudaMalloc( (void**)&dev_N,  taille*sizeof(uint64_t) ));
											HANDLE_ERROR(cudaMemcpy(dev_N,tab_possibles_diviseurs,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));
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

											verifyDimGridBlock( dimGrid, dimBlock, taille ); // Are you reasonable ?
											unsigned int *host_partialIsPrime;
											host_partialIsPrime = (unsigned int*)malloc( dimGrid*sizeof(unsigned int) );
										  size_t sizePartial		= dimGrid  * sizeof(unsigned int);
											size_t sizeSMem			= dimBlock * sizeof(unsigned int);

											std::cout << "Computing on " << dimGrid << " block(s) and "
										  << dimBlock << " thread(s) - shared memory size = "
									   	<< sizeSMem << std::endl;
											
									  unsigned int *dev_partialIsPrime;
										HANDLE_ERROR( cudaMalloc( (void**) &dev_partialIsPrime, sizePartial ) );
										HANDLE_ERROR( cudaMemcpy(dev_partialIsPrime,host_partialIsPrime,sizePartial, cudaMemcpyHostToDevice ));

										ChronoGPU chrGPU;
										chrGPU.start();
										isPrimeGPU<<<dimGrid, dimBlock,sizeSMem>>>(dev_N,dev_partialIsPrime,N,taille);
										chrGPU.stop();
										HANDLE_ERROR( cudaMemcpy( host_partialIsPrime,dev_partialIsPrime,sizePartial, cudaMemcpyDeviceToHost ) );
										// on verifie si (1) est vrai
										// verifier s'il y'a des zeros dans le tableau partial , si oui c'est pas premier
										bool isPrimeBool =true;
										for(int i =0; i < dimGrid && isPrimeBool ; i++)
										{
												if(host_partialIsPrime[i]==0) // si il y'a un Zero c-à-d que le numéro n'est pas premier
												{
															isPrime=0;
															isPrimeBool=false; // on arrête la boucle
												}
										}
										free(host_partialIsPrime);
									  cudaFree( dev_partialIsPrime );
										free(tab_possibles_diviseurs);
										cudaFree(dev_N);

					        	return chrGPU.elapsedTime();
	}
	return 0.0;
}



/** /brief
Cette fonction permet de rechercher des nombres premiers inférieurs à N.
- L’algorithme consiste à tester la primalité de tous les nombres inférieurs à N à l’aide de la fonction isprimeGPU.
*/
__global__ void searchPrimeGPU(uint64_t *const dev_N,uint64_t  *const primesNumbers,uint64_t const N, int const taille);
// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelSearchPrimeGPU(const uint64_t N,uint64_t *primesNumbers)
{


										  uint64_t *dev_N,*dev_res;
											uint64_t  *tab_num_inferieurs;
											int taille =N-1;
											tab_num_inferieurs = (uint64_t*)malloc( taille*sizeof(uint64_t) );
											primesNumbers =(uint64_t*)malloc(taille*sizeof(uint64_t) );

									   uint64_t n=2;
											for (uint64_t i= 0; i < taille; i++) // remplir le tableu avec les numeros en 2 à N
											{
													tab_num_inferieurs[i]=n;
													n++;
											}

											HANDLE_ERROR(cudaMalloc( (void**)&dev_N,  taille*sizeof(uint64_t) ));
											HANDLE_ERROR(cudaMemcpy(dev_N,tab_num_inferieurs,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));

											HANDLE_ERROR(cudaMalloc( (void**)&dev_res,  taille*sizeof(uint64_t) ));
											HANDLE_ERROR(cudaMemcpy(dev_res,primesNumbers,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));
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

										verifyDimGridBlock( dimGrid, dimBlock, taille ); // Are you reasonable ?
										ChronoGPU chrGPU;
										chrGPU.start();
										searchPrimeGPU<<<dimGrid, dimBlock>>>(dev_N,dev_res,N,taille);
										chrGPU.stop();
										HANDLE_ERROR( cudaMemcpy( primesNumbers,dev_res,taille*sizeof(uint64_t), cudaMemcpyDeviceToHost ) );

										for(int i=0 ; i < taille ; i++)
										{
											std::cout << "[ "<< primesNumbers[i] <<" ]" << '\n';
										}
					        	return chrGPU.elapsedTime();

}

#endif
