// if you're using this in debug mode the overlay is going to be
// shown and that's going to block out the first part of the menu
if (DEBUG){
    var yy=24;
} else {
    var yy=0;
}

d3d_set_projection_ortho(0, 0, room_width, room_height, 0);

script_execute(menu.render, menu, 0, yy);

if (get_release_left(false)&&!dialog_exists()){
    menu_activate(noone);
}

for (var i=0; i<ds_list_size(dialogs); i++){
    var thing=dialogs[| i];
    script_execute(thing.render, thing);
}

// these are going to be uncommon and short-lived, so don't
// bother deactivating them.
with (UINotification){
    script_execute(render);
}
