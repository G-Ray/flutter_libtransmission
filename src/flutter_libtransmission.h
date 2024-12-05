#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT extern "C" __declspec(dllexport)
#elif __cplusplus
#define FFI_PLUGIN_EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#else
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

// Initialize a transmission session given a config dir and an app name.
FFI_PLUGIN_EXPORT void init_session(char *config_dir, char *app_name);

// Close transmission session.
FFI_PLUGIN_EXPORT void close_session();

/* Long running function which should be called asynchronously.
 * This function will return a char pointer which should be freed.
 */
FFI_PLUGIN_EXPORT char *request(char *json_string);

// Save current transmission settings to disk.
FFI_PLUGIN_EXPORT void save_settings();
