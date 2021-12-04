cmake_minimum_required(VERSION 3.10)

giproject(ProjetGPU)

set(CMAKE_CXX_STANDARD 14)

add_executable(PrimeBreaker
        utils/chronoCPU.cpp
        primeBreakerCPU.cpp
        TestPrimeBreaker.cpp
        main.cpp
        helperFunctions.cpp)