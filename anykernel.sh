# AnyKernel3 chat script configuration for OP-ACE-6T (PLR110 / SM8845)
# Modified for OnePlus Ace 6T

# Don't modify any of the below unless you know what you're doing.
kernel.string=OP-ACE-6T Kernel (SM8845)
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=PLR110
device.name2=OP-ACE-6T
device.name3=OnePlus Ace 6T
device.name4=oneplus6
device.name5=
supported.versions=
supported.patchlevels=
supported.versions=13, 14, 15, 16

# AnyKernel3 will resize the boot image to fit the kernel.
# This is a good default for most devices.
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;

# AnyKernel3 patch if needed
# patch_cmdline "opt1=val" "opt2=val"

#--- Initialization & Error Handling ---#

umount2() {
    mkdir -p /tmp/anykernel; $bin/umount -l "$1" 2>/dev/null;
}

ui_print() {
    echo -e "ui_print $1\nui_print" > /proc/last_kmsg;
    echo -e "ui_print $1\nui_print" > /tmp/recovery.log;
    echo -e "ui_print $1\nui_print";
}

abort() {
    ui_print "$1";
    exit 1;
}

file_install() {
    if [ -f "/tmp/anykernel/$1" ]; then
        $bin/cp -af "/tmp/anykernel/$1" "$2" 2>/dev/null || {
            ui_print "Install of $1 failed!";
            abort "Aborting...";
        };
    fi;
}

set_perm() {
    $bin/chown $1:$2 "$4";
    $bin/chmod $3 "$4";
}

set_extra_perm() {
    $bin/chown $1:$2 "$4";
    $bin/chmod $3 "$4";
}

#--- End Initialization & Error Handling ---#

#--- AnyKernel Functions ---#

grep_prop() {
    REGEX="s/^$1=//p"
    shift
    local FILES=$@
    [ -z "$FILES" ] && FILES='/system/build.prop'
    cat $FILES 2>/dev/null | sed -e "$REGEX" | head -n 1
}

is_good() {
    [ "$1" = "1" ] && echo "1" || echo ""
}

#--- End AnyKernel Functions ---#

#--- Main Logic ---#

ui_print " "
ui_print "OP-ACE-6T Custom Kernel (SM8845)"
ui_print " "
ui_print "Device: $(grep_prop ro.product.model)"
ui_print "Android: $(grep_prop ro.build.version.release)"
ui_print " "

# Verify device
if [ "$do.devicecheck" = "1" ]; then
    DEVICE="$(grep_prop ro.product.device)"
    ui_print "Checking device compatibility..."
    case "$DEVICE" in
        PLR110|OP-ACE-6T|oneplus6)
            ui_print "  Device check passed: $DEVICE"
            ;;
        *)
            ui_print "  WARNING: Device mismatch! Expected PLR110/OP-ACE-6T"
            ui_print "  Detected: $DEVICE"
            ui_print "  Continuing anyway..."
            ;;
    esac
fi

ui_print " "
ui_print "Installing kernel..."
ui_print " "

# Kernel installation
blockdev=$block
if [ -n "$blockdev" ]; then
    ui_print "Backing up current boot image..."
    dd if=$blockdev of=/tmp/anykernel/backup_boot.img 2>/dev/null
    ui_print "Installing new kernel to $blockdev..."
    dd if=/tmp/anykernel/Image of=$blockdev 2>/dev/null || {
        ui_print "Failed to install kernel!";
        abort "Aborting...";
    }
    ui_print "Kernel installed successfully!"
else
    ui_print "ERROR: No boot partition found!";
    abort "Aborting...";
fi

ui_print " "
ui_print "Installation complete!"
ui_print "Rebooting device..."
ui_print " "

#--- End Main Logic ---#
