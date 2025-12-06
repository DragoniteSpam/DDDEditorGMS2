drago_init(window_handle(), true);

function drago_get_dropped_files() {
    var n = __file_dropper_count();
    var array = array_create(n);
    
    for (var i = 0; i < n; i++) {
        array[i] = __file_dropper_get(i);
    }
    
    file_dropper_flush();    
    array_sort(array, true);
    
    return array;
}

show_debug_message("DragoExt version " + drago_version());
show_debug_message("System:");
show_debug_message("    OS description: " + dragosys_os_info());
show_debug_message("CPU:");
show_debug_message("    CPU model: " + dragosys_processor_info());
show_debug_message("    Logical cores: " + string(dragosys_processor_count()));
show_debug_message("    Architecture: " + dragosys_processor_architecture());
show_debug_message("Memory: " + string(dragosys_memory_total() / 0x100000) + "mb");