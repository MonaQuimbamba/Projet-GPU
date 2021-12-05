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

	unsigned int N = UINT32_T_PRIME-1;
	unsigned int sqrtN = sqrt(N) + 1;
	unsigned int nombresDePossiblesPremiers = N-2;

	unsigned int *possibles_premiers = (unsigned int*)malloc(sizeof(unsigned int) * (nombresDePossiblesPremiers));
	for (int i = 0, j = 2.0; j < N; possibles_premiers[i] = j,i++,j++);
	unsigned int *res_operations = (unsigned int*)malloc(sizeof(unsigned int) * GRIDDIM(sqrtN));
	for (int i = 0; i < GRIDDIM(sqrtN); res_operations[i] = 1,i++);

	unsigned int *dev_possibles_premiers;
	cudaMalloc((void**)&dev_possibles_premiers, sizeof(unsigned int) * (nombresDePossiblesPremiers));
	unsigned int *dev_res_operations;
	cudaMalloc((void**)&dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN));


	cudaMemcpy(dev_possibles_premiers, possibles_premiers, sizeof(unsigned int) * (nombresDePossiblesPremiers), cudaMemcpyHostToDevice);
       	cudaMemcpy(dev_res_operations, res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyHostToDevice);
	isPrime<<<GRIDDIM(sqrtN),BLOCKDIM,SIZEMEM(BLOCKDIM)>>>(dev_possibles_premiers, dev_res_operations, N, sqrtN);
	cudaMemcpy(res_operations, dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyDeviceToHost);

	for (int i = 0; i < GRIDDIM(sqrtN); i++){
		res_operations[i] == 0 ? res_operations[0] = 0 : 0;
	}
    
    	mAssert("isPrimeGPU(\tdev_possibles_diviseurs\n\tdev_resOperations\n\tUINT32_T_PRIME-1\n\ttaille)\n",
		res_operations[0] == 0,
		"Le nombre non premier a été reconnu comme un nombre premier.\n");

	cudaFree(dev_possibles_premiers);
	cudaFree(dev_res_operations);
	free(possibles_premiers);
	free(res_operations);

    	std::cout << "Le nombre non premier n'a pas été reconnu : succès." << std::endl << std::endl;
}

/**
 * \brief   Tester si un nombre premier assez grand (tenant sur un UINT32_T) est reconnu comme tel par
 *          notre fonction.
 */
void testIfPrimeIsAssertedWithAIntegerPrimeNumberOnGPU(){
    	std::cout << "Tester si un nombre premier assez large tenant sur un UINT32_T est reconnu comme tel." << std::endl;
    
	unsigned int N = UINT32_T_PRIME;
	unsigned int sqrtN = sqrt(N) + 1;
	unsigned int nombresDePossiblesPremiers = N-2;

	unsigned int *possibles_premiers = (unsigned int*)malloc(sizeof(unsigned int) * (nombresDePossiblesPremiers));
	for (int i = 0, j = 2.0; j < N; possibles_premiers[i] = j,i++,j++);
	unsigned int *res_operations = (unsigned int*)malloc(sizeof(unsigned int) * GRIDDIM(sqrtN));
	for (int i = 0; i < GRIDDIM(sqrtN); res_operations[i] = 1,i++);

	unsigned int *dev_possibles_premiers;
	cudaMalloc((void**)&dev_possibles_premiers, sizeof(unsigned int) * (nombresDePossiblesPremiers));
	unsigned int *dev_res_operations;
	cudaMalloc((void**)&dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN));


	cudaMemcpy(dev_possibles_premiers, possibles_premiers, sizeof(unsigned int) * (nombresDePossiblesPremiers), cudaMemcpyHostToDevice);
       	cudaMemcpy(dev_res_operations, res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyHostToDevice);
	isPrime<<<GRIDDIM(sqrtN),BLOCKDIM,SIZEMEM(BLOCKDIM)>>>(dev_possibles_premiers, dev_res_operations, N, sqrtN);
	cudaMemcpy(res_operations, dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyDeviceToHost);

	for (int i = 0; i < GRIDDIM(sqrtN); i++){
		res_operations[i] == 0 ? res_operations[0] = 0 : 0;
	}
    
    	mAssert("isPrimeGPU(\tdev_possibles_diviseurs\n\tdev_resOperations\n\tUINT32_T_PRIME\n\ttaille)\n",
		res_operations[0] == 1,
		"Le nombre premier n'a pas été reconnu comme tel.\n");
	
	cudaFree(dev_possibles_premiers);
	cudaFree(dev_res_operations);
	free(possibles_premiers);
	free(res_operations);

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
