//
// Created by Faisal Salhi on 21/11/2021.
//
#include <iostream> // cout, endl
#include <stdint.h> // uint64_t
#include <tgmath.h> // sqrt()

bool isPrimeCPU(const uint64_t N);

int main() {
    std::cout << "Programme de test partie CPU - Faisal." << std::endl;
    return 0;
}

/*  \brief  Je suis la méthode qui renvoit si un certain nombre N
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


