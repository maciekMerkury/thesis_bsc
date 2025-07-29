#!/bin/env bash

home_dir=$HOME
if [ "$EUID" -eq 0 ]
    then home_dir=/home/user
    echo "running as root, setting home_dir to " $home_dir
fi


export PKG_CONFIG_PATH=$INSTALL_PREFIX/lib/x86_64-linux-gnu/pkgconfig
if [ -z "$CONFIG_PATH" ]; then
    export CONFIG_PATH=$home_dir/config.yaml
fi
if [ -z "$LIBOS" ]; then
    export LIBOS=catnap
fi

if [[ $LIBOS == "catnip" ]]; then
    dpdk_path=$(pkg-config --libs-only-L libdpdk | cut -c3-)
    echo $dpdk_path

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:$dpdk_path
    sudo ldconfig
fi

if ! [ -f $CONFIG_PATH ]; then
    just generate_config
fi

just install_all


