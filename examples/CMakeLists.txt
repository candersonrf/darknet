cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
project(examples LANGUAGES CXX CUDA)

add_definitions(-DGPU -DCUDNN)

if (NOT CUDA_ARCH)
  set(CUDA_ARCH "sm_52")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-unused-result -Wno-unknown-pragmas -Wfatal-errors")

message("Targeting Cuda architecture : ${CUDA_ARCH}")

set(CUDA_NVCC_FLAGS "-arch=${CUDA_ARCH};--maxrregcount=30;-lineinfo;" CACHE STRING "nvcc flags" FORCE)
set (CUDA_VERBOSE_BUILD ON CACHE BOOL "nvcc verbose" FORCE)

include_directories(${INCLUDE_DIRS} ../include ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES})
link_directories(${CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES})

file(GLOB SRC_LIST *.cpp *.cc *.c)
file(GLOB HDR_LIST *.h *.hpp)

set(SRC_LIST  captcha.c lsd.c super.c art.c tag.c cifar.c go.c 
              rnn.c segmenter.c regressor.c classifier.c coco.c 
              yolo.c detector.c nightmare.c instance-segmenter.c darknet.c)

add_executable(${PROJECT_NAME} ${SRC_LIST} ${HDR_LIST})

target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_11)
set_target_properties(${PROJECT_NAME} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)

# Set output name to "darknet"
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "darknet")

# link to libdarknet.so
set(EXTRA_LIBS ${EXTRA_LIBS} darknet pthread m cudnn cublas curand)
target_link_libraries(${PROJECT_NAME} ${EXTRA_LIBS} )

