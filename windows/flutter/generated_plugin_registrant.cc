//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <dynamic_color/dynamic_color_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>
#include <just_audio_windows/just_audio_windows_plugin.h>
#include <screen_retriever_windows/screen_retriever_windows_plugin_c_api.h>
#include <tray_manager/tray_manager_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>
#include <window_manager/window_manager_plugin.h>
#include <windows_single_instance/windows_single_instance_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  DynamicColorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicColorPluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  JustAudioWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("JustAudioWindowsPlugin"));
  ScreenRetrieverWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverWindowsPluginCApi"));
  TrayManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TrayManagerPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
  WindowsSingleInstancePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowsSingleInstancePlugin"));
}
