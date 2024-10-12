#include <array>
#include <cstring>
#include <future>
#include <string>

#include "flutter_libtransmission.h"

#include "rpcimpl.h"
#include "transmission.h"
#include "utils.h"
#include "variant.h"

using std::string;

#define MEM_K 1024
#define MEM_K_STR "KiB"
#define MEM_M_STR "MiB"
#define MEM_G_STR "GiB"
#define MEM_T_STR "TiB"

#define DISK_K 1000
#define DISK_K_STR "kB"
#define DISK_M_STR "MB"
#define DISK_G_STR "GB"
#define DISK_T_STR "TB"

#define SPEED_K 1000
#define SPEED_K_STR "kB/s"
#define SPEED_M_STR "MB/s"
#define SPEED_G_STR "GB/s"
#define SPEED_T_STR "TB/s"

typedef struct {
  tr_variant request;
  std::promise<std::string> promise;
} callback_struct;

tr_session *session;
std::string configDir;

static void rpc_response_func(tr_session *session, tr_variant *response,
                       void *callback_user_data) {
  std::string json = tr_variantToStr(response, TR_VARIANT_FMT_JSON);
  callback_struct *cs = (callback_struct *)callback_user_data;

  cs->promise.set_value(json);

  tr_variantClear(response);
}

static void execute_request(callback_struct &cs) {
  tr_rpc_request_exec_json(session, &cs.request, rpc_response_func, &cs);
}

FFI_PLUGIN_EXPORT void init_session(char *config_dir, char *app_name) {
  tr_variant settings;
  configDir = config_dir;

  tr_formatter_mem_init(MEM_K, MEM_K_STR, MEM_M_STR, MEM_G_STR, MEM_T_STR);
  tr_formatter_size_init(DISK_K, DISK_K_STR, DISK_M_STR, DISK_G_STR,
                         DISK_T_STR);
  tr_formatter_speed_init(SPEED_K, SPEED_K_STR, SPEED_M_STR, SPEED_G_STR,
                          SPEED_T_STR);

  tr_variantInitDict(&settings, 0);
  tr_sessionLoadSettings(&settings, configDir.c_str(), app_name);

  session = tr_sessionInit(configDir.c_str(), true, &settings);

  tr_ctor *ctor = tr_ctorNew(session);
  tr_sessionLoadTorrents(session, ctor);
  tr_ctorFree(ctor);

  tr_variantClear(&settings);
}

FFI_PLUGIN_EXPORT void close_session() {
  save_settings();
  tr_sessionClose(session);
}

FFI_PLUGIN_EXPORT char *request(char *json_string) {
  callback_struct callback_user_data;
  tr_variantFromBuf(&callback_user_data.request, TR_VARIANT_PARSE_JSON,
                    string(json_string));
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
  tr_sessionSaveSettings(session, configDir.c_str(), &settings);
  tr_variantClear(&settings);
}
