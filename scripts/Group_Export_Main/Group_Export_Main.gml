function project_export_global(buffer) {
    buffer_write(buffer, buffer_datatype, Game.meta.start.map);
    buffer_write(buffer, buffer_u16, Game.meta.start.x);
    buffer_write(buffer, buffer_u16, Game.meta.start.y);
    buffer_write(buffer, buffer_u16, Game.meta.start.z);
    buffer_write(buffer, buffer_u8, Game.meta.start.direction);
    buffer_write(buffer, buffer_string, Game.meta.project.id);
    buffer_write(buffer, buffer_u16, Game.meta.grid.chunk_size);
    
    buffer_write(buffer, buffer_field, pack(
        Game.meta.grid.snap
    ));
    
    buffer_write(buffer, buffer_s16, Game.meta.screen.width);
    buffer_write(buffer, buffer_s16, Game.meta.screen.height);
    
    var n_switches = array_length(Game.vars.switches);
    var n_variables = array_length(Game.vars.variables);
    buffer_write(buffer, buffer_u16, n_switches);
    buffer_write(buffer, buffer_u16, n_variables);
    
    for (var i = 0; i < n_switches; i++) {
        var sw_data = Game.vars.switches[i];
        buffer_write(buffer, buffer_string, sw_data.name);
        buffer_write(buffer, buffer_bool, sw_data.value);
    }
    
    for (var i = 0; i < n_variables; i++) {
        var var_data = Game.vars.variables[i];
        buffer_write(buffer, buffer_string, var_data.name);
        buffer_write(buffer, buffer_f32, var_data.value);
    }
    
    var n_constants = array_length(Game.vars.constants);
    buffer_write(buffer, buffer_u16, n_constants);
    for (var i = 0; i < n_constants; i++) {
        var constant = Game.vars.constants[i];
        var type = Stuff.data_type_meta[constant.type];
        buffer_write(buffer, buffer_string, constant.name);
        buffer_write(buffer, buffer_u16, type.id);
        buffer_write(buffer, type.buffer_type, constant.value);
    }
    
    // We don't need to save the effect marker names - those are just there for
    // the benefit of the editor
}

function project_export_language(buffer) {
    buffer_write(buffer, buffer_u32, array_length(Game.languages.names));
    for (var i = 0; i < array_length(Game.languages.names); i++) {
        buffer_write(buffer, buffer_string, Game.languages.names[i]);
    }
    
    var keys = variable_struct_get_names(Game.languages.text[$ Game.languages.names[0]]);
    buffer_write(buffer, buffer_u32, array_length(keys));
    for (var i = 0; i < array_length(keys); i++) {
        buffer_write(buffer, buffer_string, keys[i]);
    }
    
    for (var i = 0; i < array_length(Game.languages.names); i++) {
        var lang = Game.languages.text[$ Game.languages.names[i]];
        for (var j = 0; j < array_length(keys); j++) {
            buffer_write(buffer, buffer_string, lang[$ keys[j]]);
        }
    }
}

function project_export_standard(buffer, list, extra_param = true) {
    buffer_write(buffer, buffer_u32, array_length(list));
    for (var i = 0; i < array_length(list); i++) {
        list[i].Export(buffer, extra_param);
    }
}

function project_export_atlas(buffer, list) {
    var compilation = array_create(array_length(list));
    buffer_write(buffer, buffer_u32, array_length(list));
    if (array_length(compilation) > 0) {
        for (var i = 0; i < array_length(compilation); i++) {
            compilation[i] = list[i].picture;
        }
        var packed = sprite_atlas_pack_dll(compilation, 2, 4/*, force po2 setting*/);
        var w = sprite_get_width(packed.atlas);
        var h = sprite_get_height(packed.atlas);
        for (var i = 0; i < array_length(compilation); i++) {
            list[i].packed.x = packed.uvs[i].x / w;
            list[i].packed.y = packed.uvs[i].y / h;
            list[i].packed.w = packed.uvs[i].w / w;
            list[i].packed.h = packed.uvs[i].h / h;
        }
        buffer_write_sprite(buffer, packed.atlas);
    }
    project_export_standard(buffer, list, false);
}

function project_export_animations(buffer) {
    project_export_standard(buffer, Game.animations);
}

function project_export_events(buffer) {
    project_export_standard(buffer, Game.events.custom);
    var count_address = buffer_tell(buffer);
    buffer_write(buffer, buffer_u32, 0);
    var nodes = 0;
    for (var i = 0; i < array_length(Game.events.events); i++) {
        nodes += Game.events.events[i].Export(buffer);
    }
    buffer_poke(buffer, count_address, buffer_u32, nodes);
}

function project_export_meshes(buffer) {
    project_export_standard(buffer, Game.meshes);
    project_export_standard(buffer, Game.mesh_terrain);
}

function project_export_images(buffer) {
    project_export_standard(buffer, Game.graphics.tilesets);
    project_export_standard(buffer, Game.graphics.skybox);
    project_export_standard(buffer, Game.graphics.particles);
    //project_export_atlas(buffer, Game.graphics.overworlds);
    //project_export_atlas(buffer, Game.graphics.battlers);
    project_export_standard(buffer, Game.graphics.overworlds);
    project_export_standard(buffer, Game.graphics.battlers);
    project_export_standard(buffer, Game.graphics.etc);
    project_export_standard(buffer, Game.graphics.ui);
    project_export_standard(buffer, Game.graphics.tile_animations);
}

function project_export_audio(buffer) {
    project_export_standard(buffer, Game.audio.se);
    project_export_standard(buffer, Game.audio.bgm);
}

function project_export_data(buffer) {
    project_export_standard(buffer, Game.data);
}

function project_export_maps(buffer) {
    project_export_standard(buffer, Game.maps);
}

function project_export_terrain(buffer) {
    // not now, thanks
}