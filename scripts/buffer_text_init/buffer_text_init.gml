#macro __BUFFER_TEXT_VERSION  "1.0.0"
#macro __BUFFER_TEXT_DATE     "2020/01/06"

/// buffer_text v1.0.0
/// 2020/01/06
/// @jujuadams
///
/// @param [useAsync]
function buffer_text_init(_use_async = false) {

    global.__buffer_text_async = _use_async;

    global.__buffer_text_async_map = ds_map_create();

    enum BUFFER_TEXT
    {
        FILENAME,
        BUFFER,
        MODE,
        PENDING,
        FAILED,
        CLOSED,
        CALLBACK,
        __SIZE
    }

    enum BUFFER_TEXT_MODE
    {
        APPEND,
        FROM_STRING,
        READ,
        WRITE
    }
}