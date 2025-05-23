#include <array>
#include <cstring>
#include <future>
#include <string>

#include "rpcimpl.h"
#include "transmission.h"
#include "utils.h"
#include "variant.h"

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

// Reset all session settings
FFI_PLUGIN_EXPORT void reset_settings();
