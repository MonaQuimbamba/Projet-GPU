#include <iostream>
#include <cstdlib>
#include <cstdint>
#include "utils/chronoGPU.hpp"
#include "utils/chronoCPU.hpp"
#include "primeBreaker.hpp"
#include "primeBreakerCPU.hpp"
#include "utils/common.hpp"
#include "helper.hpp"

using namespace std;


int main( int argc, char **argv )
{

	uint64_t N=atoll(argv[1]);

	cout << "============================================"	<< endl;
	cout << "         Sequential version on CPU          " 	<< endl;
	cout << "============================================"	<< endl << endl;
	cout << " Partie CPU sur le nombre  " + to_string(N)<< endl;
	ChronoCPU chrCPU;
	chrCPU.start();
	vector<uint64_t> tab_possibles_diviseurs(0);
	bool isPrime = isPrimeCPU_v1(N,tab_possibles_diviseurs); //isPrimeCPU(N);
	chrCPU.stop();
	const float timeComputeCPUIsPrime = chrCPU.elapsedTime();
	cout << "Temps du test de primalite : "	<< timeComputeCPUIsPrime << " ms" << endl;
	cout << " Est Premier ? " << isPrime << endl;
	cout << " Recherche des nombres premiers sur CPU " << endl;
	chrCPU.start();
	vector<uint64_t> primesNumbers = searchPrimesCPU_v0(N);
	chrCPU.stop();
	const float timeComputeCPUSearchPrime = chrCPU.elapsedTime();
  	//cout << printPrimes(primesNumbers) << endl; //afficher les nombres premiers //
    	cout << "Temps de recherche : "	<< timeComputeCPUSearchPrime << " ms" << endl;
	cout << " Factorisation en nombre premier  sur CPU " << endl;
	chrCPU.start();
  	vector<cell> facteurs(0);
  	factoCPU(N,&facteurs);
	chrCPU.stop();
	const float timeComputeCPUFact = chrCPU.elapsedTime();
	cout << "Temps de factorisation en nombre premier : "	<< timeComputeCPUFact << " ms" << endl;
	cout << " Factorisation CPU : " << printFacteurs(facteurs)<<endl ;


  	cout << "============================================"	<< endl;
	cout << "          Parallel versions on GPU           "	<< endl;
	cout << "============================================"	<< endl << endl;
	cout << " Partie GPU sur le nombre : " + to_string(N)<< endl;
	unsigned int isPrimeGPU;
	const float timeComputeGPUIsPrime = launchKernelIsPrimeGPU<0>(N,isPrimeGPU);
	cout << "Temps du test de primalite : "	<< timeComputeCPUIsPrime << " ms" << endl;
	cout << " Est Premier ? " << isPrimeGPU << endl;

	return EXIT_SUCCESS;
}
