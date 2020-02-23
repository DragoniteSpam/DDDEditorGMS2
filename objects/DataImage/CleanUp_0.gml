if (Stuff.is_quitting) exit;

event_inherited();

if (picture) sprite_delete(picture);

for (var i = 0; i < array_length_1d(npc_frames); i++) {
    vertex_delete_buffer(npc_frames[i]);
}