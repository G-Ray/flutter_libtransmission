# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(flutter_libtransmission_library VERSION 0.0.1 LANGUAGES C)

add_library(flutter_libtransmission SHARED
  "flutter_libtransmission.c"
)

set_target_properties(flutter_libtransmission PROPERTIES
  PUBLIC_HEADER flutter_libtransmission.h
  OUTPUT_NAME "flutter_libtransmission"
)

target_compile_definitions(flutter_libtransmission PUBLIC DART_SHARED_LIB)
