comp_check() {
    ui_print " " "Checking boot kernel..."
    [ -f "$SPLITIMG/kernel" ] || abort "Cannot find the boot kernel.";
    if grep -qs "ignore_builtin_recovery" "$SPLITIMG/kernel"; then
        ui_print " " "e+ kernel detected.";
        rd_comp=lzma;
    else
        rd_comp=lz4_legacy;
    fi
}
comp_ramdisk() {
    [ -z "$rd_comp" ] && abort "Cannot detect ramdisk compression.";
    [ -f "$AKHOME/recovery.cpio" ] || abort "Recovery ramdisk not found.";
    ui_print " " "Compressing ramdisk... ($rd_comp)";
    rm "$SPLITIMG/ramdisk.cpio";
    magiskboot compress=$rd_comp "$AKHOME/recovery.cpio" "$SPLITIMG/ramdisk.cpio";
}
disable_twrp() {
    [ "$rd_comp" = "lzma" ] || return
    grep -qs "ignore_builtin_recovery" "$SPLITIMG/header" && return
    ui_print " " "Disabling TWRP...";
    sed -i '$ s/$/ ignore_builtin_recovery/' "$SPLITIMG/header";
}
