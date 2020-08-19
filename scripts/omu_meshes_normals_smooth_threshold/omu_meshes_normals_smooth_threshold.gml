/// @param UIInput
function omu_meshes_normals_smooth_threshold(argument0) {

    var input = argument0;
    Stuff.setting_normal_threshold = real(input.value);
    setting_set("Config", "normal-threshold", Stuff.setting_normal_threshold);


}
