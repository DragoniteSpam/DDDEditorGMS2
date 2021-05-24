var files = ds_stuff_fetch_dropped_files();
if (array_length(files) > 0) {
    files_dropped = files;
} else {
    files_dropped = [];
}

if (is_struct(mode)) {
    mode.Update();
} else {
    mode.update(mode);
}