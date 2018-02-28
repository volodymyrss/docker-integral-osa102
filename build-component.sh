component_dir=${1:?}

cd $component_dir

source osa10.2_init.sh
$ISDC_ENV/ac_stuff/configure
make install

