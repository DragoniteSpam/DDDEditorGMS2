function matrix_inverse(_matrix) {
    return __scribble_matrix_inverse(_matrix);
}

function matrix_multiply_vec4(point, matrix) {
    var x = point.x;
    var y = point.y;
    var z = point.z;
    var w = point.w;
    
    return new Vector4(
        matrix[0] * xx + matrix[4] * yy + matrix[8] * zz + matrix[12] * ww,
        matrix[1] * xx + matrix[5] * yy + matrix[9] * zz + matrix[13] * ww,
        matrix[2] * xx + matrix[6] * yy + matrix[10] * zz + matrix[14] * ww,
        matrix[3] * xx + matrix[7] * yy + matrix[11] * zz + matrix[15] * ww,
    );
}