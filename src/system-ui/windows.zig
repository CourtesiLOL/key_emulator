const std = @import("std");
const utl = @import("../utils.zig");

const wn = @cImport({
    @cInclude("Windows.h");
});

pub fn simulate_keypress(key: []const u8, seconds: u32, delay: u32) void {

    //Obtain the ascii value and cast to vk
    const local_key_raw = std.ascii.toUpper(key[0]);
    const vk_result = wn.VkKeyScanExA(local_key_raw, wn.GetKeyboardLayout(0));

    if (vk_result == -1) {
        std.debug.print("Error: This key word is not valid", .{});
        return;
    }

    //Parse vk value and obtain the scand value(keyboard input value)
    const vk = wn.LOBYTE(vk_result);
    const scan_word: wn.WORD = @intCast(wn.MapVirtualKeyExA(vk, wn.MAPVK_VK_TO_VSC, wn.GetKeyboardLayout(0)));

    //Obtain finalization time and split the delay time
    const final_time = std.time.milliTimestamp() + (seconds * 1000);
    const sleep_time = @divExact(delay, 2);

    // Create an INPUT structure
    var inputs: [1]wn.INPUT = undefined;

    //Set key value and keyboard input event
    inputs[0].type = wn.INPUT_KEYBOARD;
    inputs[0].unnamed_0.ki.wVk = vk;
    inputs[0].unnamed_0.ki.wScan = scan_word;

    //Intance the current window focus
    var current_hwnd = wn.GetForegroundWindow();
    var exit = false;
    while (!exit) {

        //Update the windows focus on change
        if (current_hwnd != wn.GetForegroundWindow())
            current_hwnd = wn.GetForegroundWindow();
            _ = wn.SetForegroundWindow(current_hwnd);

        //Press the key
        inputs[0].unnamed_0.ki.dwFlags = wn.KEYEVENTF_SCANCODE;
        _ = wn.SendInput(1, &inputs, @sizeOf(wn.INPUT));
        utl.sleep_mil(sleep_time);

        // Release the key
        inputs[0].unnamed_0.ki.dwFlags = wn.KEYEVENTF_SCANCODE | wn.KEYEVENTF_KEYUP;
        _ = wn.SendInput(1, &inputs, @sizeOf(wn.INPUT));
        utl.sleep_mil(sleep_time);


        if (std.time.milliTimestamp() >= final_time) exit = true;
    }

}
