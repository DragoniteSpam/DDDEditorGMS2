sa_foreach_all(safa_delete, noone);

// process_selection is done in here. if you don't clear the selection
// when you delete things you may (read: will) get unexpected results.
selection_clear();
