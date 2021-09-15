/// @param state   Whether to flip the y-axis (V-component) of the texture coordinates. This is useful to correct for DirectX / OpenGL idiosyncrasies

function dotdae_set_flip_texcoord_v(_state)
{
    global.__dotdae_flip_texcoord_v = _state;
}