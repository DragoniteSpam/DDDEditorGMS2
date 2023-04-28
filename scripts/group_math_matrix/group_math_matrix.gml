function matrix_inverse(_matrix) {
    return __scribble_matrix_inverse(_matrix);
}

function matrix_is_identity(matrix) {
    for (var i = 0; i < 4; i++) {
        if (matrix[i * 4 + i] != 1) return false;
    }
    for (var i = 1; i < 15; i++) {
        if (i % 5 > 0 && matrix[i] != 0) return false;
    }
    return true;
}