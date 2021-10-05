#include <alloca.h>
#include <string.h>
#include <stdlib.h>
#include "gdb.h"
/*
#include "rpnmacros.h"
*/

#define  f77name(name) name ## _

#define strf2c(strf, strc, strl) strc = alloca(strl+1); strncpy(strc, strf, strl); strc[strl] = '\0'

typedef void (*F_GDB_LINE )( int *type, int     *n,
                                   float *mnlat, float *mnlon, float *mxlat, float *mxlon,
                                                               float *ll );
typedef void (*F_GDB_POINT)( int *type, float *lat, float *lon );
typedef void (*F_GDB_TEXT )( int *type, float *lat, float *lon, char *str, int len );


static  F_GDB_LINE   gdb_fill_retfunc=NULL;
static  F_GDB_LINE   gdb_line_retfunc=NULL;
static  F_GDB_POINT  gdb_point_retfunc=NULL;
static  F_GDB_TEXT   gdb_text_retfunc=NULL;


static void gdb_fill_func_p  ( int type, int n, float minlat, float minlon, float maxlat, float maxlon, float *ptr );
static void gdb_line_func_p  ( int type, int n, float minlat, float minlon, float maxlat, float maxlon, float *ptr );
static void gdb_point_func_p ( int type, float lat, float lon );
static void gdb_text_func_p  ( int type, float lat, float lon, char *str );


int f77name(fgdbinit)
  (void) {

  return gdb_init();
}


int f77name(fgdblimit)
  (float *bottom, float *left, float *top, float *right) {

  return gdb_limit(*bottom, *left, *top, *right);
}


void f77name(fgdbfill)
  (int *reso, int *typ, F_GDB_LINE func ) {
  gdb_fill_retfunc = func;
  gdb_fill( *reso, *typ, gdb_fill_func_p );
}
						 
void f77name(fgdbline)
  (int *reso, int *typ, F_GDB_LINE func ) {
  gdb_line_retfunc = func;
  gdb_line( *reso, *typ, gdb_line_func_p );
}
						 
void f77name(fgdbpoint)
  (int *reso, int *typ, F_GDB_POINT func ) {
  gdb_point_retfunc = func;
  gdb_point( *reso, *typ, gdb_point_func_p );
}
						 
void f77name(fgdbtext)
  (int *reso, int *typ, F_GDB_TEXT func ) {
  gdb_text_retfunc = func;
  gdb_text( *reso, *typ, gdb_text_func_p );
}

static void gdb_fill_func_p
   ( int type, int n,
    float minlat, float minlon, float maxlat, float maxlon,
    float *ptr )
{
   gdb_fill_retfunc ( &type, &n, &minlat, &minlon, &maxlat, &maxlon, ptr );
}

static void gdb_line_func_p
   ( int type, int n,
    float minlat, float minlon, float maxlat, float maxlon,
    float *ptr )
{
   gdb_line_retfunc ( &type, &n, &minlat, &minlon, &maxlat, &maxlon, ptr );
}

static void gdb_point_func_p
   ( int type, 
    float lat, float lon )
{
   gdb_point_retfunc ( &type, &lat, &lon );
}

static void gdb_text_func_p
   ( int type, 
    float lat, float lon, char *str )
{
   gdb_text_retfunc ( &type, &lat, &lon, str, strlen(str) );
}

						 
