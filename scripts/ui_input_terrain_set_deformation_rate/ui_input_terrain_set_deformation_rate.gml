function ui_input_terrain_set_deformation_rate(bar) {
    Stuff.terrain.rate = normalize(bar.value, Stuff.terrain.rate_min, Stuff.terrain.rate_max, 0, 1);
    bar.root.element_deform_rate.text = "Deformation rate: " + string_format(Stuff.terrain.rate, 1, 3);
}