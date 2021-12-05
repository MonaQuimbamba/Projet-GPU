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
    testIfPrimeIsAssertedWithALargeUint64PrimeNumberOnGPU();
    testIfNonPrimeIsNotAssertedWithALargeUint64PrimeNumberOnGPU();
    testIfPrimesBetween0and100AreComputedOnGPU();
    //testIfNumberIsFactorized();
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

	uint64_t N = UINT32_T_PRIME-1;
	uint64_t sqrtN = sqrt(N) + 1;
	uint64_t nombresDePossiblesPremiers = N-2;

	uint64_t *possibles_premiers = (uint64_t*)malloc(sizeof(uint64_t) * (nombresDePossiblesPremiers));
	for (int i = 0, j = 2.0; j < N; possibles_premiers[i] = j,i++,j++);
	unsigned int *res_operations = (unsigned int*)malloc(sizeof(unsigned int) * GRIDDIM(sqrtN));
	for (int i = 0; i < GRIDDIM(sqrtN); res_operations[i] = 1,i++);

	uint64_t *dev_possibles_premiers;
	cudaMalloc((void**)&dev_possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers));

	unsigned int *dev_res_operations;
	cudaMalloc((void**)&dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN));


	cudaMemcpy(dev_possibles_premiers, possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers), cudaMemcpyHostToDevice);
       	cudaMemcpy(dev_res_operations, res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyHostToDevice);
	isPrime<<<GRIDDIM(sqrtN),BLOCKDIM,SIZEMEM>>>(dev_possibles_premiers, dev_res_operations, N, sqrtN);
	cudaMemcpy(res_operations, dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyDeviceToHost);

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
    
	uint64_t N = UINT32_T_PRIME;
	uint64_t sqrtN = sqrt(N) + 1;
	uint64_t nombresDePossiblesPremiers = N-2;

	uint64_t *possibles_premiers = (uint64_t*)malloc(sizeof(uint64_t) * (nombresDePossiblesPremiers));
	for (int i = 0, j = 2.0; j < N; possibles_premiers[i] = j,i++,j++);
	unsigned int *res_operations = (unsigned int*)malloc(sizeof(unsigned int) * GRIDDIM(sqrtN));
	for (int i = 0; i < GRIDDIM(sqrtN); res_operations[i] = 1,i++);

	uint64_t *dev_possibles_premiers;
	cudaMalloc((void**)&dev_possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers));
	unsigned int *dev_res_operations;
	cudaMalloc((void**)&dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN));


	cudaMemcpy(dev_possibles_premiers, possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers), cudaMemcpyHostToDevice);
       	cudaMemcpy(dev_res_operations, res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyHostToDevice);
	isPrime<<<GRIDDIM(sqrtN),BLOCKDIM,SIZEMEM>>>(dev_possibles_premiers, dev_res_operations, N, sqrtN);
	cudaMemcpy(res_operations, dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyDeviceToHost);

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
	
    	uint64_t N = UINT64_T_PRIME;
	uint64_t sqrtN = sqrt(N) + 1;
	uint64_t nombresDePossiblesPremiers = N-2;

	uint64_t *possibles_premiers = (uint64_t*)malloc(sizeof(uint64_t) * (nombresDePossiblesPremiers));
	for (int i = 0, j = 2.0; j < N; possibles_premiers[i] = j,i++,j++);
	unsigned int *res_operations = (unsigned int*)malloc(sizeof(unsigned int) * GRIDDIM(sqrtN));
	for (int i = 0; i < GRIDDIM(sqrtN); res_operations[i] = 1,i++);

	uint64_t *dev_possibles_premiers;
	cudaMalloc((void**)&dev_possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers));
	unsigned int *dev_res_operations;
	cudaMalloc((void**)&dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN));


	cudaMemcpy(dev_possibles_premiers, possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers), cudaMemcpyHostToDevice);
       	cudaMemcpy(dev_res_operations, res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyHostToDevice);
	isPrime<<<GRIDDIM(sqrtN),BLOCKDIM,SIZEMEM>>>(dev_possibles_premiers, dev_res_operations, N, sqrtN);
	cudaMemcpy(res_operations, dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyDeviceToHost);

    	mAssert("isPrimeGPU(\tdev_possibles_diviseurs\n\tdev_resOperations\n\tUINT64_T_PRIME\n\ttaille)\n",
		res_operations[0] == 1,
		"Le nombre premier n'a pas été reconnu comme tel.\n");
	
	cudaFree(dev_possibles_premiers);
	cudaFree(dev_res_operations);
	free(possibles_premiers);
	free(res_operations);

    std::cout << "Le nombre premier a été reconnu : succès." << std::endl << std::endl;

}

/**
 * \brief   Tester si un nombre non premier assez grand (tenant sur un UINT64_T) n'est  pas reconnu
 *          comme un nombre premier par notre fonction.
 */
