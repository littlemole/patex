############################################
# preamble
############################################
cmake_minimum_required(VERSION 2.8.9)
project(patex)
cmake_policy(SET CMP0054 NEW)
include(CTest)

############################################
# c++ std
############################################

set(CMAKE_CXX_STANDARD 17)
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

find_package(GTest REQUIRED)


############################################
# clang support
############################################

set(LINKERFLAGS "")
set(STDLIB "")
set(FLAGS "")

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(STDLIB "c++abi")
    set(LINKERFLAGS "-stdlib=libc++ -fcoroutines-ts  -std=c++14 ")
    set(FLAGS "-stdlib=libc++ -fcoroutines-ts -D_RESUMABLE_FUNCTIONS_SUPPORTED")
endif()


############################################
# OS support (Linux/Windows)
############################################

IF (WIN32)

	set(OSLIBS "Ws2_32" "Rpcrt4")

	set(BUILDFLAGS "-await ${FLAGS}")

	set(LIBS ${GTEST_LIBRARIES} ${OPENSSL_LIBRARIES} ${STDLIB}  )

	set(LIBS debug ${CMAKE_PROJECT_NAME} optimized ${CMAKE_PROJECT_NAME} ${LIBS} )


 ELSEIF (UNIX)

    set(OSLIBS "pthread" "uuid")

    set(BUILDFLAGS " ${FLAGS}")

	set(LIBS ${GTEST_LIBRARIES} -lexpat ${STDLIB}  )

	set(LIBS debug ${CMAKE_PROJECT_NAME} optimized ${CMAKE_PROJECT_NAME} ${LIBS} )

ENDIF ()

############################################
# set linker and compiler flags
############################################

set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${LINKERFLAGS}" )
set(CMAKE_CXX_FLAGS_DEBUG  	"${CMAKE_CXX_FLAGS_DEBUG} -DMOL_PROMISE_DEBUG")
set(CMAKE_CXX_FLAGS  		"${CMAKE_CXX_FLAGS} ${BUILDFLAGS}")


############################################
# include directories
############################################

include_directories(include)
include_directories(${EXPAT_INCLUDE_DIR})

############################################
# sources
############################################


file(GLOB SOURCES "src/*.cpp")
file(GLOB HEADERS "include/patex/*.h")

############################################
# lib target
############################################

add_library(patex STATIC ${SOURCES})


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

#file(COPY pem DESTINATION .)

 
############################################
# install
############################################

install(TARGETS patex DESTINATION lib)

install(DIRECTORY include/patex DESTINATION include)

install(FILES patex.pc DESTINATION lib/pkgconfig)

