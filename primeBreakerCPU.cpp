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

    for (uint64_t possiblePrime = limite; possiblePrime >=2; possiblePrime-=1)
    {
        if (isPrimeCPU(possiblePrime)) {
            resultat.push_back(possiblePrime);
        }
    }
    return resultat;
}

/**   \brief je suis la methode qui va ajouter , une celule dans le vecteurs de facteurs
*/

void addCell( cell c , vector< cell> *facteursPrimes)
{
    bool add=true;
    for(int i=0 ; i < facteursPrimes->size();i++)
    {
       if(c.base==facteursPrimes->at(i).base)
       {
         facteursPrimes->at(i).expo+=1;
         add=false;
       }
    }

    if(add==true) facteursPrimes->push_back(c);
}

/** \brief je suis la methode qui permet de décomposeur un nombre en facteurs premiers
 *
 * @param N
 * @param facteursPrimes
 */
 void factoCPU(uint64_t N, vector<cell> *facteursPrimes)
{


    if(N!=1)
    {
        vector<uint64_t> primesNumbers = searchPrimesCPU(N);
        bool keepGoin=true;
        sort(primesNumbers.begin(), primesNumbers.end());
        if(primesNumbers.at(0) > sqrt(N)) return;
            uint64_t  t;
            for (int i = 0; i < primesNumbers.size() && keepGoin==true; i++)
            {

                if (N % primesNumbers.at(i) == 0)
                {
                     cell c;
                    c.base=primesNumbers.at(i);
                    c.expo=1;
                    addCell(c,facteursPrimes);
                    t=N / primesNumbers.at(i);
                    keepGoin=false;
                }
            }
            if(keepGoin==false)  factoCPU(t,facteursPrimes);

    }
    return;


}
