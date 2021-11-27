

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
__global__ void isPrimeGPU(uint64_t *const dev_N,unsigned int *const isPrime,const uint64_t N);
// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelIsPrimeGPU(const uint64_t N,unsigned int &isPrime)
{
					 isPrime=1;
					// prepare data to send to GPU
					  uint64_t *dev_N;
						uint64_t  *tab;
						tab = (uint64_t*)malloc( N*sizeof(uint64_t) );
						for (uint64_t i= 0;i < N; i++)
						{
									if(i==0 || i==1)
									{
										tab[i]=2;
									}
									else{
										tab[i]=i;
									}
					  }

					/*	for(int i=0; i<N;i++)
						{
							cout<< "voir "<< tab[i]<<endl;
						}*/

						HANDLE_ERROR(cudaMalloc( (void**)&dev_N,  N*sizeof(uint64_t) ));
						HANDLE_ERROR(cudaMemcpy(dev_N,tab, N * sizeof(uint64_t), cudaMemcpyHostToDevice ));
						// Set grid and block dimensions
						unsigned int dimBlock;
						unsigned int dimGrid;
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
						unsigned int *host_partialIsPrime; //= new unsigned int[dimGrid];
						host_partialIsPrime = (unsigned int*)malloc( dimGrid*sizeof(unsigned int) );
						size_t sizePartial		= dimGrid  * sizeof(unsigned int);
						size_t sizeSMem			= dimBlock * sizeof(unsigned int);

						//for( unsigned int i =0; i < sizePartial ; i++)
						//{	host_partialIsPrime[i]=1;}

					/*	std::cout << "Computing on " << dimGrid << " block(s) and "
									<< dimBlock << " thread(s) - shared memory size = "
									<< sizeSMem << " size "<< sizePartial << std::endl;
*/
						  unsigned int *dev_partialIsPrime;
							HANDLE_ERROR( cudaMalloc( (void**) &dev_partialIsPrime, sizePartial ) );
							HANDLE_ERROR( cudaMemcpy(dev_partialIsPrime,host_partialIsPrime,sizePartial, cudaMemcpyHostToDevice ));
							ChronoGPU chrGPU;
							chrGPU.start();
							isPrimeGPU<<<dimGrid, dimBlock,sizeSMem>>>(dev_N,dev_partialIsPrime,N);
							chrGPU.stop();
							HANDLE_ERROR( cudaMemcpy( host_partialIsPrime,dev_partialIsPrime,sizePartial, cudaMemcpyDeviceToHost ) );

							// verifier s'il y'a des zeros dans le tableau partial

							bool isPrimeBool =true;
							cout << " size meme => " << dimGrid << endl;
							for(int i =0; i < dimGrid && isPrimeBool ; i++)
							{
										//cout <<"\n reduce " <<host_partialIsPrime[i]<< " le i "<< i <<endl;
									if(host_partialIsPrime[i]==0) // si il y'a un Zero c-à-d que le numéro n'est pas premier
									{
											isPrime=0;
										  isPrimeBool=false;
									}
							}

							free(host_partialIsPrime);
						  cudaFree( dev_partialIsPrime );
							free(tab);
							cudaFree(dev_N);

	return chrGPU.elapsedTime();
}

#endif
