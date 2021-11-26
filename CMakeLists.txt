cmake_minimum_required(VERSION 3.20)
project(Projet_GPU)

set(CMAKE_CUDA_STANDARD 14)

include_directories(.)

add_executable(Projet_GPU
        main.cu
        primeBreakerCPU.cpp
        utils/chronoCPU.cpp
        utils/chronoGPU.cu
        TestPrimeBreaker.cpp
        primeBreaker.cu
        )
