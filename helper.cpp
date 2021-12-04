#include "helper.hpp"

// TODO : Commenter
void printUsage( const char *prg )
{
    cerr	<< "Usage: " << prg << endl
            << " \t N "
            << endl << endl;
    exit( EXIT_FAILURE );
}

// TODO : Commenter
string printPrimes(std::vector<uint64_t> primeNumbers)
{
    string res =  "Nombres premiers : \n " ;

    for(int i =0 ; i < primeNumbers.size() ; i++)
    {
        res += "[" + std::to_string(primeNumbers.at(i)) + "]";
    }
    return res;
}

// TODO : Commenter
string printFacteurs(vector<cell> facteurs )
{
    string res = "Les Facteurs premiers :  \n ";
    for(int i = 0 ; i < facteurs.size(); i++)
    {
        string cell = to_string(facteurs.at(i).base)+"^"+to_string(facteurs.at(i).expo);
        res+= (i==facteurs.size()-1) ? ""+cell : cell+"*" ;
    }
    return res;
}
