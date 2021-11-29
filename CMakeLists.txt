cmake_minimum_required(VERSION 3.20)
project(Projet_GPU)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(Projet_GPU
        main.cpp
        primeBreakerCPU.cpp
        utils/chronoCPU.cpp
        TestPrimeBreaker.cpp
        )
