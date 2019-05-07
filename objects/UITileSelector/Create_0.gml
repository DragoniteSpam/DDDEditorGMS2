event_inherited();

// in pixels
tile_view_x=0;
tile_view_y=0;
width=256;
height=256;
// not doing zoom for now because i dont feel like doing all that math
// (it's not actually that much math i'm just lazy)
//zoom=1;

// for panning around
offset_x=-1;
offset_y=-1;

onvaluechange=null;
onvaluechangebackwards=null;
render=ui_render_tile_selector;

