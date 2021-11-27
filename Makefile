main:
		nvcc -cudart shared -o main main.cu primeBreakerCPU.cpp primeBreaker.cu utils/chronoCPU.cpp utils/chronoGPU.cu
clear:
		rm main
