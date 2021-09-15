/// Loads a .dae (Collada) file from disk and turns it into a vertex buffer
/// @jujuadams
/// 
/// This isn't a full implementation of the .dae format, but it's a starting point at least
/// 
/// Texture coordinates for a .dae model will typically be normalised and in the
/// range (0,0) -> (1,1). Please use another script to remap texture coordinates
/// to GameMaker's atlased UV space.
/// 
/// @param filename        File to read from
/// @param flipUVs         Whether to flip the y-axis (V-component) of the texture coordinates. This is useful to correct for DirectX / OpenGL idiosyncrasies
/// @param reverseTris     Whether to reverse the triangle definition order to be compatible with the culling mode of your choice (clockwise/counter-clockwise)

function dotdae_model_load_file(_filename)
{
    var _buffer = buffer_load(_filename);
    var _result = dotdae_model_load(_buffer);
    buffer_delete(_buffer);
    return _result;
}