const std = @import("std");
const utl = @import("../utils.zig");

const x = @cImport(
    @cInclude("X11/Xlib.h")
);

pub fn simulate_keypress(key: u8, seconds: u32, delay: u32) void {

    //Obtain the ascii value
    const local_key = std.ascii.toUpper(key);

    //Open a connexion to X11
    const display = x.XOpenDisplay(null);
    if (display == null) {
        std.debug.print("Error: can't open a connexion to X11", .{});
        return;
    }

    //Obtain the root windows( the screen ) and declare a relative window
    const win_root: x.Window = x.DefaultRootWindow(display);
    var win_focused: x.Window = undefined;

    //Declare a temp window for make comparation
    var temp_win_focused: x.Window = undefined;
    var rever_to: c_int = undefined;


    //Intance and configure the key event
    var event: x.XKeyEvent = .{};

    event.send_event = x.True;
    event.display = display;
    event.window = win_focused;
    event.root = win_root;
    event.subwindow = x.None;
    event.x = 1;
    event.y = 1;
    event.x_root = 1;
    event.y_root = 1;
    event.same_screen = x.False;
    event.keycode = x.XKeysymToKeycode(display, local_key);
    event.state = 0;

    var xevent: *x.XEvent = undefined;

    //Obtain finalization time and split the delay time
    const final_time = std.time.milliTimestamp() + (seconds * 1000);
    const sleep_time = @divExact(delay, 2);

    var exit = false;
    while (!exit) {

        //Update the windows in event on change focus
        _ = x.XGetInputFocus(display, &temp_win_focused, &rever_to);

        if (win_focused != temp_win_focused) {
            win_focused = temp_win_focused;
            event.window = win_focused;
        }

        event.type = x.KeyPress;
        xevent = @ptrCast(&event);
        _ = x.XSendEvent(event.display, event.window, x.True, x.KeyPressMask, xevent);
        _ = x.XFlush(display);
        utl.sleep_mil(sleep_time);

        event.type = x.KeyRelease;
        xevent = @ptrCast(&event);
        _ = x.XSendEvent(event.display, event.window, x.True, x.KeyReleaseMask, xevent);
        _ = x.XFlush(display);
        utl.sleep_mil(sleep_time);

        if (final_time <= std.time.milliTimestamp()) exit = true;
    }
}
