install_prefix := "/usr/local"

export INSTALL_PREFIX := install_prefix

# catnap is the default linux socket
libos := "catnap"

demikernel_flags := "LIBOS=" + libos + " INSTALL_PREFIX=" + install_prefix + " DEBUG=" + if build_type == "debug" { "yes" } else { "no" }
nodejs_flags := "--ninja --prefix " + install_prefix + " " + if build_type == "debug" { "--debug --debug-node" } else { "" }

dpdk_script_path := if libos == "catnip" { "./build-install-dpdk.sh" } else { "" }
hugepages_script := if libos == "catnip" { "./setup-hugepages.sh" } else { "" }

[working-directory: './demikernel/scripts/']
dpdk:
    sudo {{hugepages_script}}
    sudo {{dpdk_script_path}}

install_all: demikernel demi_epoll nodejs

[working-directory: './demi_epoll/']
demi_epoll:
    just install_prefix={{install_prefix}} all

[working-directory: './demikernel/']
demikernel: dpdk
    make init {{demikernel_flags}}
    make all-libs {{demikernel_flags}}
    sudo make install {{demikernel_flags}}

[working-directory: './node-24.0.0/']
nodejs:
    ./configure {{ nodejs_flags }} 
    make {{ if build_type == "debug" { "-C out BUILDTYPE=Debug" } else { "" } }} all
    sudo make install

gen_config:
    ./demikernel/scripts/generate-config.sh
    cp -i config.yaml $CONFIG_PATH

