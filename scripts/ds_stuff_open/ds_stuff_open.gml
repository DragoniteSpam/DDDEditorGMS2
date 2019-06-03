/// @description double ds_stuff_open(file);
/// @param file

/*
 * This is ONLY for stuff that can be found in the game's file bundle.
 * For stuff in local storage use ds_stuff_open_local.
 * I'm not actually sure what the exact return value is, but
 * anything over 32 is "success" and not very useful to game maker.
 * these were obtained from 
 * https://docs.microsoft.com/en-us/windows/desktop/api/shellapi/nf-shellapi-shellexecutea
 *
 * Return code             Description
 * 0                       The operating system is out of memory or resources.
 * ERROR_FILE_NOT_FOUND    The specified file was not found.
 * ERROR_PATH_NOT_FOUND    The specified path was not found.
 * ERROR_BAD_FORMAT        The .exe file is invalid (non-Win32 .exe or error in .exe image).
 * SE_ERR_ACCESSDENIED     The operating system denied access to the specified file.
 * SE_ERR_ASSOCINCOMPLETE  The file name association is incomplete or invalid.
 * SE_ERR_DDEBUSY          The DDE transaction could not be completed because other DDE transactions were being processed.
 * SE_ERR_DDEFAIL          The DDE transaction failed.
 * SE_ERR_DDETIMEOUT       The DDE transaction could not be completed because the request timed out.
 * SE_ERR_DLLNOTFOUND      The specified DLL was not found.
 * SE_ERR_FNF              The specified file was not found.
 * SE_ERR_NOASSOC          There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable.
 * SE_ERR_OOM              There was not enough memory to complete the operation.
 * SE_ERR_PNF              The specified path was not found.
 * SE_ERR_SHARE            A sharing violation occurred.
 *
 * i assume the codes count up from 0 but haven't tested
 * this theory. just try not to generate them.
 */

return external_call(global._ds_stuff_open, argument0);
