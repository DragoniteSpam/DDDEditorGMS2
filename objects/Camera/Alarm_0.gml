/// @description  we're okay with this being an alarm because it can happen on its own regardless of what else is happening

alarm[ALARM_CAMERA_SAVE]=room_speed*CAMERA_SAVE_FREQUENCY;

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
ini_close();

