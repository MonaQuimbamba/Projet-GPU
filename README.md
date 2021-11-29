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



## 1 Consignes

Ainsi, vous allez devoir réaliser deux versions, une version CPU et une version GPU, de trois
algorithmes.

• Test de primalité : renvoie vrai si le nombre passé en paramètre est premier, faux sinon.
• Recherche de nombres premiers : renvoie une liste de nombres premiers inférieur à une borne N donnée.

• Décomposition en produit de facteurs de nombres premiers : renvoie la liste des facteurs ainsi que leur exposant.

D’un point de vue technique, il va falloir :

• Définir le type ULONGLONG comme un alias d’un entier long long non-signé ou utiliser uint64_t.

• Définir la structure struct cell qui contiendra un nombre premier ainsi que l’exposant associé pour la décomposition.

• Réutiliser les fichiers de mesure du temps déjà vus en TP (chronoGPU et chronoCPU).

• Fournir un makefile, un script ou une commande qui permet de compiler votre projet !

• Proposer une architecture logicielle cohérente.

• Tester votre programme avec des entiers plus ou moins longs. Pour cela, votre programme doit accepter en ligne de commande la valeur de N.

Le projet consiste à vous approprier ces problèmes sur les nombres premiers et mettre en pratique des solutions. S’il y a des optimisations à faire, particulièrement en CUDA, elles doivent avoir du sens et être justifiées un minimum. Important : 

six algorithmes doivent être codés obligatoirement mais vous
avez le droit de laisser les différentes versions écrites dans le code final. Cela permet de voir l’évolution
du processus d’optimisation ou de compréhension du problème. Vous pouvez ajoutez des suffixes aux
noms des fonctions pour indiquer tout cela.
