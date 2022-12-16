export BASEDIR=$PWD/pyvista_reqs

yumdownloader --destdir ./pyvista_yum --resolve openssl* Xvfb
rm -rf $BASEDIR/
mkdir $BASEDIR
cd $BASEDIR 
for rpmfile in ../pyvista_yum/*.rpm
do
    rpm2cpio $rpmfile | cpio -id
done

source /swbuild/eanders/miniconda3/etc/profile.d/conda.sh
conda activate pyvista
yes | conda install pyvista
conda deactivate

cat << EOF > ~/.source_pyvista.sh
function pyvista() {
    export PATH="$BASEDIR/usr/sbin:$BASEDIR/usr/bin:$BASEDIR/bin:\$PATH"
    export MANPATH="$BASEDIR/usr/share/man:\$MANPATH"
    export LD_LIBRARY_PATH="$BASEDIR/usr/lib:$BASEDIR/usr/lib64:\$LD_LIBRARY_PATH"

    export DISPLAY=:99.0
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
    sleep 3
    exec "\$@"
    glxinfo | grep "OpenGL version"
    echo "If OpenGL version is < 3.2, pyvista will probably have problems..."
}
EOF

echo " source ~/.source_pyvista.sh" >> ~/.profile
