event_inherited();

// if more data is added here, and i don't think it will be, be
// sure to carry it over in both the save/load scripts and data_clone()

name = "DataType" + string(ds_list_size(Stuff.all_data) - 1);
summary = "";

properties = ds_list_create();

// all of the instances of the data type; nested lists
instances = ds_list_create();