#ifndef PRIMEBREAKER_SAMPLING_H
#define PRIMEBREAKER_SAMPLING_H

#define LOG2MAX_ISP 35
#define LOG2MAX_ROP 18

#include "utils/chronoCPU.hpp"
#include <cstdint> // uint64_t
#include <vector> // vector<T>
/* #include <boost/tuple/tuple.hpp> // tuple<T,T,..,T> */
#include "primeBreakerCPU.hpp" // isPrimeCPU_v0
#include "helper.hpp" // cell
#include <cmath> // pow

//using namespace boost;
using namespace std;

/*boost::tuple<vector<float>,vector<uint64_t>>
createPrimalityTestsDatas();*/
vector<uint64_t> generatePrimalityTestsSamples();
vector<float> generatePrimalityTestsMeasurement(vector<uint64_t> samples);

/*boost::tuple<vector<float>,vector<uint64_t>>
createResearchOfPrimesDatas();*/
vector<uint64_t> generateResearchOfPrimesLimits();
vector<float> generateResearchOfPrimesMeasurement(vector<uint64_t> limits);

/*boost::tuple<vector<float>,vector<uint64_t>>
createPrimeFactorisationDatas();*/
vector<uint64_t> generatePrimeFactorisationSamples();
vector<float> generatePrimeFactorisationMeasurement(vector<uint64_t> samples);

#endif //PRIMEBREAKER_SAMPLING_H
