/// @description  void data_clear_map();

// could go through and reset all of the individual values but honestly
// that's pretty much what this does anyway
instance_destroy(ActiveMap);
instance_create(0, 0, ActiveMap);
