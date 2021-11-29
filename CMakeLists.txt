cmake_minimum_required(VERSION 3.10)

project(ProjetGPU)

set(CMAKE_CXX_STANDARD 14)

add_executable(PrimeBreaker
        main.cpp
        primeBreakerCPU.cpp
        TestPrimeBreaker.cpp)