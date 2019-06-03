/// @description list selection_count();

var n=0;

for (var i=0; i<ds_list_size(ActiveMap.all_entities); i++) {
    if (selected(ActiveMap.all_entities[| i])) {
        if (++n>1) {
            return SelectionCounts.MULTIPLE;
        }
    }
}

if (n==0) {
    return SelectionCounts.NONE;
}

return SelectionCounts.ONE;

enum SelectionCounts {
    NONE,
    ONE,
    MULTIPLE
}
