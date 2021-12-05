#ifndef __TESTPRIMEBREAKERGPU__H
#define __TESTPRIMEBREAKERGPU__H

#define GRIDDIM(X) ((X+BLOCKDIM-1)/BLOCKDIM)
#define SIZEMEM(X) (BLOCKDIM * sizeof(unsigned int))
#define BLOCKDIM 256
#define UINT32_T_PRIME 214748357
#define UINT64_T_PRIME 214767739

#include "helper.hpp" // cell, booléens de niveau d'affichage du débug, mAssert
#include "primeBreaker.hpp"
#include <stdint.h> // uint64_t, uint32_t
#include <iostream> // cout, endl
#include <fstream> // ifstream
#include <string> // string
#include <vector> // vector<T>
#include <cstdlib> // strtoull
#include <sstream> // stringstream
#include <cmath> // sqrt
#include <cstring> // memset
#include <cstdlib> // malloc

void launchUnitTestGPU();
void testIfNonPrimeIsNotAssertedWithAIntegerPrimeNumberOnGPU();
void testIfPrimeIsAssertedWithAIntegerPrimeNumberOnGPU();
void testIfPrimeIsAssertedWithALargeUint64PrimeNumberOnGPU();
void testIfNonPrimeIsNotAssertedWithALargeUint64PrimeNumberOnGPU();

#endif
