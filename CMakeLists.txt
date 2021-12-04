cmake_minimum_required(VERSION 3.10)

project(ProjetGPU CUDA)

set(CMAKE_CUDA_STANDARD 14)

add_executable(PrimeBreaker
      	utils/chronoGPU.cu
	Reference.cpp
	helper.cpp
	primeBreaker.cu
	main.cu
	)
