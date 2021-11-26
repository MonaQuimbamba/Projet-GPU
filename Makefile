main:
		nvcc -o main main.cu primeBreakerCPU.cpp primeBreaker.cu utils/chronoCPU.cpp utils/chronoGPU.cu --expt-relaxed-constexpr
clear:
		rm main
