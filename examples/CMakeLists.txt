cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
project(examples LANGUAGES CXX CUDA)

message("WANT_GPU = ${WANT_GPU}, WANT_CUDNN = ${WANT_CUDNN}, "
        "WANT_OPENCV = ${WANT_OPENCV}, WANT_OPENMP = ${WANT_OPENMP}")

message("${PROJECT_NAME} targeting cuda architecture : ${CUDA_ARCH}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-unused-result -Wno-unknown-pragmas -Wfatal-errors")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-unused-result -Wno-unknown-pragmas -Wfatal-errors")

# find OpenMP and setup compiler and linker flags
if (WANT_OPENMP)
  find_package(OpenMP)
  if(OPENMP_FOUND)
    add_definitions(-DOPENMP)
    message(STATUS "OPENMP FOUND")
    message(STATUS "OpenMP_CXX_FLAGS=${OpenMP_CXX_FLAGS}")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
  endif()
endif()

if (WANT_GPU)
  add_definitions(-DGPU)
  set(CUDA_NVCC_FLAGS "-arch=${CUDA_ARCH};--maxrregcount=30;-lineinfo;" CACHE STRING "nvcc flags" FORCE)
  set (CUDA_VERBOSE_BUILD ON CACHE BOOL "nvcc verbose" FORCE)
endif()

if (WANT_CUDNN)
  add_definitions(-DCUDNN)
endif()

if (WANT_OPENCV)
  add_definitions(-DOPENCV)
  find_package(OpenCV ${OPENCV_VERSION} COMPONENTS core imgproc opencv_highgui REQUIRED HINTS ~/opencv/release)
  message("OpenCV includes = ${OpenCV_INCLUDE_DIRS}")
  message("OpenCV libs = ${OpenCV_LIBS}")
  message("OpenCV_DIR = ${OpenCV_DIR}")
endif()

include_directories(../include 
                    ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES} 
                    ${OpenCV_INCLUDE_DIRS})
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

# link to libdarknet.so and other libraries
set(EXTRA_LIBS ${EXTRA_LIBS} darknet pthread m cudnn cublas curand ${OpenCV_LIBS})
target_link_libraries(${PROJECT_NAME} ${EXTRA_LIBS} )

