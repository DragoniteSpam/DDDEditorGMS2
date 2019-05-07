#define buffer_zlib_init
/// @description  ()
//#global buffer_zlib_chunk_size: Number of bytes to process at once in inflate/deflate
//#global buffer_zlib_available: Whether the buffer_zlib extension is successfully loaded
//#buffer_zlib_status buffer_zlib_get_status(): Raw zlib status ID (in case of errors)
buffer_zlib_available = buffer_zlib_init_raw();
buffer_zlib_chunk_size = 16384;

#define buffer_deflate
/// @description  (buffer, offset, size, compression_level[1..9], ?out_buffer): Compresses a part of a buffer to a new or given buffer.
/// @param buffer
/// @param  offset
/// @param  size
/// @param  compression_level[1..9]
/// @param  ?out_buffer
var l_source = argument[0];
var l_length = buffer_get_size(l_source);
var l_offset = argument[1];
var l_total = l_offset + argument[2];
l_offset = clamp(l_offset, 0, l_length);
l_total = clamp(l_total, 0, l_length) - l_offset;
if (!buffer_deflate_raw1(buffer_get_address(l_source), l_offset, l_total, argument[3])) return -1;
//
var l_chunk = buffer_zlib_chunk_size;
var l_result, l_alloc = argument_count <= 4;
if (l_alloc) {
	l_offset = 0;
	l_length = l_chunk;
	l_result = buffer_create(l_length, buffer_grow, 1);
} else {
	l_result = argument[4];
	l_offset = buffer_tell(l_result);
	l_length = buffer_get_size(l_result);
}
//
var l_avail, l_address = buffer_get_address(l_result);
if (l_total > 0) do {
	l_avail = buffer_deflate_raw2(l_address, l_offset, l_length);
	if (l_avail < 0) {
		if (l_alloc) buffer_delete(l_result);
		return -1;
	} else if (l_avail == 0) {
		l_offset = l_length;
		l_length += l_chunk;
		buffer_resize(l_result, l_length);
		l_address = buffer_get_address(l_result);
	}
} until (l_avail > 0);
buffer_seek(l_result, buffer_seek_start, l_length - l_avail);
return l_result;

#define buffer_inflate
/// @description  (buffer, offset, size, ?out_buffer): Decompresses a part of a buffer to a new or given buffer.
/// @param buffer
/// @param  offset
/// @param  size
/// @param  ?out_buffer
var l_source = argument[0];
var l_length = buffer_get_size(l_source);
var l_offset = argument[1];
var l_total = l_offset + argument[2];
l_offset = clamp(l_offset, 0, l_length);
l_total = clamp(l_total, 0, l_length) - l_offset;
if (!buffer_inflate_raw1(buffer_get_address(l_source), l_offset, l_total)) return -1;
//
var l_chunk = buffer_zlib_chunk_size;
var l_result, l_alloc = argument_count <= 3;
if (l_alloc) {
	l_offset = 0;
	l_length = l_chunk;
	l_result = buffer_create(l_length, buffer_grow, 1);
} else {
	l_result = argument[3];
	l_offset = buffer_tell(l_result);
	l_length = buffer_get_size(l_result);
}
//
var l_avail = 0, l_address = buffer_get_address(l_result);
if (l_total > 0) do {
	l_avail = buffer_inflate_raw2(l_address, l_offset, l_length);
	if (l_avail < 0) {
		if (l_alloc) buffer_delete(l_result);
		return -1;
	} else if (l_avail == 0) {
		l_offset = l_length;
		l_length += l_chunk;
		buffer_resize(l_result, l_length);
		l_address = buffer_get_address(l_result);
	}
} until (l_avail > 0);
buffer_seek(l_result, buffer_seek_start, l_length - l_avail);
return l_result;

