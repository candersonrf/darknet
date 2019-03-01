cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
project(darknet LANGUAGES CXX CUDA)

message("WANT_GPU = ${WANT_GPU}, WANT_CUDNN = ${WANT_CUDNN}, "
        "WANT_OPENCV = ${WANT_OPENCV}, WANT_OPENMP = ${WANT_OPENMP}")

message("${PROJECT_NAME} targeting cuda architecture : ${CUDA_ARCH}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-unused-result -Wno-unknown-pragmas -Wfatal-errors")

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

include_directories(${INCLUDE_DIRS} ../include ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES})

file(GLOB C_SRC_LIST *.c)
file(GLOB CPP_SRC_LIST *.cpp *.cc)
file(GLOB CUDA_SRC_LIST *.cu)
file(GLOB HDR_LIST *.h *.hpp)
set(SRC_LIST ${C_SRC_LIST} ${CPP_SRC_LIST})

if (WANT_GPU)
  set(SRC_LIST ${C_SRC_LIST} ${CPP_SRC_LIST} ${CUDA_SRC_LIST})
endif()

# exclude certain files from the build
LIST(FILTER SRC_LIST EXCLUDE REGEX "compare.c")

# build a shared library - it will be named "lib${PROJECT_NAME}.so"
add_library(${PROJECT_NAME} SHARED ${SRC_LIST} ${HDR_LIST})

# enable C++11
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_11)

set_target_properties(${PROJECT_NAME} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)

#set(EXTRA_LIBS ${EXTRA_LIBS} cudnn)
target_link_libraries(${PROJECT_NAME} ${EXTRA_LIBS} )

