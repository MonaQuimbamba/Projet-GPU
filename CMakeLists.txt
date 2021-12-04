cmake_minimum_required(VERSION 3.10)

project(ProjetGPU LANGUAGES CUDA CXX)

set(CMAKE_CUDA_STANDARD 14)

add_executable(PrimeBreaker
      	utils/chronoGPU.cu
	utils/chronoCPU.cpp
	helper.cpp
	primeBreakerCPU.cpp
	primeBreaker.cu
	TestPrimeBreakerGPU.cu
	main.cu
	)
