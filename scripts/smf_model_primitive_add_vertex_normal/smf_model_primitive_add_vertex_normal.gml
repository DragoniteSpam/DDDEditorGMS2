/// @description smf_model_primitive_add_vertex(modelIndex, x, y, z, nx, ny, nz, u, v, color, alpha);
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/// @param nx
/// @param ny
/// @param nz
/// @param u
/// @param v
function smf_model_primitive_add_vertex_normal(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10) {
    var modelIndex = argument0;
    var materials = modelIndex[| SMF_model.Material];
    var bufArray = modelIndex[| SMF_model.MBuff];

    var mBuff = bufArray[0];

    buffer_write(mBuff, buffer_f32, argument1);
    buffer_write(mBuff, buffer_f32, argument2);
    buffer_write(mBuff, buffer_f32, argument3);
    buffer_write(mBuff, buffer_f32, argument4);
    buffer_write(mBuff, buffer_f32, argument5);
    buffer_write(mBuff, buffer_f32, argument6);
    buffer_write(mBuff, buffer_f32, argument7);
    buffer_write(mBuff, buffer_f32, argument8);

    buffer_write(mBuff, buffer_u8, color_get_red(argument9));
    buffer_write(mBuff, buffer_u8, color_get_green(argument9));
    buffer_write(mBuff, buffer_u8, color_get_blue(argument9));
    buffer_write(mBuff, buffer_u8, argument10 * 255);

    repeat 8{buffer_write(mBuff, buffer_u8, 0);}


}
