function import_3d_model_generic(filename, everything, raw_buffer, existing_mesh_data, replace_index) {
    // @todo try catch
    if (file_exists(filename)) {
        switch (filename_ext(filename)) {
            case ".obj": return import_obj(filename, everything, raw_buffer, existing_mesh_data, replace_index); break;
            case ".d3d": case ".gmmod": return import_d3d(filename, everything, raw_buffer, existing_mesh_data, replace_index); break;
            case ".smf": return import_smf(filename, existing_mesh_data, replace_index); break;
        }
    }
    return undefined;
}