/// @param Data
/// @param target-name
function internal_name_generate() {

    var data = argument[0];
    var base_name = argument[1];
    var target_name = base_name;

    var n = 0;
    while (internal_name_get(target_name)) {
        target_name = base_name + "_" + string_hex(n++, 4);
    }

    internal_name_set(data, target_name);


}
