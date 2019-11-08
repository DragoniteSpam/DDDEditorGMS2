/// @description Anything visible in the world

switch (mode) {
    case EditorModes.EDITOR_3D:

        break;
    case EditorModes.EDITOR_EVENT:
        gpu_set_cullmode(cull_noculling);
        switch (view_current) {
            case view_fullscreen: draw_editor_event(); break;
            case view_ribbon: draw_editor_menu(); break;
            case view_hud: draw_editor_event_hud(); break;
        }
        break;
    case EditorModes.EDITOR_DATA:
        gpu_set_cullmode(cull_noculling);
        switch (view_current) {
            case view_fullscreen: draw_editor_data(); break;
            case view_ribbon: draw_editor_menu(); break;
        }
        break;
    case EditorModes.EDITOR_ANIMATION:
        gpu_set_cullmode(cull_noculling);
        switch (view_current) {
            case view_fullscreen: draw_editor_animation(); break;
            case view_3d: draw_animator(); draw_animator_overlay(); break;
            case view_ribbon: draw_editor_menu(); break;
        }
        break;
    case EditorModes.EDITOR_HEIGHTMAP:
        gpu_set_cullmode(cull_noculling);
        switch (view_current) {
            case view_3d: draw_editor_terrain(); break;
            case view_ribbon: draw_editor_menu(true); break;
            case view_hud: draw_editor_terrain_hud(); break;
        }
        break;
}

// these shouldn't be attached to any one view or anything
if (view_current == view_overlay) {
    for (var i = 0; i < ds_list_size(dialogs); i++) {
        var thing = dialogs[| i];
        script_execute(thing.render, thing);
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
 * 7. invisible - always on, doesn't render
 */