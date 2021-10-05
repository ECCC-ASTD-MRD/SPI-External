SHELL=/bin/sh
# TEST
OBJS = dbinit.o desc.o dlb.o gdb.o map.o pln.o point.o pol.o rgis.o scnio.o segment.o sock.o swp.o
CFLAG=-I. -g

#----- Check for intell compiler
ifdef INTELCOMP_HOME
CC=icc
CXX=icpc
endif


DEBUG = -debug DEBUG -O 0
DEFINES = ''
INCLUDES = .
COMPILE = s.compile

always:
	 make common OS=`uname`

TARGET = libgdb.a

common: $(TARGET) copie

copie:
	@if [ ! -d ../build/lib ]; \
	then \
	   mkdir -p ../build/lib ; \
	fi;
	@if [ ! -d ../build/include ]; \
	then \
	   mkdir -p ../build/include ; \
	fi;
	 cp *.a              ../build/lib
	 cp gdb.h            ../build/include
	 cp declare.h        ../build/include

clean:
	 rm *.o *.a

libgdb.a: $(OBJS)
	 ar rv $@ *.o
#	 cd ../gdb4ftn ; make

.c.o:
#	 $(COMPILE) -includes $(INCLUDES) -defines=$(DEFINES) $(DEBUG) -src $<

	 $(CC) $(CFLAG) -fPIC -DLinux -DSOCKADDR -rdynamic -c $?
 
