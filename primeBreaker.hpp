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



__global__ void facGPU(uint64_t  N,uint64_t *const dev_primes,cell *const dev_facteurs);
template<int numKernel> __host__
float launchKernelFactGPU(const uint64_t N,uint64_t *primes, cell *facteurs)
{

					  uint64_t *dev_primes;
						cell *dev_facteurs;
						int  taille = N-1; // la taille da la liste des nombres premiers
						facteurs=(cell*)malloc(taille*sizeof(cell));

						for (int i= 0; i < taille; i++)
						{

							  facteurs[i].base=primes[i];
								facteurs[i].expo=0;

						}

						HANDLE_ERROR(cudaMalloc( (void**)&dev_primes, taille*sizeof(uint64_t) ));
						HANDLE_ERROR(cudaMemcpy(dev_primes,primes,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));

						HANDLE_ERROR(cudaMalloc( (void**)&dev_facteurs, taille*sizeof(cell) ));
						HANDLE_ERROR(cudaMemcpy(dev_facteurs,facteurs,taille*sizeof(cell), cudaMemcpyHostToDevice ));


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
						std::cout << "Computing on " << dimGrid << " block(s) and " << dimBlock  << std::endl;
						ChronoGPU chrGPU;
						chrGPU.start();
						facGPU<<<dimGrid, dimBlock>>>(N,dev_primes,dev_facteurs);
						chrGPU.stop();
						HANDLE_ERROR( cudaMemcpy( facteurs,dev_facteurs,taille*sizeof(cell), cudaMemcpyDeviceToHost ) );

						for(int i=0 ; i < taille ; i++)
						{
							if(facteurs[i].expo!=0)
							{
								std::cout << "/* message */"<< facteurs[i].base <<"^"<<facteurs[i].expo << '\n';
							}

						}

							free(primes);
						  cudaFree( dev_facteurs);
							cudaFree(dev_primes);

	return chrGPU.elapsedTime();
}

#endif
