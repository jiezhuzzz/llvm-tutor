cmake_minimum_required(VERSION 3.20)
project(llvm-tutor-hello-world)

#===============================================================================
# 1. LOAD LLVM CONFIGURATION
#===============================================================================
# Use find_package to locate LLVM (Nix should provide the correct paths)
find_package(LLVM CONFIG REQUIRED)

if("${LLVM_VERSION_MAJOR}" VERSION_LESS 19)
  message(FATAL_ERROR "Found LLVM ${LLVM_VERSION_MAJOR}, but need LLVM 19 or above")
endif()


#===============================================================================
# 2. LLVM-TUTOR BUILD CONFIGURATION
#===============================================================================
# Use the same C++ standard as LLVM does
set(CMAKE_CXX_STANDARD 17 CACHE STRING "")

# LLVM is normally built without RTTI. Be consistent with that.
if(NOT LLVM_ENABLE_RTTI)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()


#===============================================================================
# 3. ADD THE TARGET
#===============================================================================
add_library(HelloWorld SHARED HelloWorld.cpp)

# HelloWorld includes headers from LLVM - update the include paths accordingly
target_include_directories(HelloWorld PRIVATE ${LLVM_INCLUDE_DIRS})

# Allow undefined symbols in shared objects on Darwin (this is the default
# behaviour on Linux)
target_link_libraries(HelloWorld
  "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>")
