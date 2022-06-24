function matrix_inverse(_matrix) {
    return __scribble_matrix_inverse(_matrix);
}

function matrix_multiply_vec4(point, matrix) {
    var xx = point.x;
    var yy = point.y;
    var zz = point.z;
    var ww = point.w;
    
    return new Vector4(
        matrix[0] * xx + matrix[4] * yy + matrix[8] * zz + matrix[12] * ww,
        matrix[1] * xx + matrix[5] * yy + matrix[9] * zz + matrix[13] * ww,
        matrix[2] * xx + matrix[6] * yy + matrix[10] * zz + matrix[14] * ww,
        matrix[3] * xx + matrix[7] * yy + matrix[11] * zz + matrix[15] * ww,
    );
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