############################################
# preamble
############################################

cmake_minimum_required(VERSION 3.22)

project(patex)
include(CTest)
set(VERSION 0.0.6)


############################################
# c++ std
############################################

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)


############################################
# debug mode produces libs with d suffix
############################################

if(NOT CMAKE_DEBUG_POSTFIX)
  set(CMAKE_DEBUG_POSTFIX d)
endif()


############################################
# basic dependecies
############################################

option(WITH_TEST "run tests (default:off)" ON)
if(WITH_TEST)
find_package(GTest REQUIRED)
endif()

find_package(EXPAT)
Message("EXPAT: " ${EXPAT_INCLUDE_DIR})


############################################
# clang support
############################################

set(LINKERFLAGS "")
set(STDLIB "")
set(FLAGS "")

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(STDLIB "c++abi")
    set(LINKERFLAGS "-stdlib=libc++ -fcoroutines-ts")
    set(FLAGS "-stdlib=libc++ -fcoroutines-ts ")
endif()


############################################
# OS support (Linux/Windows)
############################################

IF (WIN32)

	set(OSLIBS "Ws2_32" "Rpcrt4")

	set(BUILDFLAGS "${FLAGS}")

#	find_library(EXPAT_LIBRARY NAMES libexpat)
#	set(LIBS ${CMAKE_PROJECT_NAME} ${GTEST_LIBRARIES} ${EXPAT_LIBRARY} ${OPENSSL_LIBRARIES} ${STDLIB}  )
	set(LIBS ${CMAKE_PROJECT_NAME} expat ${GTEST_LIBRARIES} ${STDLIB}  )


#	set(LIBS  ${CMAKE_PROJECT_NAME} ${LIBS} )


 ELSEIF (UNIX)

    set(OSLIBS "pthread" "uuid")

    set(BUILDFLAGS " ${FLAGS}")

	set(LIBS ${GTEST_LIBRARIES} expat ${STDLIB}  )

	set(LIBS ${CMAKE_PROJECT_NAME} ${LIBS} )

ENDIF ()

############################################
# set linker and compiler flags
############################################

set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${LINKERFLAGS}" )
set(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG} -DMOL_PROMISE_DEBUG")
set(CMAKE_CXX_FLAGS  	    "${CMAKE_CXX_FLAGS} ${BUILDFLAGS}")


############################################
# include directories
############################################

#Message("INCLUDES: "${EXPAT_INCLUDE_DIR})

include_directories(include)
#include_directories(${EXPAT_INCLUDE_DIR})

#if(WITH_TEST)
#include_directories(${GTEST_INCLUDE_DIR})
#endif()

############################################
# sources
############################################


file(GLOB SOURCES "src/*.cpp")
file(GLOB HEADERS "include/patex/*.h")

############################################
# lib target
############################################

add_library(patex STATIC ${SOURCES})

if(WITH_TEST)
############################################
# tests
############################################

add_executable(Tests t/xml.cpp)


############################################
# libs for tests
############################################

target_link_libraries(Tests ${LIBS} ${OSLIBS} )


############################################
# run tests
############################################


add_test(NAME AllTests COMMAND Tests)


endif() 


############################################
# install
############################################

install(TARGETS patex DESTINATION lib EXPORT patex-targets)
install(DIRECTORY include/patex DESTINATION include)
install(FILES patex.pc DESTINATION lib/pkgconfig)
install(EXPORT patex-targets DESTINATION lib/patex-${VERSION})


############################################
# Create and install package configuration 
# and version files.
############################################

configure_file(
   ${patex_SOURCE_DIR}/patex-config.cmake.in
   ${patex_BINARY_DIR}/patex-config.cmake @ONLY)

configure_file(
   ${patex_SOURCE_DIR}/patex-config-version.cmake.in
   ${patex_BINARY_DIR}/patex-config-version.cmake @ONLY)

install(FILES ${patex_BINARY_DIR}/patex-config.cmake
         ${patex_BINARY_DIR}/patex-config-version.cmake
         DESTINATION lib/patex-${VERSION})

