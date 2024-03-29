#!/bin/bash -norc
#--------------------------------------------------------------------
# Sample configure.ac for Tcl Extensions.  The only places you should
# need to modify this file are marked by the string __CHANGE__
#--------------------------------------------------------------------

#-----------------------------------------------------------------------
# This initializes the environment with PACKAGE_NAME and PACKAGE_VERSION
# set as provided.  These will also be added as -D defs in your Makefile
# so you can encode the package version directly into the source files.
#-----------------------------------------------------------------------

AC_INIT([itcl], [4.0.5])

#--------------------------------------------------------------------
# Call TEA_INIT as the first TEA_ macro to set up initial vars.
# This will define a ${TEA_PLATFORM} variable == "unix" or "windows"
# as well as PKG_LIB_FILE and PKG_STUB_LIB_FILE.
#--------------------------------------------------------------------

TEA_INIT([3.10])

AC_PROG_LN_S
CONFIG_CLEAN_FILES=
if test ! -d $srcdir/tclconfig ; then
    if test -d $srcdir/../tclconfig ; then
        $LN_S $srcdir/../tclconfig tclconfig
        CONFIG_CLEAN_FILES=tclconfig
    fi
fi
AC_SUBST(CONFIG_CLEAN_FILES)

AC_CONFIG_AUX_DIR(tclconfig)

#--------------------------------------------------------------------
# Load the tclConfig.sh file
#--------------------------------------------------------------------

TEA_PATH_TCLCONFIG
TEA_LOAD_TCLCONFIG

if test "${TCL_MAJOR_VERSION}" -ne 8; then
    AC_MSG_ERROR([${TCL_BIN_DIR}/tclConfig.sh is for Tcl ${TCL_VERSION}.
Itcl ${PACKAGE_VERSION} needs Tcl 8.6 or higher.
Use --with-tcl= option to indicate location of tclConfig.sh file for Tcl 8.6+.])
fi
if test "${TCL_MINOR_VERSION}" -lt 6; then
    AC_MSG_ERROR([${TCL_BIN_DIR}/tclConfig.sh is for Tcl ${TCL_VERSION}.
Itcl ${PACKAGE_VERSION} needs Tcl 8.6 or higher.
Use --with-tcl= option to indicate location of tclConfig.sh file for Tcl 8.6+.])
fi

#-----------------------------------------------------------------------
# Handle the --prefix=... option by defaulting to what Tcl gave.
# Must be called after TEA_LOAD_TCLCONFIG and before TEA_SETUP_COMPILER.
#-----------------------------------------------------------------------

TEA_PREFIX

#-----------------------------------------------------------------------
# Standard compiler checks.
# This sets up CC by using the CC env var, or looks for gcc otherwise.
# This also calls AC_PROG_CC and a few others to create the basic setup
# necessary to compile executables.
#-----------------------------------------------------------------------

TEA_SETUP_COMPILER

#-----------------------------------------------------------------------
# __CHANGE__
# Specify the C source files to compile in TEA_ADD_SOURCES,
# public headers that need to be installed in TEA_ADD_HEADERS,
# stub library C source files to compile in TEA_ADD_STUB_SOURCES,
# and runtime Tcl library files in TEA_ADD_TCL_SOURCES.
# This defines PKG(_STUB)_SOURCES, PKG(_STUB)_OBJECTS, PKG_HEADERS
# and PKG_TCL_SOURCES.
#-----------------------------------------------------------------------


TEA_ADD_SOURCES([
                itcl2TclOO.c
	        itclBase.c
	        itclBuiltin.c
                itclClass.c
                itclCmd.c
                itclEnsemble.c
                itclHelpers.c
	        itclInfo.c
                itclLinkage.c
                itclMethod.c
                itclObject.c
	        itclParse.c
	        itclStubs.c
                itclStubInit.c
	        itclResolve.c
	        itclTclIntStubsFcn.c
	        itclUtil.c
                itclMigrate2TclCore.c
		itclTestRegisterC.c
                ])
TEA_ADD_HEADERS([generic/itcl.h
                generic/itclDecls.h
		generic/itclInt.h
                generic/itclMigrate2TclCore.h
                generic/itclTclIntStubsFcn.h
                generic/itcl2TclOO.h
                generic/itclIntDecls.h
		])
