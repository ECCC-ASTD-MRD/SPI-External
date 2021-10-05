DEBUG = -debug DEBUG -O 0
DEFINES = ''
INCLUDES = . ../src
COMPILE = s.compile

OBJECTS = gdb4ftn.o  gdb_c_ftn_inter.o
LIB = libgdb_ftn.a

# Override incorrect implicits
%.o : %.mod

# Define suffix rules
.SUFFIXES: .f90 .o

.f90.o:
	$(COMPILE) -src $<

.c.o:
	$(COMPILE) -includes $(INCLUDES) -defines=$(DEFINES) $(DEBUG) -src $<

all: lib clean

lib: $(OBJECTS)
	ar rv $(LIB) *.o
	@if [ ! -d ../build/lib ]; \
	then \
	   mkdir -p ../build/lib ; \
	fi;
	@if [ ! -d ../build/include ]; \
	then \
	   mkdir -p ../build/include ; \
	fi;
	cp $(LIB) ../build/lib
	cp *.mod ../build/include

clean:
	rm -f *.mod *.o *.a
