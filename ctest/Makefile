CPP=g++
LIBS=-lblkid

ctest:	ctest.o
	$(CPP) $(LIBS) -o $@ $<

ctest.o: ctest.cc
	$(CPP) -c $<

.PHONY: clean

clean:
	rm -f ctest.o ctest
