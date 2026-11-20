function mat4_determinant(mat) {
    var r1 =  mat[ 5] * mat[10] * mat[15] - mat[ 5] * mat[11] * mat[14] - mat[ 9] * mat[ 6] * mat[15] + mat[ 9] * mat[ 7] * mat[14] + mat[13] * mat[ 6] * mat[11] - mat[13] * mat[ 7] * mat[10];
    var r2 = -mat[ 4] * mat[10] * mat[15] + mat[ 4] * mat[11] * mat[14] + mat[ 8] * mat[ 6] * mat[15] - mat[ 8] * mat[ 7] * mat[14] - mat[12] * mat[ 6] * mat[11] + mat[12] * mat[ 7] * mat[10];
    var r3 =  mat[ 4] * mat[ 9] * mat[15] - mat[ 4] * mat[11] * mat[13] - mat[ 8] * mat[ 5] * mat[15] + mat[ 8] * mat[ 7] * mat[13] + mat[12] * mat[ 5] * mat[11] - mat[12] * mat[ 7] * mat[ 9];
    var r4 = -mat[ 4] * mat[ 9] * mat[14] + mat[ 4] * mat[10] * mat[13] + mat[ 8] * mat[ 5] * mat[14] - mat[ 8] * mat[ 6] * mat[13] - mat[12] * mat[ 5] * mat[10] + mat[12] * mat[ 6] * mat[ 9];
    
    return mat[0] * r1 + mat[1] * r2 + mat[2] * r3 + mat[3] * r4;
}

function mat4_mul_point(mat, point) {
    static transformed_point = [0, 0, 0, 0];
    matrix_transform_vertex(mat, point.x, point.y, point.z, 1, transformed_point);
    return new Vector3(transformed_point[0], transformed_point[1], transformed_point[2]);
}

function mat4_mul_vector(mat, vec) {
    static transformed_point = [0, 0, 0, 0];
    matrix_transform_vertex(mat, vec.x, vec.y, vec.z, 0, transformed_point);
    return new Vector3(transformed_point[0], transformed_point[1], transformed_point[2]);
}