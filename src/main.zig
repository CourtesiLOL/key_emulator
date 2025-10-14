const std = @import("std");
const ui = @import("windows.zig");
const utl = @import("utils.zig");
//const builtin = @import("builtin");
//Descomentar al implementar la version para linux
//const wn = if (builtin.os.tag == .windows)
//              @import("windows")
//           else
//              @import("linux");


const print = std.debug.print;
const err = error {
    InvalidArgs,
};



fn errorArgs() void {
    print("Error: Bad arguments\n\n", .{});
    print("Execution example\n", .{});
    print("-----------------\n", .{});
    print("KeyEmulator <key> <Duration Time seconds> <key loop time>\n", .{});
    print("\nExample using the Key T, Duration of the script 1 minute (60 seconds) and an interval between Key Press of 25 milliseconds\n", .{});
    print("KeyEmulator t(key to press) 60(seconds) 25(Milliseconds)\n\n", .{});
}


//Cambiar a args: []const [:0]u8 cuando no use el run del build
fn obtain_valid_args(args: [][:0] u8) err!struct{[]const u8, u32, u32} {
    if (args.len != 4) return err.InvalidArgs;
    if (args[1].len != 1) return err.InvalidArgs;

    const key: []const u8 = args[1];
    const seconds: u32 = std.fmt.parseInt(u32, args[2], 0) catch return err.InvalidArgs;
    const delay: u32 = std.fmt.parseInt(u32, args[3], 0) catch return err.InvalidArgs;

    return .{key, seconds, delay};
}

pub fn main() !void {

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const args = try std.process.argsAlloc(allocator);

    var key: []const u8 = undefined;
    var seconds: u32 = undefined;
    var delay: u32 = undefined;

    key, seconds, delay = obtain_valid_args(args) catch {
        errorArgs();
        return;
    };

    //print("tecla: {s}\nsegundos: {d}\ndelay: {d}\n", .{key, seconds, delay});
    //play(key, seconds, delay);

    print("Init in 3 secons\n", .{});

    var count: u8 = 3;
    while (count > 0) {
        print("In {d}\n", .{count});
        utl.sleep_sec(1);
        count -= 1;
    }


    print("Loop start...\n", .{});
    ui.simulate_keypress(key, seconds, delay);

    //To DO: Crear funcion para ejecutar el bucle


}
