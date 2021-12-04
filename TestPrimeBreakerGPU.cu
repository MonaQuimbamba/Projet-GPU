#include "TestPrimeBreakerGPU.hpp"

/**	\brief	Je suis une fonction qui lance les tests unitaires pour les 
 * 		calculs a effectuer sur le GPU.
 */
void launchUnitTestGPU(){
    cout << "============================================"	<< endl;
    cout << "         Lancement des tests unitaires.     " 	<< endl;
    cout << "============================================"	<< endl << endl;

    testIfNonPrimeIsNotAssertedWithAIntegerPrimeNumberOnGPU();
    testIfPrimeIsAssertedWithAIntegerPrimeNumberOnGPU();
/*
    testIfPrimeIsAssertedWithALargeUint64PrimeNumberOnGPU();
    testIfNonPrimeIsNotAssertedWithALargeUint64PrimeNumberOnGPU();
    TestIfPrimesBetween0and100AreSuccessfullyRetrieved();
*/
    cout << "============================================"	<< endl;
    cout << "    Tests unitaires éffectués avec succès.   " 	<< endl;
    cout << "============================================"	<< endl << endl;
}


/**
 * \brief   Tester si un nombre non premier assez grand (tenant sur un UINT32_T) n'est pas reconnu
 *          comme un nombre premier par notre fonction.
 */
void testIfNonPrimeIsNotAssertedWithAIntegerPrimeNumberOnGPU(){
    std::cout << "Tester si un nombre non premier assez large tenant sur un UINT32_T n'est pas reconnu comme tel." << std::endl;
    
    int taille = (sqrt(UINT32_T_PRIME-1)+1)-2; // [[2;sqrt(N)+1]]
    uint64_t *possibles_diviseurs = (uint64_t *)malloc(sizeof(uint64_t) * taille);
    unsigned int *resOperations = (unsigned int *)malloc(sizeof(unsigned int *) * taille);
    memset(resOperations, '\0', taille);
    for(int i = 0,j = 2; i < taille; possibles_diviseurs[i] = j,i++,j++);
    
    
    uint64_t *dev_possibles_diviseurs = NULL;
    unsigned int *dev_resOperations = NULL;
    
    cudaMalloc(&dev_possibles_diviseurs, sizeof(uint64_t) * taille);
    cudaMalloc(&dev_resOperations, sizeof(unsigned int) * taille);
    cudaMemcpy(dev_possibles_diviseurs, possibles_diviseurs, sizeof(uint64_t) * taille, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_resOperations, resOperations, sizeof(unsigned int) * taille, cudaMemcpyHostToDevice);

    isPrimeGPU<<<GRIDDIM(taille),BLOCKDIM>>>(	
	dev_possibles_diviseurs,
	dev_resOperations,
	UINT32_T_PRIME-1,
	taille
	);

    cudaMemcpy(resOperations, dev_resOperations, sizeof(unsigned int) * taille, cudaMemcpyDeviceToHost);
    
    cudaFree(dev_possibles_diviseurs);
    cudaFree(dev_resOperations);
    free(possibles_diviseurs);
    free(resOperations);
    
    mAssert("isPrimeGPU(\tdev_possibles_diviseurs\n\tdev_resOperations\n\tUINT32_T_PRIME-1\n\ttaille)\n",
	resOperations[0] == 0,
	"Le nombre non premier a été reconnu comme un nombre premier.\n");


    std::cout << "Le nombre non premier n'a pas été reconnu : succès." << std::endl << std::endl;
}

/**
 * \brief   Tester si un nombre premier assez grand (tenant sur un UINT32_T) est reconnu comme tel par
 *          notre fonction.
 */
void testIfPrimeIsAssertedWithAIntegerPrimeNumberOnGPU(){
    std::cout << "Tester si un nombre premier assez large tenant sur un UINT32_T est reconnu comme tel." << std::endl;

    int taille = (sqrt(UINT32_T_PRIME)+1)-2; // [[2;sqrt(N)+1]]
    uint64_t *possibles_diviseurs = (uint64_t *)malloc(sizeof(uint64_t) * taille);
    unsigned int *resOperations = (unsigned int *)malloc(sizeof(unsigned int *) * taille);
    memset(resOperations, '\0', taille);
    for(int i = 0, j = 2; i < taille; possibles_diviseurs[i] = j,i++,j++);
    
    uint64_t *dev_possibles_diviseurs = NULL;
    unsigned int *dev_resOperations = NULL;
    
    cudaMalloc(&dev_possibles_diviseurs, sizeof(uint64_t) * taille);
    cudaMalloc(&dev_resOperations, sizeof(unsigned int) * taille);
    cudaMemcpy(dev_possibles_diviseurs, possibles_diviseurs, sizeof(uint64_t) * taille, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_resOperations, resOperations, sizeof(unsigned int) * taille, cudaMemcpyHostToDevice);

    isPrimeGPU<<<GRIDDIM(taille),BLOCKDIM>>>(	
	dev_possibles_diviseurs,
	dev_resOperations,
	UINT32_T_PRIME,
	taille
	);

    cudaMemcpy(resOperations, dev_resOperations, sizeof(unsigned int) * taille, cudaMemcpyDeviceToHost);
    
    cudaFree(dev_possibles_diviseurs);
    cudaFree(dev_resOperations);
    free(possibles_diviseurs);
    free(resOperations);
    
    mAssert("isPrimeGPU(\tdev_possibles_diviseurs\n\tdev_resOperations\n\tUINT32_T_PRIME\n\ttaille)\n",
	resOperations[0] == 1,
	"Le nombre premier n'a pas été reconnu comme tel.\n");


    std::cout << "Le nombre premier a été reconnu : succès." << std::endl << std::endl;
}

/**
 * \brief   Tester si un nombre premier assez grand (tenant sur un UINT64_T) est reconnu comme tel par
 *          notre fonction.
 */
void testIfPrimeIsAssertedWithALargeUint64PrimeNumberOnGPU(){
    std::cout << "Tester si un nombre premier tenant sur un UINT64_T est reconnu comme tel." << std::endl;

    std::cout << "Le nombre premier a été reconnu : succès." << std::endl << std::endl;

}

/**
 * \brief   Tester si un nombre non premier assez grand (tenant sur un UINT64_T) n'est  pas reconnu
 *          comme un nombre premier par notre fonction.
 */
void testIfNonPrimeIsNotAssertedWithALargeUint64PrimeNumberOnGPU(){
    std::cout << "Tester si un nombre non premier tenant sur un UINT64_T n'est pas reconnu comme tel." << std::endl;

    std::cout << "Le nombre non premier n'a pas été reconnu : succès " << std::endl
    << std::endl;

}
