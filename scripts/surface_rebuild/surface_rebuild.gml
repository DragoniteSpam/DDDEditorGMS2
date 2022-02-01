function surface_rebuild(original, w, h) {
    if (!surface_exists(original)) return surface_create(w, h);
    
    if (surface_get_width(original) != w || surface_get_height(original) != h) {
        surface_free(original);
        return surface_create(w, h);
    }
    
    return original;
}