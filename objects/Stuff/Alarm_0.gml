/// @description  this alarm just ticks on its own regardless of what the rest of the program does

alarm[0]=1200;

var buffer=buffer_create(1000, buffer_grow, 1);
for (var i=0; i<ds_list_size(error_log_messages); i++){
    buffer_write(buffer, buffer_string, error_log_messages[| i]+N);
}

buffer_save_ext(buffer, "errors.log", 0, buffer_tell(buffer));
buffer_delete(buffer);

// don't clear

