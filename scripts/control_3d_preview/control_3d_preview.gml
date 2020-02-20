if (Controller.press_escape) {
    view_set_visible(view_3d_preview, false);
    return 0;
}

var rotation_rate = 2;
var translation_rate = 1;
var scale_rate = 1.01;
var mesh = Stuff.mesh_preview;

/*
 * action           input       modifier
 * translate x:     left/right
 * translate y:     up/down
 * translate z:     up/down     shift
 * translate xrot:  left/right  control
 * translate yrot:  up/down     control
 * translate zrot:  left/right  shift 
 * scale:           up/down     alt
 */

if (keyboard_check(vk_shift)) {
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        Stuff.mesh_z = Stuff.mesh_z - translation_rate;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        Stuff.mesh_z = Stuff.mesh_z + translation_rate;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        Stuff.mesh_zrot = Stuff.mesh_zrot - rotation_rate;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        Stuff.mesh_zrot = Stuff.mesh_zrot + rotation_rate;
    }
} else if (keyboard_check(vk_control)) {
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        Stuff.mesh_yrot = Stuff.mesh_yrot - translation_rate;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        Stuff.mesh_yrot = Stuff.mesh_yrot + translation_rate;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        Stuff.mesh_xrot = Stuff.mesh_xrot - rotation_rate;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        Stuff.mesh_xrot = Stuff.mesh_xrot + rotation_rate;
    }
} else if (keyboard_check(vk_alt)) {
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        Stuff.mesh_scale = min(Stuff.mesh_scale * scale_rate, 10);
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        Stuff.mesh_scale = max(Stuff.mesh_scale / scale_rate, 0.1);
    }
} else {
    if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
        Stuff.mesh_y = Stuff.mesh_y - translation_rate;
    }
    if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
        Stuff.mesh_y = Stuff.mesh_y + translation_rate;
    }
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        Stuff.mesh_x = Stuff.mesh_x - translation_rate;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        Stuff.mesh_x = Stuff.mesh_x + translation_rate;
    }
}

if (keyboard_check_pressed(vk_tab)) {
    var length = ds_list_size(mesh.submeshes);
    if (keyboard_check(vk_shift)) {
        mesh.preview_index = ++mesh.preview_index % length;
    } else {
        mesh.preview_index = (--mesh.preview_index + length) % length;
    }
}

if (keyboard_check(vk_backspace) || keyboard_check(vk_delete)) {
    Stuff.mesh_x = 0;
    Stuff.mesh_y = 0;
    Stuff.mesh_z = 0;
    Stuff.mesh_xrot = 0;
    Stuff.mesh_yrot = 0;
    Stuff.mesh_zrot = 0;
    Stuff.mesh_scale = 1;
}