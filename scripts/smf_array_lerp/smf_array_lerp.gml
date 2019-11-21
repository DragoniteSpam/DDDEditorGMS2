/// @description smf_array_lerp(arr1, arr2, amount)
/// @param arr1
/// @param arr2
/// @param amount
var arr1 = argument0;
var arr2 = argument1;
var amount = argument2;
var ret = arr2;
var l1 = array_length_1d(arr1);
var l2 = array_length_1d(arr2);
var l = l1;
if l2 < l1
{
    ret = arr1;
    l = l2;
}
for (var i = 0; i < l; i ++)
{
    ret[i] = lerp(arr1[i], arr2[i], amount);
}
return ret;