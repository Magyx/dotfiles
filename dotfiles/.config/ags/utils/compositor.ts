import GLib from 'gi://GLib';

export async function loadCompositor() {
    const HIS = GLib.getenv('HYPRLAND_INSTANCE_SIGNATURE');
    const SWAYSOCK = GLib.getenv('SWAYSOCK');
    
    let compositorModule;

    if (HIS) {
        compositorModule = await import('resource://com/github/Aylur/ags/service/hyprland.js');
    } else if (SWAYSOCK) {
        compositorModule = import('../services/sway.js');
    } else {
        compositorModule = {};
    }

    return compositorModule;
}