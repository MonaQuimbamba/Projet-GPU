

#ifndef __PREMEBREAKER_HPP
#define __PREMEBREAKER_HPP

#include <stdint.h>
#include <iostream>
#include <cstdlib>
#include <cstdint>
#include "utils/common.hpp"
#include "utils/chronoCPU.hpp"
#include "utils/chronoGPU.hpp"




/** /brief
   Cette fonction va  tester la primalité d’un nombre de
  - L’algorithme consiste à vérifier pour un nombre N, si tous les nombres inférieurs ne le divisent pas
*/
__global__ void isPrimeGPU(uint64_t *const dev_N,const uint64_t N,unsigned int *const isPrime);
// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelIsPrimeGPU(uint64_t *const dev_N,const uint64_t N,unsigned int &isPrime)
{
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


						unsigned int *host_partialMax	= new unsigned int[dimGrid];
						size_t sizePartial		= dimGrid  * sizeof(unsigned int);
						size_t sizeSMem			= dimBlock * sizeof(unsigned int);

						std::cout << "Computing on " << dimGrid << " block(s) and "
									<< dimBlock << " thread(s) - shared memory size = "
									<< sizeSMem << std::endl;

						unsigned int *dev_partialMax;
						HANDLE_ERROR( cudaMalloc( (void**) &dev_partialMax, sizePartial ) );
						//HANDLE_ERROR( cudaMemcpy( dev_partialMax, dev_N, sizePartial, cudaMemcpyDeviceToDevice ) );
						ChronoGPU chrGPU;
						chrGPU.start();
						isPrimeGPU<<<dimGrid, dimBlock,sizeSMem>>>(dev_N,N,dev_partialMax);
						chrGPU.stop();

						HANDLE_ERROR( cudaMemcpy( host_partialMax, dev_partialMax,sizePartial, cudaMemcpyDeviceToHost ) );
						for( int i=0 ; i< sizePartial;i++)
						{
							printf("%d\n",host_partialMax[i] );
							  //std::cout << " voir "+ to_string(host_partialMax[i]) << '\n';
						}
	return chrGPU.elapsedTime();
}

#endif