void testIfNonPrimeIsNotAssertedWithALargeUint64PrimeNumberOnGPU(){
    std::cout << "Tester si un nombre non premier tenant sur un UINT64_T n'est pas reconnu comme tel." << std::endl;
	
    	uint64_t N = UINT64_T_PRIME-1;
	uint64_t sqrtN = sqrt(N) + 1;
	uint64_t nombresDePossiblesPremiers = N-2;

	uint64_t *possibles_premiers = (uint64_t*)malloc(sizeof(uint64_t) * (nombresDePossiblesPremiers));
	for (int i = 0, j = 2.0; j < N; possibles_premiers[i] = j,i++,j++);
	unsigned int *res_operations = (unsigned int*)malloc(sizeof(unsigned int) * GRIDDIM(sqrtN));
	for (int i = 0; i < GRIDDIM(sqrtN); res_operations[i] = 1,i++);

	uint64_t *dev_possibles_premiers;
	cudaMalloc((void**)&dev_possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers));
	unsigned int *dev_res_operations;
	cudaMalloc((void**)&dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN));


	cudaMemcpy(dev_possibles_premiers, possibles_premiers, sizeof(uint64_t) * (nombresDePossiblesPremiers), cudaMemcpyHostToDevice);
       	cudaMemcpy(dev_res_operations, res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyHostToDevice);
	isPrime<<<GRIDDIM(sqrtN),BLOCKDIM,SIZEMEM>>>(dev_possibles_premiers, dev_res_operations, N, sqrtN);
	cudaMemcpy(res_operations, dev_res_operations, sizeof(unsigned int) * GRIDDIM(sqrtN), cudaMemcpyDeviceToHost);

    	mAssert("isPrimeGPU(\tdev_possibles_diviseurs\n\tdev_resOperations\n\tUINT64_T_PRIME-1\n\ttaille)\n",
		res_operations[0] == 0,
		"Le nombre non premier a été reconnu comme un nombre premier.\n");

	cudaFree(dev_possibles_premiers);
	cudaFree(dev_res_operations);
	free(possibles_premiers);
	free(res_operations);


    std::cout << "Le nombre non premier n'a pas été reconnu : succès " << std::endl
    << std::endl;
}

void testIfPrimesBetween0and100AreComputedOnGPU(){
    std::cout << "Tester la récupération des nombres premiers entre 0 et 100." << std::endl;

	vector<uint64_t> controlPrimeSet = getPrimesFrom0to100FromControlPrimeSetFile();

	uint64_t borne_sup = 100;
	uint64_t *possibles_premiers = (uint64_t*)malloc(sizeof(uint64_t)*(borne_sup-2));
	for(int i = 0; i < (borne_sup-2); possibles_premiers[i] = i+2, i++);
	uint64_t *square_roots = (uint64_t*)malloc(sizeof(uint64_t)*(borne_sup-2));
	for(int i = 0; i < (borne_sup-2); square_roots[i] = sqrt(i+2), i++);
	uint64_t *premiers = (uint64_t*)malloc(sizeof(uint64_t)*(borne_sup-2));
	for(int i = 0; i < (borne_sup-2); premiers[i] = 0, i++);

	if (VERBOSE) {
		cout << "Afficher les données initialisées " << endl;
		cout << "possibles premiers ";
		for (int i = 0; i < (borne_sup-2); i++){
			cout << "[" << possibles_premiers[i] << "]";
		}
		cout << endl << endl;
		
		cout << "square_roots ";
		for (int i = 0; i < (borne_sup-2); i++){
			cout << "[" << square_roots[i] << "]";
		}
		cout << endl << endl;
		
		cout << "premiers ";
		for (int i = 0; i < (borne_sup-2); i++){
			cout << "[" << premiers[i] << "]";
		}
		cout << endl << endl;

		cout << "Fin affichage des données initialisées" << endl;
	}


	uint64_t *dev_possibles_premiers;
	uint64_t *dev_square_roots;
	uint64_t *dev_premiers;

	cudaMalloc((void**)&dev_possibles_premiers,sizeof(uint64_t)*(borne_sup-2));
	cudaMalloc((void**)&dev_square_roots,sizeof(uint64_t)*(borne_sup-2));
	cudaMalloc((void**)&dev_premiers,sizeof(uint64_t)*(borne_sup-2));
	
	cudaMemcpy(dev_possibles_premiers, possibles_premiers, sizeof(uint64_t)*(borne_sup-2), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_square_roots, square_roots, sizeof(uint64_t)*(borne_sup-2), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_premiers, premiers, sizeof(uint64_t)*(borne_sup-2), cudaMemcpyHostToDevice);

	searchPrimeGPU<<<GRIDDIM(borne_sup-2),BLOCKDIM,SIZEMEM>>>(
			dev_possibles_premiers, 
			dev_square_roots, 
			borne_sup, 
			dev_premiers);

	cudaMemcpy(premiers, dev_premiers, sizeof(uint64_t)*(borne_sup-2), cudaMemcpyDeviceToHost);

	if (VERBOSE) {
		cout << "Affichage du tableau premiers après calcul GPU" << endl;
		for (int i = 0; i < borne_sup-2; i++){
			cout << "[" << i+2 << "," << premiers[i] << "]";
		}
		cout << endl << "Fin Affichage" << endl << endl; 
	}

    // Début Assertions

	int nombresDePremiers = 0;
	for(int i = 0; i < (borne_sup-2); i++){
		if (premiers[i] != 0)
			nombresDePremiers++;
	}
	uint64_t premiers_packed[nombresDePremiers];
	for (int i = 0; i < nombresDePremiers; i++){
		int j = 0;

		while (premiers[j] == 0 && j < (borne_sup-2))
			j++;
		premiers_packed[i] = (j+2);
		premiers[j] = 0;
	}

	if (VERBOSE)

        {
		printf("Liste de nombres premiers récupérés du GPU : \n");
		for (int i = 0; i < nombresDePremiers; i++){
			printf("[%lld]", premiers_packed[i]);
		}

		printf("\n\nListe des nombres premiers récupérés du témoin : \n");
		for (int i = 0; i < controlPrimeSet.size(); i++){
			printf("[%lld]", controlPrimeSet.at(i));
		}
	}

    mAssert("controlPrimeSet.size() == nombresDePremiers",
            controlPrimeSet.size() == nombresDePremiers,
            string("La fonction ne renvoit pas le même nombre de nombres premiers que dans le groupe de controle.\n")
            + string("controlPrimeSet.size() = ") + std::to_string(controlPrimeSet.size()) +
            string("\nprimesNumberFrom0to100.size() = ") + std::to_string(nombresDePremiers)
            + string("\n")
    );

    for (int i = 0; i < controlPrimeSet.size(); i++){
        mAssert("controlPrimeSet.at(i) == primesNumberFrom0to100.at(1)",
                controlPrimeSet.at(i) == premiers_packed[i],
                ("On ne retrouve pas le " + std::to_string(i) + "ème nombre premier.")
                );
    }

    std::cout << "On retrouve bien tout les nombres premiers compris dans l'interval : Succès." << std::endl;


	// appeler le tes Fact  en profitant  de la liste des premiers 
       testIfNumberIsFactorized(premiers_packed,nombresDePremiers);

}



