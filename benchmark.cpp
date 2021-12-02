#include "gnuplot_i.hpp" // GnuPlot
#include "benchmark.h"

void drawPlotForPrimalityTestAlgorithms(Gnuplot gnuplot);
void drawPlotForResearchOfPrimes(Gnuplot gnuplot);
void drawPlotForPrimesFactorisation(Gnuplot gnuplot);

using namespace boost;

/** \brief  Je suis une fonction qui vient enrouler les fonctions de créations de
 *          graphes de visualisation des performances des algorithmes.
 */
void generatePlots()
{
    Gnuplot gnuplot;

    //drawPlotForPrimalityTestAlgorithms(gnuplot);
    //drawPlotForResearchOfPrimes(gnuplot);
    drawPlotForPrimesFactorisation(gnuplot);
}

/** \brief  Je suis une fonction qui fait des mesures de temps pour analyser les performances
 *          des algorithmes de calcul de la primalité d'un nombre.
 *          (temps/s)
 *          ^
 *          |
 *          |
 *          |______________> (log2(N)) N e [[4;35]]
 *
 */
void drawPlotForPrimalityTestAlgorithms(Gnuplot gnuplot)
{
    boost::tuple<vector<float>, vector<uint64_t>> datas = createPrimalityTestsDatas(); // (T_x,T_y)

    gnuplot.reset_plot();
    cout << endl << endl << "*** Graphe pour le test de Primalité ***" << endl;
    gnuplot.set_grid();
    gnuplot.set_style("lines")
    .plot_xy(
            datas.tail.head,
            datas.head,
             "Mesure de temps (en ms) pour un nombre binaire de N bits"
             );
    wait_for_key();
}

/** \brief  Je suis une fonction qui fait des mesures de temps pour analyser les performances
 *          des algorithmes de recherches de nombres premiers.
 *          (temps/s)
 *          ^
 *          |
 *          |
 *          |________________> log2(N) [[4;18[ ~60 pour N = 17 sur Macbook Pro A1502
 */
void drawPlotForResearchOfPrimes(Gnuplot gnuplot)
{
    boost::tuple<vector<float>, vector<uint64_t>> datas = createResearchOfPrimesDatas(); // (T_x,T_y)

    gnuplot.reset_plot();
    cout << endl << endl << "*** Graphe pour la recherche de nombres premiers ***" << endl;
    gnuplot.set_grid();
    gnuplot.set_style("lines")
            .plot_xy(
                    datas.tail.head,
                    datas.head,
                    "Mesure de temps (en ms) pour une borne superieure N."
            );
    wait_for_key();
}

/** \brief  Je suis une fonction qui fait des mesures de temps pour analyser les performances
 *          des algorithmes de factorisation en nombres premiers.
 *          (temps/s)
 *          ^
 *          |
 *          |
 *          |___________________> N Un nombre entier
 */
void drawPlotForPrimesFactorisation(Gnuplot gnuplot)
{
    boost::tuple<vector<float>, vector<uint64_t>> datas = createPrimeFactorisationDatas(); // (T_x,T_y)

    gnuplot.reset_plot();
    cout << endl << endl << "*** Graphe pour la Factorisation en Nombres Premiers ***" << endl;
    gnuplot.set_grid();
    gnuplot.set_style("lines")
            .plot_xy(
                    datas.tail.head,
                    datas.head,
                    "Mesure de temps (en ms) pour un entier N."
            );
    wait_for_key();
}

void wait_for_key()
{
 cout << endl << "Appuyez sur une touche pour continuer." << endl;
 std::cin.clear();
 std::cin.ignore(std::cin.rdbuf()->in_avail());
 std::cin.get();
}