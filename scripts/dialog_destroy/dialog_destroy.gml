function dialog_destroy() {
	// closes the top dialog. or schedules it for closing. if you
	// destroy it now, bad things will happen to other parts of the
	// Draw event which still reference it, because my code is spaghetti.

	if (dialog_exists()) {
	    instance_destroy_later(ds_list_pop(Stuff.dialogs));
	}


}
