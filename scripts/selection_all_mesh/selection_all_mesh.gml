var list = selection_all();

for (var i = 0; i < ds_list_size(list); i++) {
    if (!instanceof(list[| i], EntityMesh)) {
        ds_list_destroy(list);
        return false;
    }
}

return true;