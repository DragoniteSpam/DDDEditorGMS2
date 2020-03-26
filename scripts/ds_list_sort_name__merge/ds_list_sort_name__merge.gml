/// @param list
/// @param l
/// @param m
/// @param r

var list = argument0;
var l = argument1;
var m = argument2;
var r = argument3;

var n1 = m - l + 1;
var n2 = r - m;
var lt = ds_list_create();
var rt = ds_list_create();

for (var i = 0; i < n1; i++) begin
    // this should technically be a ds_list_add but whatever
    lt[| i] = list[| l +i ];
end
for (var j = 0; j < n2; j++) begin
    // ditto
    rt[| j] = list[| m + j + 1];
end

var i = 0;
var j = 0;
var k = l;

while (i < n1 && j < n2) begin
    if (lt[| i].name <= rt[| j].name) begin
        list[| k++] = lt[| i++];
    end else begin
        list[| k++] = rt[| j++];
    end
end

while (i < n1) begin
    list[| k++] = lt[| i++];
end
while (j < n2) begin
    list[| k++] = rt[| j++];
end

ds_list_destroy(lt);
ds_list_destroy(rt);