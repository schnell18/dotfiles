function __dotfiles_setup_libvirt {
    case $OS_DISTRO in
        ubuntu)
            ensure_install qemu-system libvirt-daemon-system
            if ! groups | grep -q libvirt; then
                sudo adduser $USER libvirt
            fi
        ;;
        *)
            echo "Unsupported OS DISTRO: $OS_DISTRO" 1>&2
            exit 1
        ;;
    esac
    ensure_storage_pool "vmpool"
    ensure_network "kubernetes"

}

ensure_storage_pool() {
    POOL_NAME=${1:-vmpool}
    # Create storage pool 'vmpool'
    if ! virsh -c qemu:///system pool-list --all | grep -q $POOL_NAME; then
        if [[ -z $LIBVIRT_POOL_ROOT_DIR ]]; then
            LIBVIRT_POOL_ROOT_DIR="/var/lib/libvirt/images"
        fi
        POOL_DIR="$LIBVIRT_POOL_ROOT_DIR/$POOL_NAME"
        if [[ ! -d POOL_DIR ]]; then
            mkdir -p $POOL_DIR
            sudo chown libvirt-qemu:kvm $POOL_DIR
            sudo chmod 755 $POOL_DIR
        fi
        virsh -c qemu:///system pool-define-as $POOL_NAME dir --target $POOL_DIR
        virsh -c qemu:///system pool-start $POOL_NAME
        virsh -c qemu:///system pool-autostart $POOL_NAME
    fi
}

ensure_network() {
    NETWORK_NAME=${1:-kubernetes}

    if ! virsh -c qemu:///system net-list --all | grep -q $NETWORK_NAME; then
        NET_XML_FILE="/tmp/__xdsfsdfdfadf.xml"

        cat<<EOF >$NET_XML_FILE
<network>
  <name>$NETWORK_NAME</name>
  <bridge name="virbr10" stp="on" delay="0"/>
  <ip address="192.168.122.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.122.100" end="192.168.122.254"/>
    </dhcp>
  </ip>
</network>
EOF

        virsh -c qemu:///system net-define $NET_XML_FILE
        virsh -c qemu:///system net-start $NETWORK_NAME
        virsh -c qemu:///system net-autostart $NETWORK_NAME
        rm -f $NET_XML_FILE
    fi

}
