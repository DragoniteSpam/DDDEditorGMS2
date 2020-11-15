// ds_maps that are slightly faster to add and remove from
function ds_collection_create() {
    return [[undefined], 0, 0];
}

function ds_collection_add(collection, value) {
    collection[@ 2]++;
    var arr = collection[@ 0];
    if (array_length(arr) <= collection[@ 1]) {
        var new_arr = array_create(array_length(arr) * 2, undefined);
        array_copy(new_arr, 0, arr, 0, array_length(arr));
        arr = new_arr;
        collection[@ 0] = new_arr;
    }
    
    arr[@ collection[@ 1]] = value;
    var index = collection[@ 1];
    var i = index;
    repeat (array_length(arr) - i) {
        if (arr[@ i] == undefined) {
            collection[@ 1] = i;
            return index;
        }
        i++;
    }
    collection[@ 1] = array_length(arr);
    return index;
}

function ds_collection_clear(collection) {
    array_clear(collection[@ 0], undefined);
    collection[@ 1] = 0;
    collection[@ 2] = 0;
}

function ds_collection_get(collection, index) {
    return collection[@ 0][@ index];
}

function ds_collection_as_array(collection) {
    return collection[@ 0];
}

function ds_collection_delete(collection, index) {
    collection[@ 0][@ index] = undefined;
    collection[@ 1] = min(collection[@ 1], index);
    collection[@ 2]--;
}

function ds_collection_remove_value(collection, value) {
    var i = 0;
    repeat (array_length(collection[@ 0])) {
        if (collection[@ 0][@ i] == value) {
            ds_collection_delete(collection, i);
            break;
        }
        i++;
    }
}

function ds_collection_size(collection) {
    return collection[@ 2];
}