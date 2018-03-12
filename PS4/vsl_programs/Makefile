TARGETS=$(shell ls *.vsl | sed s/\.vsl/.correct_output/g)
all: ${TARGETS}
%: %.correct_output
%.correct_output: %.vsl
	../src/vslc <$*.vsl > $*.correct_output
clean:
	-rm -f *.correct_output
purge: clean
	-rm -f ${TARGETS}
