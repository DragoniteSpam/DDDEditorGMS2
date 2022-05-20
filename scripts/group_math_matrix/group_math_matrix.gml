function matrix_inverse(_matrix) {
    return __scribble_matrix_inverse(_matrix);
}

function matrix_multiply_vec4(point, matrix) {
    var x = point.x;
    var y = point.y;
    var z = point.z;
    var w = point.w;
    
    return [
        matrix[0] * x + matrix[4] * y + matrix[8] * z + matrix[12] * w,
        matrix[1] * x + matrix[5] * y + matrix[9] * z + matrix[13] * w,
        matrix[2] * x + matrix[6] * y + matrix[10] * z + matrix[14] * w,
        matrix[3] * x + matrix[7] * y + matrix[11] * z + matrix[15] * w,
    ];
}