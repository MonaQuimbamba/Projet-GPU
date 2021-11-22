
#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <ctime>
#include <inttypes.h>
#include <cstdio>
#include <cstdint>

#include "utils/chronoCPU.hpp"
#include "utils/chronoGPU.hpp"

#include "primeBreaker.hpp"
#include "primeBreakerCPU.hpp"

using namespace std;

void printUsage( const char *prg )
{
	cerr	<< "Usage: " << prg << endl
			<< " \t N "
			<< endl << endl;
	exit( EXIT_FAILURE );
}



int main( int argc, char **argv )
{


	uint64_t N =10;/*= argc==1 ? 		if ( sscanf( argv[++i], "%s", fileName ) != 1 ) : 0 ;
	if(N==0)
	{
		printUsage( argv[0] );
	}*/

	if( argc==1)
	{
			if ( sscanf( argv[1],"%" SCNu64,&N ) != 1 )
			{
						printUsage( argv[0] );
			}

	}

	cout << "%lu64" , N ;


/*
	cout << "============================================"	<< endl;
	cout << "         Sequential version on CPU          " 	<< endl;
	cout << "============================================"	<< endl << endl;


	cout << " Partie CPU sur le nombre  " << endl; //N
	ChronoCPU chrCPU;
	chrCPU.start();
	bool isPrime = isPrimeCPU(N);
	chrCPU.stop();
	const float timeComputeCPUIsPrime = chrCPU.elapsedTime();
	cout << "Temps du test de primalite : "	<< timeComputeCPUIsPrime << " ms" << endl;
	cout << " Est Premier ? " << isPrime << endl;

	cout << " Recherche des nombres premiers sur CPU " << endl;
	chrCPU.start();
	searchPrimesCPU(N);
	chrCPU.stop();
	const float timeComputeCPUSearchPrime = chrCPU.elapsedTime();
	cout << "Temps de recherche : "	<< timeComputeCPUSearchPrime << " ms" << endl;

	cout << " Factorisation en nombre premier  sur CPU " << endl;
	chrCPU.start();
	factoCPU(N);
	chrCPU.stop();
	const float timeComputeCPUFact = chrCPU.elapsedTime();
	cout << "Temps de factorisation en nombre premier : "	<< timeComputeCPUFact << " ms" << endl;
	cout << " Factorisation CPU : " ; // ajouter une focntion pour afficher la factorisation de cette façon 2133=1 ∗ 3^3 ∗ 79^1



	cout << "============================================"	<< endl;
	cout << "          Parallel versions on GPU           "	<< endl;
	cout << "============================================"	<< endl << endl;
	//  allouer la memoire pour le device ici
	cout << " Partie GPU sur le nombre " << endl; //N
	float timeComputeGPUIsPrime = launchKernelIsPrimeGPU<0>( N);
	cout << "Temps du test de primalite : "	<< timeComputeGPUIsPrime << " ms" << endl;
	cout << " Est Premier ? : " ; // afficher like  2133 −> 0

	cout << " Recherche des nombres premiers sur GPU " << endl;
	float timeComputeGPUSearch = searchPrimesGPU<0>( N);
	cout << "Temps de recherche : "	<< timeComputeGPUSearch << " ms" << endl;

	cout << " Factorisation en nombre premier  sur GPU " << endl;
	float timeComputeGPUFact = factoGPU<0>( N);
	cout << "Temps de factorisation en nombre premier : "	<< timeComputeGPUFact << " ms" << endl;
	cout << " Factorisation GPU : " ; // ajouter une focntion pour afficher la factorisation de cette façon 2133=1 ∗ 3^3 ∗ 79^1

	// librerer la memoire du device ici
*/


	return EXIT_SUCCESS;
}