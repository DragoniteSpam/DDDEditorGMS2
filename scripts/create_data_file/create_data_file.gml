function create_data_file(name, compressed) {
    var data = instance_create_depth(0, 0, 0, DataDataFile);
    internal_name_set(data, name);
    data.compressed = compressed;
    instance_deactivate_object(data);
    return data;
}