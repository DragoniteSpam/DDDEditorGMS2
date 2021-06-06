/// @param UIList
function ui_render_list_data_instances(argument0, argument1, argument2) {

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var otext = list.text;
    var otextvacant = list.text_vacant;

    var data = guid_get(list.root.active_type_guid);

    if (data) {
        if (data.type == DataTypes.DATA) {
            list.entries = data.instances;
        } else {
            list.text_vacant = "<Enums can't be instantiated>";
            list.entries = [];
        }
    } else {
        list.entries = [];
    }

    ui_render_list(list, xx, yy);

    list.text = otext;
    list.text_vacant = otextvacant;


}
