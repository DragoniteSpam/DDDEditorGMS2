/// @param Dialog
/// @param format-index
function dialog_create_mesh_vertex_format_editor(argument0, argument1) {

    var root = argument0;
    var format_index = argument1;
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

    var el_name = create_input(c1x, yy, "Name: ", ew, eh, omu_meshes_vertex_format_name, mode.format_names[| format_index], "string", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    yy += el_name.height + spacing;

    var el_list = create_list(c1x, yy, "Attributes: ", "no attributes", ew, eh, 8, omu_meshes_vertex_attribute_list, false, dg);
    el_list.tooltip = "The vertex attributes to be included when you export meshes as vertex buffers. Each of the first 3D position, normal, texture coordinate and color will contain the values of the imported meshes; others will be initialized to zero.";
    dg.el_list = el_list;
    yy += ui_get_list_height(el_list) + spacing;

    var el_add = create_button(c1x, yy, "Add Attribute", ew, eh, fa_center, omu_meshes_vertex_format_add_attribute, dg);
    el_list.tooltip = "Add a vertex attribute";
    yy += el_add.height + spacing;

    var el_remove = create_button(c1x, yy, "Remove Attribute", ew, eh, fa_center, omu_meshes_vertex_format_remove_attribute, dg);
    el_list.tooltip = "Remove a vertex attribute";
    yy += el_remove.height + spacing;

    yy = yy_start;

    var el_attribute_label = create_text(c2x, yy, "[c_blue]Attributes", ew, eh, fa_left, ew, dg);
    yy += el_name.height + spacing;

    var el_attribute_name = create_input(c2x, yy, "Name: ", ew, eh, omu_meshes_vertex_attribute_name, "", "string", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
    el_list.tooltip = "The name of the vertex attribute (this is for your benefit and has no impact on how the mesh is exported)";
    dg.el_attribute_name = el_attribute_name;
    yy += el_attribute_name.height + spacing;

    var el_attribute_type = create_radio_array(c2x, yy, "Type:", ew, eh, omu_meshes_vertex_attribute_type, -1, dg);
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
