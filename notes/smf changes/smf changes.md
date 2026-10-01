In the event that SMF gets updated, here's a list of changes that have been made to the
files that will most likely need to be re-implemented:

smf_model_load
    By default it only returns the model index or -1 if one could not be loaded;
    I changed it so that it returns an array of [regular-buffer, smf-buffer] or undefined
    if one could not be loaded