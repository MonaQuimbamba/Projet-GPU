#include <iostream>
#include <cstdlib>
#include <cstdint>
#include "utils/chronoGPU.hpp"
#include "utils/chronoCPU.hpp"
#include "primeBreaker.hpp"
#include "primeBreakerCPU.hpp"
#include "TestPrimeBreakerGPU.hpp"
#include "TestPrimeBreaker.hpp"
#include "utils/common.hpp"
#include "helper.hpp"

using namespace std;


int main( int argc, char **argv )
{
    cout << "=========================================================================="	<< endl;
    cout << "         			Partie CPU	                               " 	<< endl;
    cout << "=========================================================================="	<< endl << endl;

    	launchUnitTest();

    cout << "=========================================================================="	<< endl;
    cout << "         			Partie GPU	                               " 	<< endl;
    cout << "=========================================================================="	<< endl << endl;

	launchUnitTestGPU();

	return EXIT_SUCCESS;
}
