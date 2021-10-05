MODULE gdb4ftn

IMPLICIT NONE

INTEGER, PARAMETER :: &
 GDB_FIL_LAND = 1, &
 GDB_FIL_LAKE = 2, &
 GDB_FIL_LAND2 = 3, &
 GDB_FIL_LAKE2 = 4, &
 GDB_LIN_ADMIN = 1, &
 GDB_LIN_CANAL = 2, &
 GDB_LIN_CITY  = 3, &
 GDB_LIN_COAST = 4, &
 GDB_LIN_CULT  = 5, &
 GDB_LIN_DATE  = 6, &
 GDB_LIN_ICE   = 7, &
 GDB_LIN_LAKE  = 8, &
 GDB_LIN_PHYS  = 9, &
 GDB_LIN_POLIT = 10, &
 GDB_LIN_RAIL  = 11, &
 GDB_LIN_ROAD  = 12, &
 GDB_LIN_RIVER = 13, &
 GDB_LIN_SALIN = 14, &
 GDB_LIN_SEA   = 15, &
 GDB_LIN_UTIL  = 16, &
 GDB_PNT_ISLND = 1, &
 GDB_PNT_LAKE  = 2, &
 GDB_PNT_SEA   = 3, &
 GDB_TXT_AIRP  = 1, &
 GDB_TXT_CULT  = 2, &
 GDB_TXT_CITY  = 3, &
 GDB_TXT_DRAIN = 4, &
 GDB_TXT_ISLND = 5, &
 GDB_TXT_POLIT = 6, &
 GDB_TXT_RAIL  = 7, &
 GDB_TXT_ROAD = 8

INTERFACE

  FUNCTION fgdbinit()
  INTEGER :: fgdbinit
  END FUNCTION fgdbinit

  FUNCTION  fgdblimit(bottom,left,top,right)
  REAL, INTENT(IN) :: bottom,left,top,right
  INTEGER :: fgdblimit
  END FUNCTION fgdblimit

  SUBROUTINE fgdbfill(reso,typ,retfunc)
  USE, INTRINSIC :: ISO_C_BINDING, ONLY: C_INT
  INTEGER(C_INT), INTENT(IN) :: reso, typ
  EXTERNAL :: retfunc
  END SUBROUTINE fgdbfill

  SUBROUTINE fgdbline(reso,typ,retfunc)
  INTEGER, INTENT(IN) :: reso, typ
  EXTERNAL :: retfunc
  END SUBROUTINE fgdbline

  SUBROUTINE fgdbpoint(reso,typ,retfunc)
  INTEGER, INTENT(IN) :: reso, typ
  EXTERNAL :: retfunc
  END SUBROUTINE fgdbpoint

  SUBROUTINE fgdbtext(reso,typ,retfunc)
  INTEGER, INTENT(IN) :: reso, typ
  EXTERNAL :: retfunc
  END SUBROUTINE fgdbtext

END INTERFACE

CONTAINS

FUNCTION fgdb_init()
INTEGER :: fgdb_init

fgdb_init = fgdbinit()
END FUNCTION fgdb_init

FUNCTION fgdb_limit(bottom,left,top,right)
INTEGER :: fgdb_limit
REAL :: bottom,left,top,right

fgdb_limit = fgdblimit( bottom,left,top,right )
END FUNCTION fgdb_limit

SUBROUTINE fgdb_fill(reso,typ,retfunc)
INTEGER :: reso, typ
EXTERNAL :: retfunc

call fgdbfill( reso, typ, retfunc )
END SUBROUTINE fgdb_fill

SUBROUTINE fgdb_line(reso,typ,retfunc)
INTEGER :: reso, typ
EXTERNAL :: retfunc

call fgdbline( reso, typ, retfunc )
END SUBROUTINE fgdb_line

SUBROUTINE fgdb_point(reso,typ,retfunc)
INTEGER :: reso, typ
EXTERNAL :: retfunc

call fgdbpoint( reso, typ, retfunc )
END SUBROUTINE fgdb_point

SUBROUTINE fgdb_text(reso,typ,retfunc)
INTEGER :: reso, typ
EXTERNAL :: retfunc

call fgdbtext( reso, typ, retfunc )
END SUBROUTINE fgdb_text

END MODULE gdb4ftn
