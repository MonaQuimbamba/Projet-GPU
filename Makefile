main:
		nvcc -o main main.cu helperFunctions.cpp primeBreakerCPU.cpp primeBreaker.cu utils/chronoCPU.cpp utils/chronoGPU.cu 
clear:
		rm main
