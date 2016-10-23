all: build

build64: clean
	mkdir build && cd build && CFLAGS='-m64' cmake ../src && make

build32: clean
	mkdir build && cd build && CFLAGS='-m32' cmake ../src && make

universal: clean
	mkdir build && cd build && cmake ../src -DCMAKE_OSX_ARCHITECTURES="x86_64;i386" && make && make test

test64: build64
	cd build && make test

test32: build32
	cd build && make test

install64: build64
	cd build && make install

install32: build32
	cd build && make install

clean:
	rm -rf build
	rm -f *.rpm
	rm -f *.deb

dist_prepare64: test64
	mkdir -p usr/share/doc/stderred && cp README.md usr/share/doc/stderred/

dist_prepare32: test32
	mkdir -p usr/share/doc/stderred && cp README.md usr/share/doc/stderred/

package_deb64: dist_prepare64 
	mkdir -p usr/lib && cp build/libstderred.so usr/lib/
	fpm -s dir -t deb -n stderred -v `git tag | grep v | cut -d 'v' -f 2 | sort -nr | head -n 1` --license MIT --vendor 'Rene Ploetz' -m 'Rene Ploetz <reneploetz@gmx.de>' --description "stderr in red" --url https://github.com/reneploetz/stderred usr/bin/stderred usr/lib/libstderred.so usr/share/stderred/stderred.sh usr/share/doc/stderred/README.md

package_rpm_64: dist_prepare64 
	mkdir -p usr/lib64 && cp build/libstderred.so usr/lib64/
	fpm -s dir -t rpm -n stderred-lib -a x86_64 -v `git tag | grep v | cut -d 'v' -f 2 | sort -nr | head -n 1` --license MIT --vendor 'Rene Ploetz' -m 'Rene Ploetz <reneploetz@gmx.de>' --description "stderr in red" --url https://github.com/reneploetz/stderred usr/lib64/libstderred.so

package_rpm_32: dist_prepare32 
	mkdir -p usr/lib && cp build/libstderred.so usr/lib/
	fpm -s dir -t rpm -n stderred-lib -a i686  -v `git tag | grep v | cut -d 'v' -f 2 | sort -nr | head -n 1` --license MIT --vendor 'Rene Ploetz' -m 'Rene Ploetz <reneploetz@gmx.de>' --description "stderr in red" --url https://github.com/reneploetz/stderred usr/lib/libstderred.so

package_rpm_bin: clean
	mkdir -p usr/share/doc/stderred && cp README.md usr/share/doc/stderred/
	fpm -s dir -t rpm -n stderred-bin -a noarch -v `git tag | grep v | cut -d 'v' -f 2 | sort -nr | head -n 1` --license MIT --vendor 'Rene Ploetz' -m 'Rene Ploetz <reneploetz@gmx.de>' --description "stderr in red" --url https://github.com/reneploetz/stderred usr/bin/stderred usr/share/stderred/stderred.sh usr/share/doc/stderred/README.md

