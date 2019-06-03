/// @description void ui_render_text_vrax(UIText, x, y);
/// @param UIText
/// @param x
/// @param y

if (string_length(Stuff.vra_name)==0) {
    argument0.text="Mesh file (vrax): <none loaded>";
} else {
    argument0.text="Mesh file (vrax): "+Stuff.vra_name;
}
ui_render_text(argument0, argument1, argument2);
