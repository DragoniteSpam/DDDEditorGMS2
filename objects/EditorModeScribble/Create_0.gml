event_inherited();

scribble_init("data\\fonts", "FDefault12", true);

scribble_text = "Type something here to be previewed in [wave][rainbow]Scribble[]!";

render = editor_render_scribble;
ui = ui_init_scribble(id);
mode_id = ModeIDs.SCRIBBLE;