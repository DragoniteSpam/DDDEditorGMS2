/// @param list
/// @param [l]
/// @param [r]
// sorts by data.name instead of data

var list = argument[0];
var l = (argument_count > 1) ? argument[1] : 0;
var r = (argument_count > 2) ? argument[2] : ds_list_size(list) - 1;

if (l < r) begin
    var m = (l + r) div 2;
    ds_list_sort_name(list, l, m);
    ds_list_sort_name(list, m + 1, r);
    ds_list_sort_name__merge(list, l, m, r);
end

return list;