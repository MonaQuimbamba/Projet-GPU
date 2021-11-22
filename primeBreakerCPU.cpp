#include "primeBreakerCPU.hpp"

using namespace std;

/**  \brief  Je suis la méthode qui renvoit si un certain nombre N
 *          est premier.
 *  @param N le nombre dont on doit tester la primalité.
 */
bool isPrimeCPU(const uint64_t N)
{
    long double divider = N-1;
    for (;divider >= 2; divider-=1){
        if (floor(N/divider) == N/divider){
            //std::cout << "[DEBUG] floor(N/divider) = " << floor(N/divider) << " | N/divider = " << N/divider << std::endl;
            return false;
        }
    }
    return true;
}

/** \brief  Je suis la méthode qui renvoit un tableau de nombre premier
 *          avec pour limite N.
 *  @param  limite La borne supérieur de l'ensemble que l'on souhaite évaluer.
 */
std::vector<uint64_t> searchPrimesCPU(const uint64_t limite)
{
    std::vector<uint64_t> resultat(0);

    for (uint64_t possiblePrime = limite-1; possiblePrime >=2; possiblePrime-=1)
    {
        if (isPrimeCPU(possiblePrime)) {
            resultat.push_back(possiblePrime);
        }
    }
    return resultat;
}





vector<uint64_t> facteursPrimes(0);
vector<uint64_t> factoCPU(uint64_t N)
{

    bool keepGoin=false;
    vector<uint64_t> primesNumber = searchPrimesCPU(N);
    if(primesNumber.size()!=0)
    {
        if( primesNumber.at(0) > sqrt(N)) keepGoin=true; // arriver à 1
    }
    for (int i = 0; i < primesNumber.size() && keepGoin==true; i++)
    {
            while(N % primesNumber.at(i)==0)
            {
                facteursPrimes.push_back(primesNumber.at(i)); // dans la liste de facteurs
                factoCPU(N/primesNumber.at(i)); //
            }
    }

    return facteursPrimes;
}
