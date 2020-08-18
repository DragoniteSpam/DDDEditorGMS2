/// @param list
/// @param l
/// @param m
/// @param r
/// @param value-get
function ds_list_sort_fast__merge(argument0, argument1, argument2, argument3, argument4) {

	var list = argument0;
	var l = argument1;
	var m = argument2;
	var r = argument3;
	var value = argument4;

	var n1 = m - l + 1;
	var n2 = r - m;
	var lt = ds_list_create();
	var rt = ds_list_create();

	for (var i = 0; i < n1; i++) {
	    // this should technically be a ds_list_add but whatever
	    lt[| i] = list[| l +i ];
	}
	for (var j = 0; j < n2; j++) {
	    // ditto
	    rt[| j] = list[| m + j + 1];
	}

	var i = 0;
	var j = 0;
	var k = l;

	while (i < n1 && j < n2) {
	    if (script_execute(value, lt, i) <= script_execute(value, rt, j)) {
	        list[| k++] = lt[| i++];
	    } else {
	        list[| k++] = rt[| j++];
	    }
	}

	while (i < n1) {
	    list[| k++] = lt[| i++];
	}
	while (j < n2) {
	    list[| k++] = rt[| j++];
	}

	ds_list_destroy(lt);
	ds_list_destroy(rt);


}
