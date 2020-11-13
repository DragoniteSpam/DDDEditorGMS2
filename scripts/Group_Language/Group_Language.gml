function language_add(name) {
    ds_list_add(Stuff.all_languages, name);
}

function language_remove(name) {
    ds_list_delete(Stuff.all_languages, ds_list_find_index(Stuff.all_languages, name));
}