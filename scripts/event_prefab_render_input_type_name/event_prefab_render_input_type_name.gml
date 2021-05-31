function event_prefab_render_input_type_name(event, index) {
    switch (event.custom_data[2][0]) {
        case 0: return "Text";
        case 1: return "Text (Scribble safe)";
        case 2: return "Integer";
        case 3: return "Unsigned Integer";
        case 4: return "Floating Point";
    }
    
    return "?";
}