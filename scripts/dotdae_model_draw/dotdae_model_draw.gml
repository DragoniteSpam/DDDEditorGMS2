/// @param container

var _container = argument0;

var _geometry_list = _container[eDotDae.GeometryList];
var _g = 0;
repeat(ds_list_size(_geometry_list))
{
    var _geometry = _geometry_list[| _g];
    var _mesh_array = _geometry[eDotDaeGeometry.MeshArray];
    
    var _m = 0;
    repeat(array_length_1d(_mesh_array))
    {
        var _mesh = _mesh_array[_m];
        var _vbuff_array = _mesh[eDotDaeMesh.VertexBufferArray];
        
        var _v = 0;
        repeat(array_length_1d(_vbuff_array))
        {
            var _vertex_buffer = _vbuff_array[_v];
            var _diffuse_texture = -1;
            
            var _effect = _vertex_buffer[eDotDaePolyList.Effect];
            if (is_array(_effect)) _diffuse_texture = _effect[eDotDaeEffect.DiffuseTexture];
            
            vertex_submit(_vertex_buffer[eDotDaePolyList.VertexBuffer], pr_trianglelist, _diffuse_texture);
            
            ++_v;
        }
        
        ++_m;
    }
    
    ++_g;
}