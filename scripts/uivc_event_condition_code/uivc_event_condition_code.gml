/// @param UIInputCode

var input = argument0;

if (validate_code(input.value)) {
    input.root.page.condition_code = input.value;
}