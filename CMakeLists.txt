############################################
# preamble
############################################

cmake_minimum_required(VERSION 3.22)

if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()

project(patex)
include(CTest)
set(VERSION 0.0.6)

option(WITH_TEST "run tests (default:off)" ON)


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

find_package(EXPAT CONFIG)


############################################
# clang support
############################################

set(LINKERFLAGS "")
set(STDLIB "")
if(WIN32)
    set(FLAGS "/W3")
else()
    set(FLAGS "-Wall -Wextra")
endif()

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

    find_package(GTest REQUIRED)

    set(LIBS ${CMAKE_PROJECT_NAME} expat::expat ${GTEST_LIBRARIES} ${STDLIB}  )

    get_target_property(expat_INCLUDE_DIR expat::expat INTERFACE_INCLUDE_DIRECTORIES)
  	include_directories(${expat_INCLUDE_DIR})

ELSEIF (UNIX)

    set(OSLIBS "pthread" "uuid")

	  set(LIBS ${CMAKE_PROJECT_NAME} expat ${STDLIB} ${LIBS} )

ENDIF ()

############################################
# set linker and compiler flags
############################################

set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${LINKERFLAGS}" )
set(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG} -DMOL_PROMISE_DEBUG")
set(CMAKE_CXX_FLAGS  	    "${CMAKE_CXX_FLAGS} ${FLAGS}")

############################################
# gtest
############################################

if(UNIX AND WITH_TEST)

  include(FetchContent)
  FetchContent_Declare(
    googletest
    # Specify the commit you depend on and update it regularly.
    URL https://github.com/google/googletest/archive/f8d7d77c06936315286eb55f8de22cd23c188571.zip
  )
  # For Windows: Prevent overriding the parent project's compiler/linker settings
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  #FetchContent_MakeAvailable(googletest)

  FetchContent_GetProperties(googletest)
  if(NOT googletest_POPULATED)
    FetchContent_Populate(googletest)
    add_subdirectory(${googletest_SOURCE_DIR} ${googletest_BINARY_DIR} EXCLUDE_FROM_ALL)
  endif()

	set( LIBS "gtest" "${LIBS}")

endif()

############################################
# include directories
############################################

include_directories(include)

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

############################################
# packaging
############################################

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
include(package)
         

