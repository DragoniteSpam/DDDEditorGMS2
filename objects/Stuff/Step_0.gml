var files = ds_stuff_fetch_dropped_files();
if (array_length_1d(files) > 0) {
    files_dropped = files;
}

script_execute(mode.update, mode);