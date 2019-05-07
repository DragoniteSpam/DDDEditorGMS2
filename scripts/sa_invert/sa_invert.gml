// commented this whole thing out because it's really badly
// written and probably won't actually be used that much.
/*if (!selection_empty()){
    var processed=ds_map_create();
    for (var s=0; s<ds_list_size(selection); i++){
        var sel=selection[| i];
        var x1=min(sel.x1, sel.x2);
        var y1=min(sel.y1, sel.y2);
        var x2=max(sel.x1, sel.x2);
        var y2=max(sel.y1, sel.y2);
        
        var l=x2-x1;
        var w=y2-y1;
        
        var grid=ds_grid_create(l, w);
        ds_grid_clear(grid, false);
        
        for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++){
            var thing=ActiveMap.all_entities[| i];
            if (selected(thing)){
                var str=cstr(thing);
                if (!ds_map_exists(processed, str)){
                    ds_map_add(processed, str, true);
                    grid[# thing.xx-x1, thing.yy-y1]=true;
                    thing.modification=Modifications.REMOVE;
                    ds_list_add(changes, thing);
                }
            }
        }
        
        for (var i=0; i<l; i++){
            for (var j=0; j<w; j++){
                if (!grid[# i, j]){
//                    var str=string(x1+i)+","+string(y1+j)+","+
                    var addition=instance_create_tile(4, 0);
                    map_add_thing(addition, x1+i, y1+j, 0);
                    ds_list_add(changes, addition);
                }
            }
        }
        
        ds_grid_destroy(grid);
    }
    ds_map_destroy(processed);

    sa_process_selection();
}*/
