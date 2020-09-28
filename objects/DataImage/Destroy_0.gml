if (Stuff.is_quitting) exit;

event_inherited();

if (picture) sprite_delete(picture);
if (picture_with_frames) sprite_delete(picture_with_frames);

for (var i = 0; i < array_length(npc_frames); i++) {
    vertex_delete_buffer(npc_frames[i]);
}