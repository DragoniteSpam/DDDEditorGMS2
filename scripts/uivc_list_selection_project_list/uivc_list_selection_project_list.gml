/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

if (selection + 1) {
    var version_str = list.root.versions[selection];
    var date_str = list.root.timestamp_dates[selection];
    var time_str = list.root.timestamp_times[selection];
    var file_count = list.root.file_counts[selection];
    list.root.el_summary_name.text = "Name: " + list.root.names[selection];
    list.root.el_summary_version.text = "File version: " + ((string_length(version_str) > 0) ? (version_str + " (0x" + string_hex(real(version_str)) + ")") : "N/A");;
    list.root.el_summary_summary.text = "Summary: " + list.root.strings[selection];
    list.root.el_summary_author.text = "Author: " + list.root.authors[selection];
    list.root.el_summary_timestamp_date.text = "Date: " + ((string_length(date_str) > 0) ? date_str : "N/A");
    list.root.el_summary_timestamp_time.text = "Time: " + ((string_length(time_str) > 0) ? time_str : "N/A");
    list.root.el_summary_file_count.text = "Asset files: " + ((file_count > 0) ? string(file_count) : "N/A");
} else {
    list.root.el_summary_name.text = "";
    list.root.el_summary_version.text = "";
    list.root.el_summary_summary.text = "";
    list.root.el_summary_author.text = "";
    list.root.el_summary_timestamp_date.text = "";
    list.root.el_summary_timestamp_time.text = "";
    list.root.el_summary_file_count.text = "";
}