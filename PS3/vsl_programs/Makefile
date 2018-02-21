TARGETS=$(shell ls *.vsl | sed s/\.vsl/\.tree/g)
all: ${TARGETS}
%: %.s
%.tree: %.vsl
	../src/vslc -T <$*.vsl > $*.tree
clean:
	-rm -f *.tree
purge: clean
	-rm -f ${TARGETS}