void  testIfNumberIsFactorized(uint64_t *primes,int taille)
{


        uint64_t N=100;
	cell cinq;
	cinq.base=5;
	cinq.expo=2;
	cell deux;
	deux.base=2;
	deux.expo=2;
        cell  *facteurs=(cell*)malloc(sizeof(cell)*taille);
	// on remplie le tableua de cell avec l'ensemble des nombres premiers tous avec un exposant de 0 
	for(int i =0 ; i<taille; facteurs[i].base=primes[i],facteurs[i].expo=0,i++);

	uint64_t *dev_primes;
	cell *dev_facteurs;
	
	cudaMalloc((void**)&dev_primes,sizeof(uint64_t)*taille);
        cudaMalloc((void**)&dev_facteurs,sizeof(cell)*taille);
       
	cudaMemcpy(dev_primes,primes,sizeof(uint64_t)*taille,cudaMemcpyHostToDevice);
	cudaMemcpy(dev_facteurs,facteurs,sizeof(cell)*taille,cudaMemcpyHostToDevice);
     
      uint64_t *val;
      
     cudaMallocManaged(&val,sizeof(uint64_t));
     *val=N;
     while(*val!=1)
      {
           N=*val;
          // printf("val: {%lld} ",N);
           factGPU<<<GRIDDIM(taille),BLOCKDIM>>>(N,dev_primes,dev_facteurs,taille,val);
           cudaDeviceSynchronize();
      } 
	cudaMemcpy(facteurs,dev_facteurs,sizeof(cell)*taille,cudaMemcpyDeviceToHost);

	cell cinq_;
        cell deux_;
        cinq_.base=5;
      
        deux_.base=2;
        for(int i=0 ; i< taille ; i++)
	{

	cout << " :  "<< facteurs[i].base <<"^"<<facteurs[i].expo<<endl<<endl;

		if(facteurs[i].base==cinq_.base)
		{cinq_.expo=facteurs[i].expo;}

		if(facteurs[i].base==deux_.base)
		{deux_.expo=facteurs[i].expo;}
	}


      	 mAssert("l'exposant de la base cinq  ",
               cinq.expo==cinq_.expo,
              "la base cinq n'as pas le bon exposant  ");

	mAssert("l'exposant de la base deux ",
		deux.expo==deux_.expo,
		"la base deux n'a pas le bon exposant");

	cout<<" La factorisation a bien focntionnée : Succès "<<endl<<endl;
	
}
	
		
