/*
* file with all function on CPU
*/
 #include <stdint.h>
 
#ifndef __PRIMEBREAKERCPU_HPP
#define __PRIMEBREAKERCPU_HPP


/*
   Cette fonction va  tester la primalité d’un nombre de
  - L’algorithme consiste à vérifier pour un nombre N, si tous les nombres inférieurs ne le divisent pas
*/
bool isPrimeCPU(const uint64_t N);
/*
   Cette fonction permet de rechercher des nombres premiers inférieurs à N.
  - L’algorithme consiste à tester la primalité de tous les nombres inférieurs à N à l’aide de la fonction précédente.
	 Il faut savoir que l’on ne peut connaître la taille de la liste renvoyée à l’avance.
	 donc trouver une solution (structure de données dynamique, gestion de la mémoire manuelle, taille fixée, etc.).
*/
void searchPrimesCPU(const uint64_t N);

/*
	Cette fonction va faire la décomposition en facteurs premiers
	 - Le principe de la décomposition consiste à parcourir les nombres p de la liste des nombres premiers
	trouvés avant en testant si ce nombre p divise N. Si oui, on recommence l’algorithme avec N = N/p.
	On s’arrête quand le nombre premier à tester devient supérieur à la racine carrée de N.
*/
void factoCPU(uint64_t N);



#endif