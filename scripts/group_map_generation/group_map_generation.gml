function map_generate_contents(total, choices) {
    var total_weights = 0;
    for (var i = 0, n = array_length(choices); i < n; i++) {
        total_weights += choices[i].weight;
    }
}