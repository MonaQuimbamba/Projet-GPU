#include "Reference.hpp"

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
