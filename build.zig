const std = @import("std");


pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    //On debug
    //const optimize = b.standardOptimizeOption(.{});

    //On release
    const optimize = std.builtin.OptimizeMode.ReleaseSmall;

    const utl_mod = b.addModule("utils", .{
        .root_source_file = b.path("src/utils.zig"),
        .target = target
    });

    const wn_mod = b.addModule("windows", .{
        .root_source_file = b.path("src/windows.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "utils", .module = utl_mod}
        }

    });

    const exe = b.addExecutable(.{
        .name = "KeyEmulator",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "windows", .module = wn_mod },
                .{ .name = "utils", .module = utl_mod },
            },
        }),
    });

    b.installArtifact(exe);

    //System libs
    exe.linkSystemLibrary("c");

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run tests");

    test_step.dependOn(&run_exe_tests.step);

}
