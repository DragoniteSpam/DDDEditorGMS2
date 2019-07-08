event_inherited();

z = 0;

// no drag because you can only ever select the cell you click on
onmousedown = sme_down_single;
area = selected_area_single;
render = selection_render_single;

foreach_cell = selection_foreach_cell_single;

selected_determination = selected_single;
selected_border_determination = selected_border_single;