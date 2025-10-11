const std = @import("std");

const print = std.debug.print;

//Build command
//zig build-exe TClicker.zig -lc -O ReleaseSmall

pub fn sleep_sec(seconds: usize) void {
    std.Thread.sleep(second_to_nano(seconds));
}

pub fn sleep_mil(milliseconds: usize) void {
    std.Thread.sleep(millisec_to_nano(milliseconds));
}

pub fn second_to_nano(seconds: usize) usize{
    return (seconds * 1_000_000_000);
}

pub fn millisec_to_nano(milliseconds: usize) usize{
    return (milliseconds * 1_000_000);
}
