/// @description  Select stuff with the mouse

if (get_release_escape()){
    __view_set( e__VW.Visible, view_3d_preview, false );
    return 0;
}

var rotation_rate=2;
var translation_rate=1;
var scale_rate=1.01;

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

if (keyboard_check(vk_shift)){
    if (keyboard_check(vk_up)||keyboard_check(ord("W"))){
        Camera.mesh_z=Camera.mesh_z-translation_rate;
    }
    if (keyboard_check(vk_down)||keyboard_check(ord("S"))){
        Camera.mesh_z=Camera.mesh_z+translation_rate;
    }
    if (keyboard_check(vk_left)||keyboard_check(ord("A"))){
        Camera.mesh_zrot=Camera.mesh_zrot-rotation_rate;
    }
    if (keyboard_check(vk_right)||keyboard_check(ord("D"))){
        Camera.mesh_zrot=Camera.mesh_zrot+rotation_rate;
    }
} else if (keyboard_check(vk_control)){
    if (keyboard_check(vk_up)||keyboard_check(ord("W"))){
        Camera.mesh_yrot=Camera.mesh_yrot-translation_rate;
    }
    if (keyboard_check(vk_down)||keyboard_check(ord("S"))){
        Camera.mesh_yrot=Camera.mesh_yrot+translation_rate;
    }
    if (keyboard_check(vk_left)||keyboard_check(ord("A"))){
        Camera.mesh_xrot=Camera.mesh_xrot-rotation_rate;
    }
    if (keyboard_check(vk_right)||keyboard_check(ord("D"))){
        Camera.mesh_xrot=Camera.mesh_xrot+rotation_rate;
    }
} else if (keyboard_check(vk_alt)){
    if (keyboard_check(vk_up)||keyboard_check(ord("W"))){
        Camera.mesh_scale=min(Camera.mesh_scale*scale_rate, 10);
    }
    if (keyboard_check(vk_down)||keyboard_check(ord("S"))){
        Camera.mesh_scale=max(Camera.mesh_scale/scale_rate, 0.1);
    }
} else {
    if (keyboard_check(vk_up)||keyboard_check(ord("W"))){
        Camera.mesh_y=Camera.mesh_y-translation_rate;
    }
    if (keyboard_check(vk_down)||keyboard_check(ord("S"))){
        Camera.mesh_y=Camera.mesh_y+translation_rate;
    }
    if (keyboard_check(vk_left)||keyboard_check(ord("A"))){
        Camera.mesh_x=Camera.mesh_x-translation_rate;
    }
    if (keyboard_check(vk_right)||keyboard_check(ord("D"))){
        Camera.mesh_x=Camera.mesh_x+translation_rate;
    }
}

if (keyboard_check(vk_backspace)||keyboard_check(vk_delete)){
    Camera.mesh_x=0;
    Camera.mesh_y=0;
    Camera.mesh_z=0;
    Camera.mesh_xrot=0;
    Camera.mesh_yrot=0;
    Camera.mesh_zrot=0;
    Camera.mesh_scale=1;
}
