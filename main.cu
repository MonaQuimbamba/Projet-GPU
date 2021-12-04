#include <iostream>
#include <cstdlib>
#include <cstdint>
#include "utils/chronoCPU.hpp"
#include "utils/chronoGPU.hpp"
#include "primeBreakerCPU.hpp"
#include "primeBreaker.hpp"
#include "utils/common.hpp"
#include "Reference.hpp"
#include "helper.hpp"

using namespace std;


int main( int argc, char **argv )
{

	uint64_t N=atoll(argv[1]);

	cout << "============================================"	<< endl;
	cout << "          Parallel versions on GPU           "	<< endl;
	cout << "============================================"	<< endl << endl;
	cout << " Partie GPU sur le nombre : " + to_string(N)<< endl;

	cout << " Factorisation en nombre premier  sur GPU " << endl;
	uint64_t *primesNumbersGPU;
	int taille=primesNumbers.size();
	primesNumbersGPU=(uint64_t*)malloc(taille*sizeof(uint64_t));
	for(int i=0;i<taille;i++)
	{
		primesNumbersGPU[i]=primesNumbers.at(i);
	}
	cell *facteursGPU;
	float timeComputeGPUFact = launchKernelFactGPU<0>(N,primesNumbersGPU,facteursGPU,taille);
	cout << "Temps de factorisation en nombre premier : "	<< timeComputeGPUFact << " ms" << endl;

	return EXIT_SUCCESS;
}
