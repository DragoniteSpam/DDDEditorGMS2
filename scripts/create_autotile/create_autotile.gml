/// @description  void create_autotile(EntityAutotile);
/// @param EntityAutotile

for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++){
    var thing=ActiveMap.all_entities[| i];
    if (thing.modification==Modifications.NONE){
        if (instanceof(thing, EntityAutoTile)){
            var dx=thing.xx-argument0.xx;
            var dy=thing.yy-argument0.yy;
            // i will be SHOCKED if this works
            if ((abs(dx)|abs(dy))==1){
                // figure out the positions
                var index=(dy+1)*3+dx+1;
                if (index>4){
                    index--;
                }
                var index_alt=(1-dy)*3+1-dx;
                if (index_alt>4){
                    index_alt--;
                }
                
                // set thing as argument0's neighbor
                var old=argument0.neighbors[index];
                if (instance_exists(old)){
                    old.neighbors[index_alt]=noone;
                }
                argument0.neighbors[index]=thing;
                // set argument0 as thing's neighbor
                var old=thing.neighbors[index_alt];
                if (instance_exists(old)){
                    old.neighbors[index]=noone;
                }
                thing.neighbors[index_alt]=argument0;
            
                thing.modification=Modifications.UPDATE;
                ds_list_add(Camera.changes, thing);
            }
        }
    }
}

// this has to go last, after the neighbors have been set
update_autotile(argument0);
