event_inherited();

var camera = view_get_camera(view_3d);

x = setting_get("Map", "x", 0);
y = setting_get("Map", "y", 0);
z = setting_get("Map", "z", 100);

xto = setting_get("Map", "xto", 512);
yto = setting_get("Map", "yto", 512);
zto = setting_get("Map", "zto", 0);

xup = 0;
yup = 0;
zup = 1;

fov = setting_get("Map", "fov", 50);
pitch = setting_get("Map", "pitch", 0);
direction = setting_get("Map", "direction", 0);

render = editor_render_spart;
ui = ui_init_spart(id);
mode_id = ModeIDs.SPART;