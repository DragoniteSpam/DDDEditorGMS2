event_inherited();

value = 0;
width = 128;
height = 24;

outline = false;

onvaluechange = null;
render = ui_render_radio_array;

GetHeight = function() {
    return self.height * (1 + ds_list_size(self.contents));
};