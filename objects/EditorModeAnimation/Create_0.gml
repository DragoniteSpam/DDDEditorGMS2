event_inherited();

render = editor_render_animation;

x = setting_get("Animation", "x", 0);
y = setting_get("Animation", "y", 100);
z = setting_get("Animation", "z", 100);

xto = setting_get("Animation", "xto", 0);
yto = setting_get("Animation", "yto", 0);
zto = setting_get("Animation", "zto", 0);

xup = setting_get("Animation", "xup", 0);
yup = setting_get("Animation", "yup", 0);
zup = setting_get("Animation", "zup", 1);

fov = setting_get("Animation", "fov", 50);
pitch = setting_get("Animation", "pitch", 0);
direction = setting_get("Animation", "direction", 0);

ui = ui_init_animation(id);