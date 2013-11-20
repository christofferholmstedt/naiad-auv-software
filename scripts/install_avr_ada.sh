#!/bin/bash

ORIGINAL_PATH=$PATH

echo "####################################"
echo "# Install required packages first"
echo "# gnat-4.6 and its requirements"
echo "####################################"
echo sudo apt-get install build-essential libc6-dev gnat-4.6  libgmp-dev bison \
    flex libmpfr-dev libmpc-dev git texinfo zlib1g-dev
echo mkdir -pv $HOME/avrada-build
echo cd $HOME/avrada-build


echo "#####################################################"
echo "# Create shell scripts for setting needed variables"
echo "#####################################################"
echo ""

cat > ./native_build_env.sh <<EOL
#!/bin/sh
export HOST_SYSTEM_MULTIARCH_TYPE=\$(dpkg-architecture -qDEB_HOST_MULTIARCH)
export C_INCLUDE_PATH=/usr/include/\$HOST_SYSTEM_MULTIARCH_TYPE
export LIBRARY_PATH=/usr/lib/\$HOST_SYSTEM_MULTIARCH_TYPE
export CPLUS_INCLUDE_PATH=\$C_INCLUDE_PATH && export OBJC_INCLUDE_PATH=\$C_INCLUDE_PATH
export MULTIARCH_FLAGS="-B/usr/lib/\${HOST_SYSTEM_MULTIARCH_TYPE} -I/usr/include/\${HOST_SYSTEM_MULTIARCH_TYPE}"
export CFLAGS="-g -O2"
export CXXFLAGS="\${CFLAGS}"
export CFLAGS_FOR_TARGET="\${CFLAGS} \${MULTIARCH_FLAGS}"
export CXXFLAGS_FOR_TARGET="\${CXXFLAGS} \${MULTIARCH_FLAGS}"
export FLAGS_FOR_TARGET="\${FLAGS_FOR_TARGET} \${MULTIARCH_FLAGS}"
export DEST_GNAT_HOST=/opt/gnat-4.7
export DEST_GNAT_CROSS=/opt/avrada
EOL

cat > ./cross_build_env.sh <<EOL
#!/bin/sh
export DEST_GNAT_HOST=/opt/gnat-4.7
export DEST_GNAT_CROSS=/opt/avrada
export PATH=\$DEST_GNAT_CROSS/bin:\$DEST_GNAT_HOST/bin:\$PATH
EOL

chmod +x cross_build_env.sh native_build_env.sh

echo ""
echo "#####################################################"
echo "# Download and compile gnat-4.7"
echo "#####################################################"
echo ""
echo . ./native_build_env.sh
echo wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-4.7.0/gcc-4.7.0.tar.gz
# CHANGE: Added v parameter for verbose output
echo tar zvxf gcc-4.7.0.tar.gz
echo mkdir gcc-obj-470
echo cd gcc-obj-470
echo ../gcc-4.7.0/configure --enable-languages=c,ada --prefix=$DEST_GNAT_HOST --disable-multilib
echo make bootstrap
# FIX: Added extra dot to the path because the shell script is one directory up
echo sudo su -c ". ../native_build_env.sh; make install"
echo cd ..

echo ""
echo "#####################################################"
echo "# Create gnat-4.7 specific executables "
echo "#####################################################"
echo ""

# TODO: Remove the comments for this section when trying it out on a new
# computer.
# cat > /opt/gnat-4.7/bin/gcc-4.7 <<EOL
# #!/bin/sh
# exec /opt/gnat-4.7/bin/gcc -B/usr/lib/i386-linux-gnu -I/usr/include/i386-linux-gnu "$@"
# EOL
#
# cat > /opt/gnat-4.7/bin/g++-4.7 <<EOL
# #!/bin/sh
# exec /opt/gnat-4.7/bin/g++ -B/usr/lib/i386-linux-gnu -I/usr/include/i386-linux-gnu "$@"
# EOL
#
# cat > /opt/gnat-4.7/bin/c++-4.7 <<EOL
# #!/bin/sh
# exec /opt/gnat-4.7/bin/c++ -B/usr/lib/i386-linux-gnu -I/usr/include/i386-linux-gnu "$@"
# EOL
#
# cat > /opt/gnat-4.7/bin/cpp-4.7 <<EOL
# #!/bin/sh
# exec /opt/gnat-4.7/bin/cpp -B/usr/lib/i386-linux-gnu -I/usr/include/i386-linux-gnu "$@"
# EOL

