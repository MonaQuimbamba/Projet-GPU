main:
		nvcc -o main main.cu Reference.cpp primeBreakerCPU.cpp primeBreaker.cu utils/chronoCPU.cpp utils/chronoGPU.cu 
clear:
		rm main
