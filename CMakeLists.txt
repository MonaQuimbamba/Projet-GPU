cmake_minimum_required(VERSION 3.13)
project("PrimeBreaker")

set(CMAKE_CXX_STANDARD 14)
set(gnuplot-cpp_DIR gnuplot-cpp)
find_package(gnuplot-cpp REQUIRED)

include_directories(${gnuplot-cpp_INCLUDE_DIRS})
add_executable(PrimeBreaker
        utils/chronoCPU.cpp
        helperFunctions.cpp
        primeBreakerCPU.cpp
        TestPrimeBreaker.cpp
        sampling.cpp
        benchmark.cpp
        main.cpp
        )
