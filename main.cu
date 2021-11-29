
#include <iostream>
#include <cstdlib>
#include <cstdint>
#include "utils/chronoCPU.hpp"
#include "utils/chronoGPU.hpp"
#include "primeBreakerCPU.hpp"
#include "primeBreaker.hpp"
#include "utils/common.hpp"

using namespace std;

void printUsage( const char *prg )
{
	cerr	<< "Usage: " << prg << endl
			<< " \t N "
			<< endl << endl;
	exit( EXIT_FAILURE );
}

string printPrimes(std::vector<uint64_t> primeNumbers)
{
        string res =  "Nombres premiers : \n " ;

        for(int i =0 ; i < primeNumbers.size() ; i++)
        {
           res += "[" + std::to_string(primeNumbers.at(i)) + "]";
        }
    return res;
}

string printFactuers(vector<cell> facteurs )
{
    string res = "Les Facteurs premiers :  \n ";
    for(int i = 0 ; i < facteurs.size(); i++)
    {
			string cell = to_string(facteurs.at(i).base)+"^"+to_string(facteurs.at(i).expo);
    	res+= (i==facteurs.size()-1) ? ""+cell : cell+"*" ;
    }
    return res;
}

int main( int argc, char **argv )
{


	uint64_t N =200;

	cout << "============================================"	<< endl;
	cout << "         Sequential version on CPU          " 	<< endl;
	cout << "============================================"	<< endl << endl;


	cout << " Partie CPU sur le nombre  " + to_string(N)<< endl;
	ChronoCPU chrCPU;
	chrCPU.start();
	bool isPrime = isPrimeCPU(N);
	chrCPU.stop();
	const float timeComputeCPUIsPrime = chrCPU.elapsedTime();
	cout << "Temps du test de primalite : "	<< timeComputeCPUIsPrime << " ms" << endl;
	cout << " Est Premier ? " << isPrime << endl;

	cout << " Recherche des nombres premiers sur CPU " << endl;
	chrCPU.start();
	std::vector<uint64_t> primesNumbers = searchPrimesCPU(N);
	chrCPU.stop();
	const float timeComputeCPUSearchPrime = chrCPU.elapsedTime();
  //cout << printPrimes(primesNumbers) << endl; //afficher les nombres premiers
    cout << "Temps de recherche : "	<< timeComputeCPUSearchPrime << " ms" << endl;

	cout << " Factorisation en nombre premier  sur CPU " << endl;
	chrCPU.start();
  vector<cell> facteurs(0);
  factoCPU(N,&facteurs);

	chrCPU.stop();
	const float timeComputeCPUFact = chrCPU.elapsedTime();
	cout << "Temps de factorisation en nombre premier : "	<< timeComputeCPUFact << " ms" << endl;
	cout << " Factorisation CPU : " << printFactuers(facteurs)<<endl ; // ajouter une focntion pour afficher la factorisation de cette façon 2133=1 ∗ 3^3 ∗ 79^1


	cout << "============================================"	<< endl;
	cout << "          Parallel versions on GPU           "	<< endl;
	cout << "============================================"	<< endl << endl;

	cout << " Partie GPU sur le nombre : " + to_string(N)<< endl;
  unsigned int isPrimeGPU=1;
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

  HANDLE_ERROR(cudaMalloc( (void**)&dev_N,  N*sizeof(uint64_t) ));
  HANDLE_ERROR(cudaMemcpy(dev_N,tab, N * sizeof(uint64_t), cudaMemcpyHostToDevice ));
  float timeComputeGPUIsPrime = launchKernelIsPrimeGPU<0>(dev_N,isPrimeGPU,N);
  cout << "Temps du test de primalite : "	<< timeComputeGPUIsPrime << " ms" << endl;
  cout << " Est Premier ? : " << N << " -> "<< isPrimeGPU <<endl;

	free( tab );
	HANDLE_ERROR(cudaFree( dev_N ));



/*
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
