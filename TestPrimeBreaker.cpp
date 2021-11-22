#include "TestPrimeBreaker.hpp"

/**
 * \brief   Tester si un nombre premier assez grand (tenant sur un UINT32_T) est reconnu comme tel par
 *          notre fonction.
 */
void TestIfPrimeIsAssertedWithAIntegerPrimeNumber(){
    std::cout << "Tester si un nombre premier assez large tenant sur un UINT32_T est reconnu comme tel." << std::endl;
    uint32_t large_uint32_prime = LARGE_UINT32_NUMBER;

    assert(isPrimeCPU(large_uint32_prime));

    std::cout << "Le nombre premier a été reconnu avec succès." << std::endl;
}

/**
 * \brief   Tester si un nombre non premier assez grand (tenant sur un UINT32_T) n'est pas reconnu
 *          comme un nombre premier par notre fonction.
 */
void TestIfNonPrimeIsNotAssertedWithAIntegerPrimeNumber(){
    std::cout << "Tester si un nombre non premier assez large tenant sur un UINT32_T n'est pas reconnu comme tel." << std::endl;
    uint32_t large_uint32_non_prime = LARGE_UINT32_NUMBER-1;

    assert(!isPrimeCPU(large_uint32_non_prime));

    std::cout << "Le nombre premier a été reconnu avec succès." << std::endl;
}

/**
 * \brief   Tester si un nombre premier assez grand (tenant sur un UINT64_T) est reconnu comme tel par
 *          notre fonction.
 */
void TestIfPrimeIsAssertedWithALargeUint64PrimeNumber(){
    std::cout << "Tester si un nombre premier tenant sur un UINT64_T est reconnu comme tel." << std::endl;
    uint64_t large_uint64_prime = LARGE_UINT64_NUMBER;

    assert(isPrimeCPU(large_uint64_prime));

    std::cout << "Le nombre premier a été reconnu avec succès." << std::endl;
}

/**
 * \brief   Tester si un nombre non premier assez grand (tenant sur un UINT64_T) n'est  pas reconnu
 *          comme un nombre premier par notre fonction.
 */
void TestIfNonPrimeIsNotAssertedWithALargeUint64PrimeNumber(){
    std::cout << "Tester si un nombre non premier tenant sur un UINT64_T n'est pas reconnu comme tel." << std::endl;
    uint64_t large_uint64_non_prime = LARGE_UINT64_NUMBER-1;

    assert(!isPrimeCPU(large_uint64_non_prime));

    std::cout << "Le nombre qui n'est pas premier n'a été reconnu comme un nombre premier : succès " << std::endl;
}

/**
 * \brief Tester la génération de nombre premiers sur un interval entre zéro et 2000;
 */
void TestIfPrimesBetween0and100AreSuccessfullyRetrieved()
{
    std::cout << "Tester la récupération des nombres premiers entre 0 et 100." << std::endl;

    vector<uint64_t> controlPrimeSet = getPrimesFrom0to100FromControlPrimeSetFile();
    vector<uint64_t> primesNumberFrom0to100 = searchPrimesCPU(100);

    assert(controlPrimeSet.size() == primesNumberFrom0to100.size());

    for (int i = 0; i < controlPrimeSet.size(); i++){
        assert(controlPrimeSet.at(i) == primesNumberFrom0to100.at(i));
    }

    std::cout << "On retrouve bien tout les nombres premiers compris dans l'interval : Succès." << std::endl;
}

/**  \brief Je suis la méthode qui récupère à partir du fichier temoin
 *          la liste des nombres premiers compris entre zéro et cent.
 *   @return La liste des nombres premiers sous la forme d'un vector<uint64_t>
 */
vector<uint64_t> getPrimesFrom0to100FromControlPrimeSetFile(){
    vector<uint64_t> output(0);
    string filename = "primes0to100.txt";
    string line = "";
    ifstream primes0to100 (filename);
    if (primes0to100.is_open()){
        while (getline(primes0to100, line)){
            putPrimesFromLineInOutput(line, &output);
        }
        primes0to100.close();
    }
    return output;
}

/** \brief  Je suis une fonction qui prends une ligne de notre fichier témoin
 *          et met les nombres premiers présent dans cette ligne dans notre
 *          tableau.
 * @param line Ligne de notre fichier témoin.
 * @param output Tableau de nombre premier à remplir.
 */
void putPrimesFromLineInOutput(string line,vector<uint64_t> *output){
    vector<uint64_t> primes = splitNumbersFromLine(line);

    for (int i = 0; i < primes.size(); i++){
        (*output).push_back(primes.at(i));
    }
}

/** \brief  Je suis une fonction qui sépare les nombres premiers d'une ligne
 *          extraite de notre fichier témoin et qui renvoit ces nombres dans
 *          un vector<uint64_t>
 * @param line Une ligne contenant des nombres premiers séparé par des tabulations
 * @return Un vector<uint64_t> de nos nombres premiers.
 */
vector<uint64_t> splitNumbersFromLine(string line){
    vector<uint64_t> output(0);
    stringstream ss(line); // Utilisé pour lire une chaine de caractère comme un flux.
    char *numberOfCharProcessed = 0; // strtoull param.

    string buffer = "";
    while (getline(ss, buffer, '\t')) {
        output.push_back(
                strtoull(buffer.c_str(), &numberOfCharProcessed, 10)
        );
        buffer = "";
    }
    return output;
}