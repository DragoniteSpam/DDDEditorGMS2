function proto_guid_remove(container, guid) {
    if (container.proto_guids[$ guid]) {
        variable_struct_remove(container.proto_guids, guid);
    }
}

function proto_guid_generate(container) {
    do {
        var n = Stuff.game_asset_id + ":" + string_hex(container.proto_guid_current++, 8);
    } until (!container.proto_guids[$ n]);
    
    return n;
}

function proto_guid_get(container, guid) {
    return container.proto_guids[$ guid];
}

function proto_guid_set(container, data, value) {
    if (value == undefined) value = proto_guid_generate(container);
    
    container.proto_guids[$ value] = data;
    if (container.first_proto_guid == NULL) {
        container.first_proto_guid = value;
    }
}