//
// Created by Faisal Salhi on 21/11/2021.
//
#include <iostream> // cout, endl
#include <stdint.h> // uint64_t
#include <tgmath.h> // sqrt()
#include <vector>   // tableaux dynamiques <vector>

bool isPrimeCPU(const uint64_t N);

int main() {
    std::cout << "Programme de test partie CPU - Faisal." << std::endl;

    return 0;
}

/**  \brief  Je suis la méthode qui renvoit si un certain nombre N
 *          est premier.
 *  @param N le nombre dont on doit tester la primalité.
 */
bool isPrimeCPU(const uint64_t N)
{
    uint64_t divider = (uint64_t) sqrt(N);
    for (;divider >= 2; divider-=1){
        if (floor(N/divider) == N/divider){
            return false;
        }
    }
    return true;
}

/** \brief  Je suis la méthode qui renvoit un tableau de nombre premier
 *          avec pour limite N.
 *  @param  limite La borne supérieur de l'ensemble que l'on souhaite évaluer.
 */
std::vector<uint64_t> searchPrimesCPU(const uint64_t limite){
    std::vector<uint64_t> resultat(0);

    for (uint64_t possiblePrime = limite-1; possiblePrime >=2; possiblePrime-=1){
        if (isPrimeCPU(possiblePrime)) {
            resultat.push_back(possiblePrime);
        }
    }
    return resultat;
}




