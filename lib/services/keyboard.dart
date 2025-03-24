import 'dart:isolate';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class KeyboardHook {
  static int kbHook = 0;
  static final Map<int, bool> keyState = {};

  static Future<Isolate> startKeyboardListener(SendPort mainSendPort) async {
    return await Isolate.spawn(
      _keyboardHookIsolate, 
      mainSendPort
    );
  }

    // Sets the keyboard hook and listens to messages from it.
  static void _keyboardHookIsolate(SendPort mainSendPort) {
    final callback = NativeCallable<HOOKPROC>.isolateLocal(
      (int nCode, int wParam, int lParam) => _lowLevelKeyboardProc(nCode, wParam, lParam, mainSendPort),
      exceptionalReturn: 0
    );

    kbHook = SetWindowsHookEx(WH_KEYBOARD_LL, callback.nativeFunction, 0, 0);

    final msg = calloc<MSG>();

    while (GetMessage(msg, NULL, 0, 0) != 0) {
      TranslateMessage(msg);
      DispatchMessage(msg);
    }
  }

  // The hook itself. Checks the key state and sends a message to the port if Ctrl + Z is active.
  static int _lowLevelKeyboardProc(int nCode, int wParam, int lParam, SendPort sendPort) {
    if (nCode == HC_ACTION) {
      final kbStruct = Pointer<KBDLLHOOKSTRUCT>.fromAddress(lParam);
      final vkCode = kbStruct.ref.vkCode;

      switch (wParam) {
        case WM_KEYDOWN:
          if (keyState[vkCode] != true) {
            keyState[vkCode] = true;

            if (vkCode == VK_Z && (keyState[VK_LCONTROL] == true)) {
              sendPort.send("undo");
            }
          }
          break;
        case WM_KEYUP:
          keyState[vkCode] = false;
          break;
        default:
        }
    }
    return CallNextHookEx(NULL, nCode, wParam, lParam);
  }

  static void stopKeyboardListener() {
    UnhookWindowsHookEx(kbHook);
  }
}