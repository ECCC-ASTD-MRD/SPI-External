DEBUG = -debug DEBUG -O 0
DEFINES = ''
INCLUDES = .

# Override incorrect implicits
%.o : %.mod

# Define suffix rules
.SUFFIXES: .f90 .o
.f90.o:
	$(COMPILE) -includes $(INCLUDES) -src $<

.c.o:
	$(COMPILE) -includes $(INCLUDES) -defines=$(DEFINES) $(DEBUG) -src $<

EXEC = testgdb
OBJECTS = print_gdb.o test_gdb.o
DEBUG = -debug DEBUG -O 0
COMPILE = s.compile
PLIB = .

all: $(EXEC)

$(EXEC): $(OBJECTS)
	$(COMPILE) -o $(EXEC) -obj $(OBJECTS) -opt $(OPT_LDFLGS) -libpath $(PLIB) -libappl gdb_ftn gdb dl $(DEBUG)

clean:
	rm -f *.o *.a *.mod $(EXEC)

