MODULE  PRINT_GDB

   IMPLICIT NONE

CONTAINS

SUBROUTINE fill_print( typ, n, minlat, minlon , maxlat, maxlon , vect )

INTEGER, INTENT(IN) :: typ, n
REAL, INTENT(IN)    :: minlat, minlon, maxlat, maxlon
REAL*4,  DIMENSION(1:n*2), INTENT(IN) :: vect
INTEGER :: i, offset, stat

PRINT'(A,4G13.6)','Fill limit: ',minlat,minlon,maxlat,maxlon
DO i = 1, n
  offset = (i-1) * 2
  PRINT'(2G13.6)',vect(offset+1),vect(offset+2)
ENDDO

END SUBROUTINE fill_print

SUBROUTINE line_print( typ, n, minlat, minlon , maxlat, maxlon , vect )

INTEGER, INTENT(IN) :: typ, n
REAL, INTENT(IN)    :: minlat, minlon, maxlat, maxlon
REAL*4,  DIMENSION(1:n*2), INTENT(IN) :: vect
INTEGER :: i, offset, stat

PRINT'(A,4G13.6)','Line limit: ',minlat,minlon,maxlat,maxlon
DO i = 1, n
  offset = (i-1) * 2
  PRINT'(2G13.6)',vect(offset+1),vect(offset+2)
ENDDO

END SUBROUTINE line_print

SUBROUTINE point_print( typ, lat, lon )

INTEGER, INTENT(IN) :: typ
REAL, INTENT(IN)    :: lat, lon

PRINT'(A,2G13.6)','Point : ',lat,lon

END SUBROUTINE point_print

SUBROUTINE text_print( typ, lat, lon, str )

INTEGER, INTENT(IN) :: typ
REAL, INTENT(IN)    :: lat, lon
CHARACTER(LEN=*), INTENT(IN) :: str

PRINT'(A,2G13.6,A)','Text : ',lat,lon, str

END SUBROUTINE text_print

END MODULE PRINT_GDB

