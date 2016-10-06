cmake_minimum_required(VERSION 2.8.9)

project( pylis )
enable_testing()
# The source files
set(SOURCES

  )
set( PY_FILES
  lis/__init__.py
  )


#
# OpenMP
#
find_package(OpenMP REQUIRED)
if(OPENMP_FOUND)
  message("OPENMP FOUND")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()

# Numpy
set(EXTRA_INCLUDES "/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/numpy/core/include/" CACHE STRING "Extra includes; e.g. location to numpy/core/include/")
include_directories(${EXTRA_INCLUDES})


#
# Set up lis
#
set(lis_path "/home/afq/Research/Distribute/Stonedist" CACHE STRING "Path to lis")
set(lis_lib_location "${lis_path}/lib/liblis.so") 

add_library(lib_lis STATIC IMPORTED)
set_property(TARGET lib_lis PROPERTY IMPORTED_LOCATION ${lis_lib_location})
include_directories(${lis_path}/include/)

#
# Configure swig
#
find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})
set(CMAKE_SWIG_FLAGS "")
find_package(PythonLibs)
include_directories(${PYTHON_INCLUDE_PATH})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
set_source_files_properties(src/wrapper.i PROPERTIES SWIG_FLAGS "-includeall")
swig_add_module(lis_wrapper python src/wrapper.i ${SOURCES})
swig_link_libraries(lis_wrapper ${PYTHON_LIBRARIES} lib_lis)

#
# Install
#
set( PY_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/pylis)
install(TARGETS ${SWIG_MODULE_lis_wrapper_REAL_NAME} DESTINATION ${PY_INSTALL_DIR} OPTIONAL)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/lis_wrapper.py DESTINATION ${PY_INSTALL_DIR})
install(FILES ${PY_FILES} DESTINATION ${PY_INSTALL_DIR})
#install(FILES ${lis_lib_location} DESTINATION ${PY_INSTALL_DIR})
#install(FILES "${lis_lib_location}.0" DESTINATION ${PY_INSTALL_DIR})