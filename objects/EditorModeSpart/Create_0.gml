event_inherited();

var camera = view_get_camera(view_3d);

x = setting_get("Spart", "x", 0);
y = setting_get("Spart", "y", 512);
z = setting_get("Spart", "z", 128);

xto = setting_get("Spart", "xto", 0);
yto = setting_get("Spart", "yto", 0);
zto = setting_get("Spart", "zto", 0);

xup = 0;
yup = 0;
zup = 1;

fov = setting_get("Spart", "fov", 60);
pitch = setting_get("Spart", "pitch", arctan2(z, point_distance(0, 0, x, y)));
direction = setting_get("Spart", "direction", point_direction(x, y, 0, 0));

render = editor_render_spart;
ui = ui_init_spart(id);
mode_id = ModeIDs.SPART;