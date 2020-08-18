/// @param UIThing
function omu_mesh_export_selected(argument0) {

	var thing = argument0;

	var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

	if (data) {
	    var fn = get_save_filename_mesh();
    
	    if (string_length(fn) > 0) {
	        switch (filename_ext(fn)) {
	            case ".obj": export_obj(fn, data); break;
	            case ".d3d": case ".gmmod": export_d3d(fn, data); break;
	        }
	    }
	}


}
