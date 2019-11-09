switch (mode) {
    case EditorModes.EDITOR_3D: script_execute(map.render, map); break;
    case EditorModes.EDITOR_EVENT: script_execute(event.render, event); break;
    case EditorModes.EDITOR_DATA: script_execute(data.render, data); break;
    case EditorModes.EDITOR_ANIMATION: script_execute(animation.render, animation); break;
    case EditorModes.EDITOR_HEIGHTMAP: script_execute(terrain.render, terrain); break;
}

// these shouldn't be attached to any one view or anything
// would put this in the draw gui event except i dont know what would
// happen to the cursor on that layer and i dont feel like finding out
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
 * 7. overlay - always on, may not always have stuff in it
 */