# Projet-GPU

## Préambule
Les nombres premiers sont, par définition, des nombres qui sont divisibles par eux-mêmes ou par
le nombre 1. Par convention, on considère que le nombre 2 est le premier nombre premier.
L’une des méthodes les plus basiques pour tester la primalité d’un nombre est d’utiliser le crible
d’Eratosthène. L’idée de l’algorithme pour déterminer si le nombre N est premier, est de tester s’il existe
un nombre M tel que 2 ≤ M < N et M divise N (c’est-à-dire que le reste de la division euclidienne est
nulle).



Les nombres premiers s’utilisent en cryptographie à clé publique que ce soit pour chiffrer des données
ou signer des messages. L’exemple le plus connu est l’algorithme RSA dont la sécurité repose sur le
problème de la factorisation. Ainsi, décomposer efficacement des nombres en produit de facteurs de
nombres premiers devient une façon d’attaquer certains systèmes ou de rechercher des vulnérabilités.
Cette décomposition nécessite la détermination d’une liste suffisante de nombres premiers et ensuite
à tester le nombre de fois où un nombre premier divise le nombre cible. Par exemple :

• 2133 = 1 ∗ 3 3 ∗ 79 1 ; <br>
• 213 = 1 ∗ 3 1 ∗ 71 1 ; <br>
• 7 = 1 ∗ 7 1 ; <br>

Vous trouverez dans la figure 1 un exemple d’exécution de votre programme final, afin que vous
vous inspiriez fortement de l’affichage (en particulier la ligne sur les décompositions du dernier exercice,
qui sera vérifiée automatiquement) :

ATTENTION : Dans l’énoncé, on utilisera la lettre N pour représenter le nombre donné en
argument de votre programme ou devant être testé.
