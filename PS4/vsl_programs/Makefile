TARGETS=$(shell ls *.vsl | sed s/\.vsl/.s/g)
all: ${TARGETS}
%: %.s
%.s: %.vsl
	../src/vslc <$*.vsl > $*.s
clean:
	-rm -f *.s
purge: clean
	-rm -f ${TARGETS}
