# Minimum CMake version 3.18 for CUDA --std=c++17 
cmake_minimum_required(VERSION VERSION 3.18 FATAL_ERROR)
# Add cmake/modules to CMAKE MODULES APTH
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/modules/ ${CMAKE_MODULE_PATH})


# Set the proejct name and laguages
project(cub-segmented-sort-test LANGUAGES CXX CUDA)


# Set a recent C++ standard supported by CUDA
# Specify using C++11 standard
if(NOT DEFINED CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED true)
endif()
if(NOT DEFINED CMAKE_CUDA_STANDARD)
    set(CMAKE_CUDA_STANDARD 17)
    set(CMAKE_CUDA_STANDARD_REQUIRED true)
endif()

# Use the CUDA Toolkit package
find_package(CUDAToolkit REQUIRED)
# Set shared cudart
set(CMAKE_CUDA_RUNTIME_LIBRARY shared)

# Specify cache variables which can be used to fetch an alternate version of Thrust/CUB for testing purposes
set(THRUST_TAG "1.15.0" CACHE STRING "Thrust git tag / branch / hash to fetch")
set(THRUST_REMOTE "https://github.com/NVIDIA/thrust.git" CACHE STRING "Thrust repository to use.")

message(STATUS "Using Thrust ${THRUST_TAG} from ${THRUST_REMOTE}")

include(FetchContent)
cmake_policy(SET CMP0079 NEW)

# Fetch Thrust and find it, using the fetched version rather than a system installed version ideally.
FetchContent_Declare(
    thrust
    GIT_REPOSITORY ${THRUST_REMOTE}
    GIT_TAG        ${THRUST_TAG}
    GIT_SHALLOW    1
    GIT_PROGRESS   ON
    # UPDATE_DISCONNECTED   ON
)
FetchContent_GetProperties(thrust)
if(NOT thrust_POPULATED)
    # Fetch thrust
    FetchContent_Populate(thrust)
    # Find it, with some workarounds for windows / symlinks (might not be required for recent enough cub)
    set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${thrust_SOURCE_DIR}/thrust/cmake")
    set(EXPECTED_CUB_CONFIG_LOCATION "${thrust_SOURCE_DIR}/cub/cmake/")
    if(EXISTS "${EXPECTED_CUB_CONFIG_LOCATION}" AND NOT CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        # Use the symlinked "default" location
        set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${thrust_SOURCE_DIR}/cub/cmake")
    else()
        # Otherwise, use the non-symlinked location.
        set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${thrust_SOURCE_DIR}/dependencies/cub/cub/cmake/")
    endif()
endif()
# Use find_package for thrust and cub, which are required.
find_package(Thrust REQUIRED CONFIG)
find_package(CUB REQUIRED CONFIG)


# Fetch and find Jitify, it seems to be involved.
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/modules/ ${CMAKE_MODULE_PATH})
include(FetchContent)
cmake_policy(SET CMP0079 NEW)

# Change the source-dir to allow inclusion via jitify/jitify.hpp rather than jitify.hpp
FetchContent_Declare(
    jitify
    GIT_REPOSITORY https://github.com/NVIDIA/jitify.git
    GIT_TAG        00232c873704f53dbdec92ad8656f2cc3b1a4067
    SOURCE_DIR     ${FETCHCONTENT_BASE_DIR}/jitify-src/jitify
    GIT_PROGRESS   ON
    # UPDATE_DISCONNECTED   ON
)
FetchContent_GetProperties(jitify)
if(NOT jitify_POPULATED)
    FetchContent_Populate(jitify)
    # Jitify is not a cmake project, so cannot use add_subdirectory, use custom find_package.
endif()

set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${jitify_SOURCE_DIR}/..")
# Always find the package, even if jitify is already populated.
find_package(Jitify REQUIRED)


######
# Target with jitify **before** cub, this will error
# Add the executable with its source
add_executable(jitify-before-cub src/jitify-before-cub.cu)

target_link_libraries(jitify-before-cub PUBLIC CUB::CUB)
target_link_libraries(jitify-before-cub PUBLIC Thrust::Thrust)
target_link_libraries(jitify-before-cub PUBLIC Jitify::jitify)


# Target with jitify **after** cub, this will compile
# Add the executable with its source
add_executable(jitify-after-cub src/jitify-after-cub.cu)

target_link_libraries(jitify-after-cub PUBLIC CUB::CUB)
target_link_libraries(jitify-after-cub PUBLIC Thrust::Thrust)
target_link_libraries(jitify-after-cub PUBLIC Jitify::jitify)