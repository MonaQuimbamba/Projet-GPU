#include "sampling.h"

/** \brief  Je suis une foncton qui aggrège les mesures de
 *          nos tests de performances pour une création de
 *          graphes ultérieure avec GnuPlot.
 * @return boost::tuple<vector<float>,vector<int>> couple de (Tableau de Mesures de temps, Tableau de Logarithme en base 2 des échantillons).
 *
boost::tuple<vector<float>,vector<uint64_t>>
createPrimalityTestsDatas()
{
    vector<uint64_t> samples = generatePrimalityTestsSamples();
    vector<float> timeMeasurements = generatePrimalityTestsMeasurement(samples);

    for (uint64_t log2Samples = 4,
            i = 0;
            i < LOG2MAX_ISP-4;
            log2Samples++,
            i++){
        /// Après la mesure des échantillons, remplacer les
        /// échantillons dans le tableau d'échantillons par
        /// leur logarithme en base 2.
        samples.at(i) = log2Samples;
    }

    return boost::tuple<vector<float>, vector<uint64_t>>{timeMeasurements,samples};
}
*/

/** \brief  Je suis une fonction qui génère des nombres
 *          avec une longeur allant de 4 à 35 bits.
 *  @return vector<uint64_t> Les échantillons.
 */
vector<uint64_t> generatePrimalityTestsSamples() {
    vector<uint64_t> res(0);

    for (   uint64_t currentSample = 0b1000,
            i = 4;
            i < LOG2MAX_ISP;
            currentSample <<= 1,
            i++
    ) {
        res.push_back(currentSample);
    }

    return res;
}

/** \brief  Je suis une fonction qui crée les mesures de tests de temps pour
 *          l'algorithme de tests de primalitée pour un tableau d'échantillons donné.
 *
 *  @param  samples Les échantillons sur lesquels effectuer la mesure.
 *  @return vector<float> Les mesures de temps.
 */
 vector<float> generatePrimalityTestsMeasurement(vector<uint64_t> samples){
     vector<float> res(0);
     for (int i = 0; i < samples.size(); i++){
         ChronoCPU *currentChrono = new ChronoCPU();
         currentChrono->start();
         isPrimeCPU_v0(samples.at(i));
         currentChrono->stop();
         res.push_back(currentChrono->elapsedTime());
         delete currentChrono;
     }
     return res;
 }

/** \brief  Je suis une fonction qui aggrège les mesures de
*          nos tests de performances de la recherche de nombre premiers
*          pour une création de graphes ultérieure avec GnuPlot.
* @return boost::tuple<vector<float>,vector<int>> couple de (Tableau de Mesures de temps, Tableau de Logarithme en base 2 des échantillons).
*
boost::tuple<vector<float>,vector<uint64_t>>
createResearchOfPrimesDatas()
{
    vector<uint64_t> limits = generateResearchOfPrimesLimits();
    vector<float> timeMeasurements = generateResearchOfPrimesMeasurement(limits);

    for (uint64_t log2Samples = 2,
                 i = 0;
         i < LOG2MAX_ROP-4;
         log2Samples++,
                 i++){
        /// Après la mesure des échantillons, remplacer les
        /// échantillons dans le tableau d'échantillons par
        /// leur logarithme en base 2.
        limits.at(i) = log2Samples;
    }

    return boost::tuple<vector<float>, vector<uint64_t>>{timeMeasurements,limits};
}
*/

/** \brief  Je suis une fonction qui génère des puissances de 2.
 *  @return vector<uint64_t> Les échantillons.
 */
vector<uint64_t> generateResearchOfPrimesLimits() {
    vector<uint64_t> res(0);

    for (   uint64_t currentSample = 0b1000,
                    i = 4;
            i < LOG2MAX_ROP;
            currentSample <<= 1,
                    i++
            ) {
        res.push_back(currentSample);
    }

    return res;
}

/** \brief  Je suis une fonction qui crée les mesures de tests de temps pour
 *          l'algorithme de tests de primalitée pour un tableau d'échantillons donné.
 *
 *  @param  samples Les échantillons sur lesquels effectuer la mesure.
 *  @return vector<float> Les mesures de temps.
 */
vector<float> generateResearchOfPrimesMeasurement(vector<uint64_t> limits){
    vector<float> res(0);
    for (int i = 0; i < limits.size(); i++){
        ChronoCPU *currentChrono = new ChronoCPU();
        currentChrono->start();
        searchPrimesCPU_v0(limits.at(i));
        currentChrono->stop();
        res.push_back(currentChrono->elapsedTime());
        delete currentChrono;
    }
    return res;
}


/** \brief  Je suis une fonction qui aggrège les mesures de
*          nos tests de performances de la recherche de nombre premiers
*          pour une création de graphes ultérieure avec GnuPlot.
* @return boost::tuple<vector<float>,vector<int>> couple de (Tableau de Mesures de temps, Tableau de Logarithme en base 2 des échantillons).
*
boost::tuple<vector<float>,vector<uint64_t>>
createPrimeFactorisationDatas()
{
    vector<uint64_t> samples = generatePrimeFactorisationSamples();
    vector<float> timeMeasurements = generatePrimeFactorisationMeasurement(samples);

    return boost::tuple<vector<float>, vector<uint64_t>>{timeMeasurements,samples};
}
*/

/** \brief  Je suis une fonction qui génère des puissances de 2.
 *  @return vector<uint64_t> Les échantillons.
 */
vector<uint64_t> generatePrimeFactorisationSamples() {
    vector<uint64_t> res(0);
    int limit = 40000;
    double step = limit/25;

    for (
            int i = 10;
            i < limit;
            i+=step){
        res.push_back(i);
    }

    return res;
}

/** \brief  Je suis une fonction qui crée les mesures de tests de temps pour
 *          l'algorithme de tests de primalitée pour un tableau d'échantillons donné.
 *
 *  @param  samples Les échantillons sur lesquels effectuer la mesure.
 *  @return vector<float> Les mesures de temps.
 */
vector<float> generatePrimeFactorisationMeasurement(vector<uint64_t> samples){
    vector<float> res(0);
    for (int i = 0; i < samples.size(); i++){
        ChronoCPU *currentChrono = new ChronoCPU();
        vector<cell> factors(0);
        currentChrono->start();
        factoCPU(samples.at(i), &factors);
        currentChrono->stop();
        res.push_back(currentChrono->elapsedTime());
        delete currentChrono;
    }
    return res;
}
