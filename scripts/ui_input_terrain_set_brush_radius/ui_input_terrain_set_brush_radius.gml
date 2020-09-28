function ui_input_terrain_set_brush_radius(bar) {
    Stuff.terrain.radius = normalize(bar.value, Stuff.terrain.brush_min, Stuff.terrain.brush_max, 0, 1);
    bar.root.element_brush_radius.text = "Brush radius: " + string(Stuff.terrain.radius) + " cells";
}