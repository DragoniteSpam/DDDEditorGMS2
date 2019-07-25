/// @description Anything visible in the world

switch (mode) {
    case EditorModes.EDITOR_3D:
        switch (view_current) {
            case view_3d:
                draw_clear(c_black);
                draw_editor_3d();
                break;
            case view_ribbon:
                draw_editor_menu();
                break;
            case view_hud:
                draw_editor_hud();
                break;
            case view_3d_preview:
                // the pop-out window that isn't really a pop-out window
                draw_clear(c_black);
                draw_preview_3d();
                draw_preview_3d_overlay();
                break;
        }
        break;
    case EditorModes.EDITOR_EVENT:
        gpu_set_cullmode(cull_noculling);
        switch (view_current) {
            case view_fullscreen:
                draw_editor_event();
                break;
            case view_ribbon:
                draw_editor_menu();
                break;
            case view_hud:
                draw_editor_event_hud();
                break;
        }
        break;
    case EditorModes.EDITOR_DATA:
        gpu_set_cullmode(cull_noculling);
        switch (view_current) {
            case view_fullscreen:
                draw_editor_data();
                break;
            case view_ribbon:
                draw_editor_menu();
                break;
        }
        break;
}

// these shouldn't be attached to any one view or anything
if (view_current == view_invisible) {
    if (!dialog_exists()) {
        control_global();
    }
}

/*
 * please don't touch these settings, or any of the other settings relating to
 * the room/views, unless you know what you're doing and are prepared for pain
 *
 * Views:
 *
 * 0. fullscreen
 * 1. 3D
 * 2. Ribbon
 * 3. HUD (side)
 * 4. 3D Preview
 * 5.
 * 6.
 * 7. invisible - always, on, doesn't render
 */