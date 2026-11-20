// Feather disable all
// @ignore
function Drago3D_Internals() {
    static Vertex = function(vbuff, x, y, z, nx, ny, nz, u, v, c, a) {
        vertex_position_3d(vbuff, x, y, z);
        vertex_normal(vbuff, nx, ny, nz);
        vertex_colour(vbuff, c, a);
        vertex_texcoord(vbuff, u, v);
    };
    
    static format = undefined;
    
    if (format == undefined) {
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_color();
        vertex_format_add_texcoord();
        format = vertex_format_end();
    }
    
    static Unarchive = function(archive, cache, archive_limit = 1000) {
        static age_limit = 60_000;
        
        if (ds_priority_size(archive) > archive_limit) {
            var oldest = ds_priority_find_min(archive);
            var oldest_time = ds_priority_find_priority(archive, oldest);
            
            if (current_time - oldest_time >= age_limit) {
                ds_priority_delete_value(archive, oldest);
                vertex_delete_buffer(oldest.vb);
                variable_struct_remove(cache, oldest.key);
            }
        }
    };
}

Drago3D_Internals();

global.__d3d_wireframe__ = false;