TEA_ADD_INCLUDES([-I. -I\"`${CYGPATH} ${srcdir}/generic`\"])
TEA_ADD_LIBS([])
TEA_ADD_CFLAGS([])
TEA_ADD_STUB_SOURCES(itclStubLib.c)
TEA_ADD_TCL_SOURCES([library/itcl.tcl library/itclWidget.tcl library/itclHullCmds.tcl])

#--------------------------------------------------------------------
# __CHANGE__
# A few miscellaneous platform-specific items:
#
# Define a special symbol for Windows (BUILD_itcl in this case) so
# that we create the export library with the dll.  See sha1.h on how
# to use this.
#
# Windows creates a few extra files that need to be cleaned up.
# You can add more files to clean if your extension creates any extra
# files.
#
# Define any extra compiler flags in the PACKAGE_CFLAGS variable.
# These will be appended to the current set of compiler flags for
# your system.
#--------------------------------------------------------------------

if test "${TEA_PLATFORM}" = "windows" ; then
    TEA_ADD_SOURCES([dllEntryPoint.c])
fi

#--------------------------------------------------------------------
# __CHANGE__
# Choose which headers you need.  Extension authors should try very
# hard to only rely on the Tcl public header files.  Internal headers
# contain private data structures and are subject to change without
# notice.
# This must be done AFTER calling TEA_PATH_TCLCONFIG/TEA_LOAD_TCLCONFIG
# so that we can extract TCL_SRC_DIR from the config file (in the case
# of private headers
#--------------------------------------------------------------------

#TEA_PUBLIC_TCL_HEADERS
TEA_PRIVATE_TCL_HEADERS

#--------------------------------------------------------------------
# Check whether --enable-threads or --disable-threads was given.
# This auto-enables if Tcl was compiled threaded.
#--------------------------------------------------------------------

TEA_ENABLE_THREADS

#--------------------------------------------------------------------
# The statement below defines a collection of symbols related to
# building as a shared library instead of a static library.
#--------------------------------------------------------------------

TEA_ENABLE_SHARED

#--------------------------------------------------------------------
# This macro figures out what flags to use with the compiler/linker
# when building shared/static debug/optimized objects.  This information
# can be taken from the tclConfig.sh file, but this figures it all out.
#--------------------------------------------------------------------

TEA_CONFIG_CFLAGS

#--------------------------------------------------------------------
# Set the default compiler switches based on the --enable-symbols option.
#--------------------------------------------------------------------

TEA_ENABLE_SYMBOLS

#--------------------------------------------------------------------
# Check for intptr_t (for INT2PTR & PTR2INT macros).
#--------------------------------------------------------------------

AC_CHECK_TYPE([intptr_t], [
    AC_DEFINE([HAVE_INTPTR_T], 1, [Do we have the intptr_t type?])], [
    AC_CACHE_CHECK([for pointer-size signed integer type], tcl_cv_intptr_t, [
    for tcl_cv_intptr_t in "int" "long" "long long" none; do
	if test "$tcl_cv_intptr_t" != none; then
	    AC_COMPILE_IFELSE([AC_LANG_BOOL_COMPILE_TRY([AC_INCLUDES_DEFAULT],
		    [[sizeof (void *) <= sizeof ($tcl_cv_intptr_t)]])], 
		[tcl_ok=yes], [tcl_ok=no])
	    test "$tcl_ok" = yes && break; fi
    done])
    if test "$tcl_cv_intptr_t" != none; then
	AC_DEFINE_UNQUOTED([intptr_t], [$tcl_cv_intptr_t], [Signed integer
	   type wide enough to hold a pointer.])
    fi
])

#--------------------------------------------------------------------
# This macro generates a line to use when building a library.  It
# depends on values set by the TEA_ENABLE_SHARED, TEA_ENABLE_SYMBOLS,
# and TEA_LOAD_TCLCONFIG macros above.
#--------------------------------------------------------------------

TEA_MAKE_LIB

#--------------------------------------------------------------------
# __CHANGE__
# Change the name from exampeA_LIB_FILE to match your package name.
# Use the stub_LIB_FILE substitution if your package creates a stub
# library.
#--------------------------------------------------------------------

itcl_STUB_LIB_FILE=${PKG_STUB_LIB_FILE}
itcl_LIB_FILE=${PKG_LIB_FILE}
AC_SUBST(itcl_STUB_LIB_FILE)
AC_SUBST(itcl_LIB_FILE)

#--------------------------------------------------------------------
# Find tclsh so that we can run pkg_mkIndex to generate the pkgIndex.tcl
# file during the install process.  Don't run the TCLSH_PROG through
# ${CYGPATH} because it's being used directly by make.
# Require that we use a tclsh shell version 8.2 or later since earlier
# versions have bugs in the pkg_mkIndex routine.
#--------------------------------------------------------------------

TEA_PROG_TCLSH

#--------------------------------------------------------------------
# These are for itclConfig.sh
#--------------------------------------------------------------------

TEA_EXPORT_CONFIG([itcl])

# itcl_SRC_DIR must be a fully qualified path
eval itcl_SRC_DIR="$srcdir"
itcl_SRC_DIR=`cd "${itcl_SRC_DIR}"; pwd`
AC_SUBST(itcl_SRC_DIR)

eval itcl_INCLUDE_SPEC="${itcl_SRC_DIR}/generic"
AC_SUBST(itcl_INCLUDE_SPEC)

#--------------------------------------------------------------------
# Finally, substitute all of the various values into the Makefile.
#--------------------------------------------------------------------

AC_OUTPUT([Makefile pkgIndex.tcl itclConfig.sh])
