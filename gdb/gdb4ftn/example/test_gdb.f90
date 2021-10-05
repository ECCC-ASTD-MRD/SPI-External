PROGRAM gdb_read_test
USE gdb4ftn
USE print_gdb

IMPLICIT NONE

REAL :: top,bottom,left,right
INTEGER :: ier
INTEGER :: reso

bottom = 43.0
left = -75.0
top = 48.0
right = -70.0

reso = 128
ier = fgdb_init()
if (ier .ne. 0) then
   print *,'** Abort ***'
   stop
endif

ier = fgdb_limit(bottom, left, top, right)
call fgdb_fill( reso, GDB_FIL_LAND, fill_print )
call fgdb_line( reso, GDB_LIN_COAST, line_print )
call fgdb_point( reso, GDB_PNT_LAKE, point_print )
call fgdb_text( reso, GDB_TXT_CITY, text_print )

END PROGRAM gdb_read_test
