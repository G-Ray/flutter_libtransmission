#include "flutter_libtransmission.h"

#include <array>
#include <cstring>
#include <future>
#include <string>

#include "libtransmission/rpcimpl.h"
#include "libtransmission/transmission.h"
#include "libtransmission/utils.h"
#include "libtransmission/variant.h"
#include "libtransmission/quark.h"

using std::string;

typedef struct {
  tr_variant request;
  std::promise<std::string> promise;
} callback_struct;

tr_session *session;
std::string configDir;


static void execute_request(callback_struct &cs) {
  tr_rpc_request_exec(session, cs.request, [&cs](tr_session* session, tr_variant&& resp) {
    cs.promise.set_value(tr_variant_serde::json().compact().to_string(resp));
  });
}

FFI_PLUGIN_EXPORT void init_session(char *config_dir) {
  configDir = config_dir;

  tr_lib_init();
  auto settings = tr_sessionLoadSettings(configDir);
  tr_variantDictAddBool(&settings, TR_KEY_rename_partial_files, false);

  session = tr_sessionInit(configDir.c_str(), false, settings);

  tr_ctor *ctor = tr_ctorNew(session);
  tr_sessionLoadTorrents(session, ctor);
  tr_ctorFree(ctor);
}

FFI_PLUGIN_EXPORT void close_session() {
  save_settings();
  tr_sessionClose(session);
}

FFI_PLUGIN_EXPORT char *request(char *json_string) {
  callback_struct callback_user_data;

  callback_user_data.request = tr_variant_serde::json().inplace().parse(std::string(json_string)).value_or(tr_variant{});
  auto future = callback_user_data.promise.get_future();

  std::thread thread(execute_request, std::ref(callback_user_data));

  std::string value = future.get();
  thread.join();

  char *response = new char[value.length() + 1];
  std::strcpy(response, value.c_str());
  return response;
}

FFI_PLUGIN_EXPORT void save_settings() {
  tr_variant settings;

  tr_variantInitDict(&settings, 0);
  tr_sessionSaveSettings(session, configDir.c_str(), settings);
}

FFI_PLUGIN_EXPORT void reset_settings() {
  auto default_settings = tr_sessionGetDefaultSettings();
  tr_variantDictAddBool(&default_settings, TR_KEY_rename_partial_files, false);
  tr_sessionSet(session, default_settings);
  tr_sessionSaveSettings(session, configDir.c_str(), default_settings);
}
