const std = @import("std");
const utl = @import("utils.zig");

const wn = @cImport({
    @cInclude("windows.h");
});

pub fn simulate_keypress(key: []const u8, seconds: u32, delay: u32) void {

    var local_key: u8 = key[0];
    local_key = std.ascii.toUpper(local_key);

    const final_time = std.time.milliTimestamp() + (seconds * 1000);

    var exit = false;
    while (!exit) {

        wn.keybd_event(local_key, 0, 0, 0);  // Presionar la tecla
        utl.sleep_mil(15);
        wn.keybd_event(local_key, 0, wn.KEYEVENTF_KEYUP, 0);  // Liberar la tecla
        utl.sleep_mil(delay);
        if (std.time.milliTimestamp() >= final_time) exit = true;
    }

}
