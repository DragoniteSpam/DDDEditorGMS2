/// @description smf_model_primitive_add_vertex(modelIndex, x, y, z, u, v, color, alpha);
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/// @param u
/// @param v
function smf_model_primitive_add_vertex(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
    var modelIndex = argument0;
    var materials = modelIndex[| SMF_model.Material];
    var bufArray = modelIndex[| SMF_model.MBuff];

    var mBuff = bufArray[0];

    buffer_write(mBuff, buffer_f32, argument1);
    buffer_write(mBuff, buffer_f32, argument2);
    buffer_write(mBuff, buffer_f32, argument3);
    buffer_write(mBuff, buffer_f32, 0);
    buffer_write(mBuff, buffer_f32, 0);
    buffer_write(mBuff, buffer_f32, 1);
    buffer_write(mBuff, buffer_f32, argument4);
    buffer_write(mBuff, buffer_f32, argument5);

    buffer_write(mBuff, buffer_u8, color_get_red(argument6));
    buffer_write(mBuff, buffer_u8, color_get_green(argument6));
    buffer_write(mBuff, buffer_u8, color_get_blue(argument6));
    buffer_write(mBuff, buffer_u8, argument7 * 255);

    repeat 8{buffer_write(mBuff, buffer_u8, 0);}


}
