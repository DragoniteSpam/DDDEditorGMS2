function game_auto_title() {
	window_set_caption("DDD Editor - " + (string_length(Stuff.save_name) > 0 ? Stuff.save_name : "(none)"));


}
