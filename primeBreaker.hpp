
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
#include "helper.hpp"

using namespace std;

/** /brief Je suis une fonction qui évalue partiellement la primalité d'un nombre, un traitement
 * final doit être effectué par la fonction appelante afin d'évaluer la primalitée.
*/
__global__
void isPrime(	uint64_t *possibles_premiers,
		unsigned int *res_operations,
		uint64_t  N,
		uint64_t sqrtN);


__global__ void facGPU(
		uint64_t  N,
		uint64_t *const dev_primes,
		cell *const dev_facteurs
		);
/*
template<int numKernel> __host__
float launchKernelFactGPU(const uint64_t N,uint64_t *primes, cell *facteurs,int taille)
{

    uint64_t *dev_primes;
    cell *dev_facteurs;
    //int  taille = N-1; // la taille da la liste des nombres premiers
    facteurs=(cell*)malloc(taille*sizeof(cell));

    for (int i= 0; i < taille; i++)
    {

        facteurs[i].base=primes[i];
        facteurs[i].expo=0;

    }

    int *mutex;
    cudaMalloc(&mutex, sizeof(int));
    cudaMemset(mutex, 0, sizeof(int));


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
    facGPU<<<dimGrid, dimBlock>>>(N,dev_primes,dev_facteurs,mutex);
    chrGPU.stop();
    HANDLE_ERROR( cudaMemcpy( facteurs,dev_facteurs,taille*sizeof(cell), cudaMemcpyDeviceToHost ) );

    for(int i=0 ; i < taille ; i++)
    {
        if(facteurs[i].expo!=0)
        {
            std::cout << facteurs[i].base <<"^"<<facteurs[i].expo << '\n';
        }

    }

    free(primes);
    cudaFree( dev_facteurs);
    cudaFree(dev_primes);

    return chrGPU.elapsedTime();
}
*/
/** /brief
Cette fonction permet de rechercher des nombres premiers inférieurs à N.
- L’algorithme consiste à tester la primalité de tous les nombres inférieurs à N à l’aide de la fonction isprimeGPU.
*
__global__ void searchPrimeGPU(
		uint64_t *const dev_possiblesPremiers,
		uint64_t  *const dev_primes,
		uint64_t const limiter, 
		int const taille);
// ==================================================== Kernels launches
template<int numKernel> __host__
float launchKernelSearchPrimeGPU(const uint64_t limiter,uint64_t *primes)
{


    uint64_t *dev_possiblesPremiers,*dev_primes;
    uint64_t  *possiblesPremiers;
    int taille =limiter-1;
    primes = (uint64_t*)malloc( taille*sizeof(uint64_t) );
    possiblesPremiers =(uint64_t*)malloc(taille*sizeof(uint64_t) );

    uint64_t n=2;
    for (uint64_t i= 2; i < taille; i++) // remplir le tableu avec les numeros en 2 à N
    {
        possiblesPremiers[i-2]=n;
        n++;
    }

    HANDLE_ERROR(cudaMalloc( (void**)&dev_possiblesPremiers,  taille*sizeof(uint64_t) ));
    HANDLE_ERROR(cudaMemcpy(dev_possiblesPremiers,possiblesPremiers,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));

    HANDLE_ERROR(cudaMalloc( (void**)&dev_primes,  taille*sizeof(uint64_t) ));
    HANDLE_ERROR(cudaMemcpy(dev_primes,primes,taille*sizeof(uint64_t), cudaMemcpyHostToDevice ));
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
    searchPrimeGPU<<<dimGrid, dimBlock>>>(dev_possiblesPremiers,dev_primes,limiter,taille);
    chrGPU.stop();
    HANDLE_ERROR( cudaMemcpy( primes,dev_primes,taille*sizeof(uint64_t), cudaMemcpyDeviceToHost ) );


    return chrGPU.elapsedTime();

}
*/
#endif
