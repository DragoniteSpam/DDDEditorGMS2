function setting_get(object, name, def) {
    var domain = Stuff.settings[? object];
    if (domain) {
        if (ds_map_exists(domain, name)) return domain[? name];
        return def;
    }

    throw "Setting object not found: " + object;
}

function setting_project_add(name) {
    // this just logs it in projects.json; it doesn't add any of the data files
    if (ds_list_find_index(Stuff.all_projects[? "projects"], name) == -1) {
        ds_list_add(Stuff.all_projects[? "projects"], name);
    }
    
    var buffer = buffer_create(32, buffer_grow, 1);
    buffer_write(buffer, buffer_text, json_encode(Stuff.all_projects));
    buffer_save_ext(buffer, "projects.json", 0, buffer_tell(buffer));
    buffer_delete(buffer);
}

function setting_project_create_local(projname, filename, buffer) {
    var auto_folder = PATH_PROJECTS + projname + "\\";
    if (!directory_exists(auto_folder)) {
        directory_create(auto_folder);
    }
    
    buffer_save_ext(buffer, auto_folder + filename, 0, buffer_get_size(buffer));
}

function setting_set(object, name, value) {
    var domain = Stuff.settings[? object];
    
    if (domain) {
        domain[? name] = value;
    } else {
        show_error("Setting object not found: " + object, false);
    }
}