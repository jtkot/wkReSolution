const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86,
            .os_tag = .windows,
            .abi = .gnu,
        },
    });

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addLibrary(.{
        .name = "wkReSolution",
        .linkage = .dynamic,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
            .strip = true,
        }),
    });

    const cpp_flags = [_][]const u8{
        "-std=c++98",
        "-fms-extensions",
    };

    lib.root_module.addCSourceFiles(.{
        .files = &.{
            "hooks.cpp",
            "misc_tools.cpp",
            "w2res.cpp",
            "main.cpp",
        },
        .flags = &cpp_flags,
    });

    lib.root_module.addWin32ResourceFile(.{
        .file = b.path("version.rc"),
    });

    lib.root_module.linkSystemLibrary("kernel32", .{});
    lib.root_module.linkSystemLibrary("user32", .{});
    lib.root_module.linkSystemLibrary("gdi32", .{});

    lib.subsystem = .Windows;

    b.installArtifact(lib);
}
