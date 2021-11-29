//
// Created by Faisal Salhi on 22/11/2021.
//

#ifndef PROJET_GPU_TESTPRIMEBREAKER_HPP
#define PROJET_GPU_TESTPRIMEBREAKER_HPP

#define LARGE_UINT64_NUMBER 322337215463
#define LARGE_UINT32_NUMBER 214748357

#include "primeBreakerCPU.hpp"
#include <cassert> // assert
#include <stdint.h> // uint64_t, uint32_t
#include <iostream> // cout, endl
#include <fstream> // ifstream
#include <string> // string
#include <vector> // vector<T>
#include <cstdlib> // strtoull
#include <sstream> // stringstream

void TestIfPrimeIsAssertedWithAIntegerPrimeNumber();
void TestIfNonPrimeIsNotAssertedWithAIntegerPrimeNumber();
void TestIfPrimeIsAssertedWithALargeUint64PrimeNumber();
void TestIfNonPrimeIsNotAssertedWithALargeUint64PrimeNumber();
void TestIfPrimesBetween0and100AreSuccessfullyRetrieved();
vector<uint64_t> getPrimesFrom0to100FromControlPrimeSetFile();
void putPrimesFromLineInOutput(string line, vector<uint64_t> *output);
vector<uint64_t> splitNumbersFromLine(string line);

#endif //PROJET_GPU_TESTPRIMEBREAKER_HPP