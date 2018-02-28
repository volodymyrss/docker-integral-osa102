component_dir=${1:?}

if [ -d "$component_dir" ]; then
    source osa10.2_init.sh

    cd $component_dir 

    $ISDC_ENV/ac_stuff/configure
    make 
else
    echo "what is this? $component_dir"
    exit 1
fi


