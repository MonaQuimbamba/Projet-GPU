#ifndef __PREMEBREAKER_HPP
#define __PREMEBREAKER_HPP

#include <stdint.h>
#include "utils/common.hpp"
#include "utils/chronoCPU.hpp"
#include "utils/chronoGPU.hpp"




/** /brief
   Cette fonction va  tester la primalité d’un nombre de
  - L’algorithme consiste à vérifier pour un nombre N, si tous les nombres inférieurs ne le divisent pas
*/
__global__ void isPrimeGPU(const uint64_t N);

// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelIsPrimeGPU(const uint64_t N )
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
						ChronoGPU chrGPU;
						chrGPU.start();
						isPrimeGPU<<<dimGrid, dimBlock>>>(N);
						chrGPU.stop();
	return chrGPU.elapsedTime();
}
/** /brief
   Cette fonction permet de rechercher des nombres premiers inférieurs à N.
  - L’algorithme consiste à tester la primalité de tous les nombres inférieurs à N à l’aide de la fonction précédente.
	 Il faut savoir que l’on ne peut connaître la taille de la liste renvoyée à l’avance.
	 donc trouver une solution (structure de données dynamique, gestion de la mémoire manuelle, taille fixée, etc.).
*/
__global__ void searchPrimesGPU(const uint64_t N);

// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelSearchPrimesGPU(const uint64_t N )
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
						ChronoGPU chrGPU;
						chrGPU.start();
						searchPrimesGPU<<<dimGrid, dimBlock>>>(N);
						chrGPU.stop();
	return chrGPU.elapsedTime();
}

/** /brief
	Cette fonction va faire la décomposition en facteurs premiers
	 - Le principe de la décomposition consiste à parcourir les nombres p de la liste des nombres premiers
	trouvés avant en testant si ce nombre p divise N. Si oui, on recommence l’algorithme avec N = N/p.
	On s’arrête quand le nombre premier à tester devient supérieur à la racine carrée de N.
*/
__global__ void factoGPU(uint64_t N);
// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelFactoGPU(const uint64_t N )
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
						ChronoGPU chrGPU;
						chrGPU.start();
						factoGPU<<<dimGrid, dimBlock>>>(N);
						chrGPU.stop();
	return chrGPU.elapsedTime();
}

#endif
