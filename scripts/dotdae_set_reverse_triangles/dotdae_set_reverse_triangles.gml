/// @param state   Whether to reverse the triangle definition order to be compatible with the culling mode of your choice (clockwise/counter-clockwise)

function dotdae_set_reverse_triangles(_state)
{
    global.__dotdae_reverse_triangles = _state;
}