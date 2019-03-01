cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
project(darknet_all)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(WANT_OPENCV off CACHE BOOL "")
set(WANT_OPENMP off CACHE BOOL "")
set(WANT_GPU off CACHE BOOL "")
set(WANT_CUDNN off CACHE BOOL "")
set(OPENCV_VERSION "" CACHE STRING "")

if (NOT CUDA_ARCH)
  set(CUDA_ARCH "sm_52")
endif()

# projects to build
add_subdirectory(src)
add_subdirectory(examples)

