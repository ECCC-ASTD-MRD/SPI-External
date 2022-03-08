cmake_minimum_required(VERSION 3.12)

#----- Append EC specific module path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_rpn)

include(ExternalProject) 
include(ec_init)      # Initialize compilers and ec specific functions
ec_parse_manifest()   # Parse MANIFEST file

project(${NAME} DESCRIPTION "${DESCRIPTION}")
set(PROJECT_VERSION ${VERSION})

ec_install_prefix(${NAME} ${VERSION})  # Define install prefix  

# Build GDB
ExternalProject_Add(gdb
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/gdb/src     
   CONFIGURE_COMMAND ""
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND make libgdb.a
   INSTALL_COMMAND mkdir -p ${CMAKE_INSTALL_PREFIX}/lib && cp -d libgdb.a ${CMAKE_INSTALL_PREFIX}/lib && mkdir -p ${CMAKE_INSTALL_PREFIX}/include && cp -d gdb.h declare.h ${CMAKE_INSTALL_PREFIX}/include) 

# Build Mesa GL
if(BUILD_MESAGL)
   ExternalProject_Add(mesa
      SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mesa-${MESA_REQ_VERSION}    
      CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/mesa-${MESA_REQ_VERSION} && ./configure 
         CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
         --disable-egl
         --disable-driglx-direct
         --enable-glx=xlib
         --disable-dri
         --disable-gles1
         --disable-gles2
         --disable-shader-cache
         --with-gallium-drivers=swrast 
         --disable-gallium-llvm
         --prefix=${CMAKE_INSTALL_PREFIX}/GL
      PREFIX ${CMAKE_CURRENT_BINARY_DIR}/GL
      BUILD_IN_SOURCE ON
      BUILD_ALWAYS OFF
      BUILD_COMMAND make 
      INSTALL_COMMAND make install) 
   #mesa-9.2      ./configure --prefix=${LIB_PATH}/GL --disable-egl --disable-driglx-direct --disable-gallium --with-x --with-driver=xlib  
   #mesa-13+      ./configure --prefix=${LIB_PATH}/GL --disable-egl --disable-driglx-direct --enable-glx=xlib -disable-dri --with-gallium-drivers=swrast 
   #mesa-18+      ./configure --prefix=${LIB_PATH}/GL --disable-egl --disable-driglx-direct --enable-glx=xlib --enable-xlib-glx --disable-dri --disable-vdpau --disable-opencl --disable-gallium-llvm --disable-gbm --disable-shared-glapi --with-gallium-drivers=swrast 
endif()

# Build Tcl/Tk
if(CMAKE_SYSTEM_NAME STREQUAL Linux)
   set(subdir unix)
else()
   set(subdir macosx)
endif()

ExternalProject_Add(tcl
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tcl${TCL_REQ_VERSION}/${subdir}     
   CONFIGURE_COMMAND ./configure 
      CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
      --enable-threads 
      --enable-shared 
      --enable-64bit
      --prefix=${CMAKE_INSTALL_PREFIX}/TCL  
   COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/GL
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}/TCL
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND make 
   INSTALL_COMMAND make install) 

ExternalProject_Add(tk
   DEPENDS tcl
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tk${TCL_REQ_VERSION}/${subdir}     
   CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/tk${TCL_REQ_VERSION}/${subdir} && ./configure
      CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
      --enable-threads 
      --enable-shared 
      --enable-64bit
      --prefix=${CMAKE_INSTALL_PREFIX}/TCL/
      --with-tcl=${CMAKE_INSTALL_PREFIX}/TCL/lib 
      --enable-xft=no 
   #----- Remove visibility-hidden flag from makefile for glCanvas to work
   COMMAND mv Makefile Makefile.hidden 
   COMMAND bash "-c" "sed -e 's/hidden/default/' <Makefile.hidden >Makefile"
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}/TCL
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND make 
   INSTALL_COMMAND make install) 

# Build tcltls
ExternalProject_Add(tcltls
   DEPENDS tcl
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tcltls-${TCLTLS_REQ_VERSION}     
   CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/tcltls-${TCLTLS_REQ_VERSION} && ./configure
      CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
      --prefix=${CMAKE_INSTALL_PREFIX}/TCL 
      --with-tcl=${CMAKE_INSTALL_PREFIX}/TCL/lib 
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}/TCL
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND make 
   INSTALL_COMMAND make install) 

# Build TclLib
ExternalProject_Add(tcllib
   DEPENDS tcl
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tcllib-${TCLLIB_REQ_VERSION} 
   CONFIGURE_COMMAND ./configure 
      --prefix=${CMAKE_INSTALL_PREFIX}/TCL 
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}/TCL
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND ""
   INSTALL_COMMAND make install) 

# Build TkTable
ExternalProject_Add(tktable
   DEPENDS tcl tk
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Tktable-${TKTABLE_REQ_VERSION}     
   CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/Tktable-${TKTABLE_REQ_VERSION} && ./configure
      CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
      --enable-threads 
      --enable-64bit
      --prefix=${CMAKE_INSTALL_PREFIX}/TCL 
      --with-tcl=${CMAKE_INSTALL_PREFIX}/TCL/lib 
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}/TCL
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND make 
   INSTALL_COMMAND make install) 

# Build tkdnd
ExternalProject_Add(tkdnd
   DEPENDS tcl tk
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tkdnd-${TKDND_REQ_VERSION}     
   CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/tkdnd-${TKDND_REQ_VERSION} && ./configure
      CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
      --enable-threads 
      --enable-64bit
      --prefix=${CMAKE_INSTALL_PREFIX}/TCL 
      --with-tcl=${CMAKE_INSTALL_PREFIX}/TCL/lib 
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}/TCL
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND make 
   INSTALL_COMMAND make install) 

# Build tDOM
ExternalProject_Add(tdom
   DEPENDS tcl
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tdom-${TDOM_REQ_VERSION}     
   CONFIGURE_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/tdom-${TDOM_REQ_VERSION} && ./configure
      CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
      --enable-threads 
      --enable-64bit
      --prefix=${CMAKE_INSTALL_PREFIX}/TCL 
      --with-tcl=${CMAKE_INSTALL_PREFIX}/TCL/lib 
      --with-tclinclude=${CMAKE_INSTALL_PREFIX}/TCL/include
   PREFIX ${CMAKE_CURRENT_BINARY_DIR}/TCL
   BUILD_IN_SOURCE ON
   BUILD_ALWAYS OFF
   BUILD_COMMAND make 
   INSTALL_COMMAND make install) 