echo sudo chmod +x /opt/gnat-4.7/bin/gcc-4.7 /opt/gnat-4.7/bin/g++-4.7 \
    /opt/gnat-4.7/bin/c++-4.7 /opt/gnat-4.7/bin/cpp-4.7

echo ""
echo "#####################################################"
echo "# Install avr-binutils"
echo "#####################################################"
echo ""

export CC="gcc-4.7" CXX="c++-4.7" CPP="cpp-4.7"
echo . ./cross_build_env.sh
echo wget http://ftp.uni-kl.de/pub/gnu/binutils/binutils-2.20.1a.tar.bz2
# CHANGE: Added v parameter for verbose output
echo tar jvxf binutils-2.20.1a.tar.bz2
echo git clone git://git.code.sf.net/p/avr-ada/code avr-ada-code
echo cd binutils-2.20.1
echo 'for a in ../avr-ada-code/patches/binutils/2.20.1/*.patch;do patch -p0 < $a || fail "avr-binutils: patch $a" ; done'
echo cd ..
echo mkdir binutils-obj
echo cd binutils-obj
echo ../binutils-2.20.1/configure --target=avr --program-prefix=avr- --disable-shared --disable-nls --enable-commonbfdlib=no --disable-werror --prefix=$DEST_GNAT_CROSS
echo make
echo sudo su -c ". ../cross_build_env.sh; make install"
echo cd ..

echo ""
echo "#####################################################"
echo "# Install gnat-4.7 Cross compile for avr"
echo "#####################################################"
echo ""

echo . ./native_build_env.sh
echo . ./cross_build_env.sh
echo mv gcc-4.7.0 gcc-4.7.0-native
# CHANGE: Added v parameter for verbose output
echo tar zvxf gcc-4.7.0.tar.gz
echo cd gcc-4.7.0
echo 'for a in ../avr-ada-code/patches/gcc/4.7.0/*.patch;do patch -p0 < $a;done'
echo cd ..
echo mkdir avr-gcc-obj
echo cd avr-gcc-obj
echo ../gcc-4.7.0/configure --target=avr --program-prefix=avr- --disable-shared --disable-nls --disable-libssp --with-system-zlib --disable-libada --enable-languages=ada,c,c++ --enable-cpp --with-dwarf2 --enable-version-specific-runtime-libs --prefix=$DEST_GNAT_CROSS
echo sed -i -e 's/$(STAMP)/echo timestamp >/' ../gcc-4.7.0/gcc/config/avr/t-avr
echo make
echo sudo su -c ". ../native_build_env.sh; . ../cross_build_env.sh; make install"
echo cd ..

echo ""
echo "#####################################################"
echo "# Install cross avr-libc"
echo "#####################################################"
echo ""
echo . ./cross_build_env.sh
echo unset CC ; unset CXX ; unset CPP
echo wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-1.8.0.tar.bz2
# CHANGE: Added v parameter for verbose output
echo tar jvxf avr-libc-1.8.0.tar.bz2
echo cd avr-libc-1.8.0
echo ./configure --host=avr --prefix=$DEST_GNAT_CROSS
echo make
echo sudo su -c ". ./cross_build_env.sh; make install"
echo cd ..

echo ""
echo "#####################################################"
echo "# Install AVR-Ada"
echo "#####################################################"
echo ""
echo cd avr-ada-code
echo ./configure
echo make
echo sudo su -c ". ../native_build_env.sh ; . ../cross_build_env.sh; make install_rts"
echo cd avr/avr_lib
echo sed -i -e 's/stamp-libs: $(thread_libs)/stamp-libs:/' Makefile
echo make
echo cd ../..
echo sudo su -c ". ../cross_build_env.sh; make install_libs"

