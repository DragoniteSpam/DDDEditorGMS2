function dialog_create_mesh_vertex_format_editor(dialog, format_index) {
    var mode = Stuff.mesh_ed;
    
    var dw = 720;
    var dh = 480;
    
    var dg = dialog_create(dw, dh, "Vertex Format Settings", dialog_default, dc_close_no_questions_asked, root);
    dg.format_index = format_index;
    
    var columns = 2;
    var ew = dw / columns - 64;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var c1x = 0 * dw / columns + 32;
    var c2x = 1 * dw / columns + 32;
    var spacing = 16;
    
    var yy = 64;
    var yy_start = 64;
    
    var el_name = create_input(c1x, yy, "Name: ", ew, eh, function(input) {
        Stuff.mesh_ed.format_names[| input.root.format_index] = input.value;
    }, mode.format_names[| format_index], "string", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    yy += el_name.height + spacing;
    
    var el_list = create_list(c1x, yy, "Attributes: ", "no attributes", ew, eh, 8, function(list) {
        var format = Stuff.mesh_ed.formats[| list.root.format_index];
        var index = ui_list_selection(list);
        if (!(index + 1)) return;
        ui_input_set_value(list.root.el_attribute_name, list.entries[| index]);
        var attribute = format[? "attributes"][| index];
        list.root.el_attribute_type.value = attribute[? "type"];
    }, false, dg);
    el_list.tooltip = "The vertex attributes to be included when you export meshes as vertex buffers. Each of the first 3D position, normal, texture coordinate and color will contain the values of the imported meshes; others will be initialized to zero.";
    dg.el_list = el_list;
    yy += ui_get_list_height(el_list) + spacing;
    
    var el_add = create_button(c1x, yy, "Add Attribute", ew, eh, fa_center, function(button) {
        var format = Stuff.mesh_ed.formats[| button.root.format_index];
        var attribute_name = "Attribute" + string(ds_list_size(button.root.el_list.entries));
        ds_list_add(button.root.el_list.entries, attribute_name);
        var attributes = format[? "attributes"];
        var new_attribute = ds_map_create();
        new_attribute[? "name"] = attribute_name;
        new_attribute[? "type"] = VertexFormatData.POSITION_3D;
        ds_list_add(attributes, new_attribute);
        ds_list_mark_as_map(attributes, ds_list_size(attributes) - 1);
    }, dg);
    el_list.tooltip = "Add a vertex attribute";
    yy += el_add.height + spacing;
    
    var el_remove = create_button(c1x, yy, "Remove Attribute", ew, eh, fa_center, function(button) {
        var format = Stuff.mesh_ed.formats[| button.root.format_index];
        var index = ui_list_selection(button.root.el_list);
        if (!(index + 1)) return;
        ds_list_delete(button.root.el_list.entries, index);
        var attributes = format[? "attributes"];
        ds_list_delete(attributes, index);
    }, dg);
    el_list.tooltip = "Remove a vertex attribute";
    yy += el_remove.height + spacing;
    
    yy = yy_start;
    
    var el_attribute_label = create_text(c2x, yy, "[c_blue]Attributes", ew, eh, fa_left, ew, dg);
    yy += el_name.height + spacing;
    
    var el_attribute_name = create_input(c2x, yy, "Name: ", ew, eh, function(input) {
        var list = input.root.el_list;
        var format = Stuff.mesh_ed.formats[| input.root.format_index];
        var index = ui_list_selection(list);
        if (!(index + 1)) return;
        list.entries[| index] = input.value;
        format[? "attributes"][| index][? "name"] = input.value;
    }, "", "string", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_list.tooltip = "The name of the vertex attribute (this is for your benefit and has no impact on how the mesh is exported)";
    dg.el_attribute_name = el_attribute_name;
    yy += el_attribute_name.height + spacing;
    
    var el_attribute_type = create_radio_array(c2x, yy, "Type:", ew, eh, function(radio) {
        var list = radio.root.root.el_list;
        var format = Stuff.mesh_ed.formats[| radio.root.root.format_index];
        var index = ui_list_selection(list);
        if (!(index + 1)) return;
        format[? "attributes"][| index][? "type"] = radio.value;
    }, -1, dg);
    el_attribute_type.tooltip = "The data type of the vertex attribute";
    create_radio_array_options(el_attribute_type, ["Position (2D)", "Position (3D)", "Normal", "Texture Coordinate", "Color"]);
    dg.el_attribute_type = el_attribute_type;
    yy += ui_get_radio_array_height(el_attribute_type) + spacing;
    
    var format = mode.formats[| format_index];
    var attributes = format[? "attributes"];
    for (var i = 0; i < ds_list_size(attributes); i++) {
        var att = attributes[| i];
        ds_list_add(el_list.entries, att[? "name"]);
    }
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);
    
    ds_list_add(dg.contents,
        el_name, el_list, el_add, el_remove,
        el_attribute_label, el_attribute_name, el_attribute_type,
        el_confirm
    );
    
    return dg;
}