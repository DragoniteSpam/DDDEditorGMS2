/// @param container
/// @param texture
function dotdae_model_draw_texture(argument0, argument1) {

    var _container = argument0;
    var _texture   = argument1;

    var _geometry_list = _container[eDotDae.GeometryList];
    var _g = 0;
    repeat(ds_list_size(_geometry_list))
    {
        var _geometry = _geometry_list[| _g];
        var _mesh_array = _geometry[eDotDaeGeometry.MeshArray];
    
        var _m = 0;
        repeat(array_length(_mesh_array))
        {
            var _mesh = _mesh_array[_m];
            var _vbuff_array = _mesh[eDotDaeMesh.VertexBufferArray];
        
            var _v = 0;
            repeat(array_length(_vbuff_array))
            {
                var _vertex_buffer = _vbuff_array[_v];
                vertex_submit(_vertex_buffer[eDotDaePolyList.VertexBuffer], pr_trianglelist, _texture);
                ++_v;
            }
        
            ++_m;
        }
    
        ++_g;
    }


}
