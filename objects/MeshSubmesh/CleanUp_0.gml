if (Stuff.is_quitting) exit;

if (buffer) buffer_delete(buffer);
if (wbuffer) vertex_delete_buffer(wbuffer);

if (vbuffer) {
    switch (owner.type) {
        case MeshTypes.RAW: vertex_delete_buffer(vbuffer); break;
        case MeshTypes.SMF: smf_model_destroy(vbuffer); break;
    }
}