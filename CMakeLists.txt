CMAKE_MINIMUM_REQUIRED(VERSION 2.8.7 FATAL_ERROR)
PROJECT(Test)

# Required for gCov
OPTION(coverage "Built with the gCov/lcov support." OFF)

ADD_DEFINITIONS(
  -std=c++11
)

IF (coverage)
  SET(CMAKE_BUILD_TYPE Debug)

  ADD_DEFINITIONS(
    -g
    -O0
    -Wall
    -fprofile-arcs    # Required for gCov
    -ftest-coverage   # Required for gCov  
  )
ENDIF()

SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/CMakeModules ${CMAKE_MODULE_PATH})
FIND_PACKAGE(Threads)

# Following commented code will use static_crt for all targets
# IF (MSVC)
#     SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
#     SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
#     ADD_DEFINITIONS(-DUNICODE -D_UNICODE)
# ENDIF()

###############################################################################
# Title: Override option in CMake subproject
# Web: https://stackoverflow.com/questions/14061605/override-option-in-cmake-subproject
##############################################################################
OPTION(gtest_force_shared_crt "" ON)

###############################################################################
# Title: When should I use add_subdirectory and when ExternalProject
# Web: https://cmake.org/pipermail/cmake/2013-February/053429.html
###############################################################################
ADD_SUBDIRECTORY(3rd-party/googletest EXCLUDE_FROM_ALL)
INCLUDE_DIRECTORIES(3rd-party/googletest/googletest/include)
INCLUDE_DIRECTORIES(3rd-party/googletest/googlemock/include)

ADD_EXECUTABLE(MainTest ${PROJECT_SOURCE_DIR}/src/main.cpp)
TARGET_LINK_LIBRARIES(MainTest gtest gtest_main)
TARGET_LINK_LIBRARIES(MainTest ${CMAKE_THREAD_LIBS_INIT})

# Code Coverage
IF (coverage)

  # Required for gCov
  SET(CMAKE_EXE_LINKER_FLAGS "-fprofile-arcs -ftest-coverage")

  # Configure Ctest
  ENABLE_TESTING()
  ADD_TEST(NAME MainTest COMMAND MainTest)

  # Code Coverage
  IF(CMAKE_COMPILER_IS_GNUCXX OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
      INCLUDE(CodeCoverage)
      SETUP_TARGET_FOR_COVERAGE(${PROJECT_NAME}_coverage MainTest coverage)
  ENDIF()

ENDIF()

# most valuable code, following is attached with a blog
# https://github.com/kaizouman/gtest-cmake-example

# Solve the build issue on windows
# https://github.com/snikulov/google-test-examples

# This repo which includes the code coverage