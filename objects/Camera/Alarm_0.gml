/// @description we're okay with this being an alarm because it can happen on its own regardless of what else is happening

alarm[ALARM_CAMERA_SAVE] = room_speed * CAMERA_SAVE_FREQUENCY;

ini_open(DATA_INI);
ini_write_real("Camera", "x", x);
ini_write_real("Camera", "y", y);
ini_write_real("Camera", "z", z);

ini_write_real("Camera", "xto", xto);
ini_write_real("Camera", "yto", yto);
ini_write_real("Camera", "zto", zto);

ini_write_real("Camera", "xup", xup);
ini_write_real("Camera", "yup", yup);
ini_write_real("Camera", "zup", zup);

ini_write_real("Camera", "fov", fov);
ini_write_real("Camera", "pitch", pitch);
ini_write_real("Camera", "direction", direction);

ini_write_real("Camera", "ax", anim_x);
ini_write_real("Camera", "ay", anim_y);
ini_write_real("Camera", "az", anim_z);

ini_write_real("Camera", "axto", anim_xto);
ini_write_real("Camera", "ayto", anim_yto);
ini_write_real("Camera", "azto", anim_zto);

ini_write_real("Camera", "axup", anim_xup);
ini_write_real("Camera", "ayup", anim_yup);
ini_write_real("Camera", "azup", anim_zup);

ini_write_real("Camera", "afov", anim_fov);
ini_write_real("Camera", "apitch", anim_pitch);
ini_write_real("Camera", "adirection", anim_direction);
ini_close();