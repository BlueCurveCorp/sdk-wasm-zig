const std = @import("std");
const bc = @import("bluecurve.zig");

var field_calls: usize = 0;
var kpi: [4096]u8 = undefined;
var kpi_len: usize = 0;

export fn builder_add_field(_: [*]const u8, len: i32) void {
    std.debug.assert(len > 70000);
    field_calls += 1;
}

export fn job_index_builder_add_field(_: i32, ptr: [*]const u8, len: i32) void {
    builder_add_field(ptr, len);
}

export fn kpi_track_event(_: i32, ptr: [*]const u8, len: i32) void {
    kpi_len = @intCast(len);
    @memcpy(kpi[0..kpi_len], ptr[0..kpi_len]);
}

test "file and job fields grow beyond str16 and bin16" {
    const value = [_]u8{'a'} ** 70000;
    const builder = bc.Indexer.Builder.init(std.testing.allocator);
    try builder.addField("content", .{ .string = &value }, .MainContent, .Yes, null, null, null, null);
    const job = bc.JobIndexBuilder{ .handle = 1 };
    try job.addField(std.testing.allocator, "bytes", .{ .binary = &value }, .Binary, .Yes, null, null, null, null);
    try std.testing.expectEqual(@as(usize, 2), field_calls);
}

test "KPI preserves string literals and sixteen pairs" {
    try bc.Job.Kpi.trackEvent(std.testing.allocator, .PerformSearch, .{ .query = "zig-query" });
    try std.testing.expectEqualSlices(u8, "zig-query", kpi[kpi_len - 9 .. kpi_len]);
    try bc.Job.Kpi.trackEvent(std.testing.allocator, .PerformSearch, .{ .a = 1, .b = 1, .c = 1, .d = 1, .e = 1, .f = 1, .g = 1, .h = 1,
        .i = 1, .j = 1, .k = 1, .l = 1, .m = 1, .n = 1, .o = 1, .p = 1 });
    try std.testing.expectEqualSlices(u8, &.{ 0xdc, 0, 16 }, kpi[0..3]);
    try std.testing.expectEqual(@as(u8, 0xd3), kpi[kpi_len - 9]);
    try bc.Job.Kpi.trackEvent(std.testing.allocator, .PerformSearch, .{ .count = std.math.maxInt(u64) });
    try std.testing.expectEqual(@as(u8, 0xcf), kpi[kpi_len - 9]);
    try std.testing.expectEqual(std.math.maxInt(u64), std.mem.readInt(u64, kpi[kpi_len - 8 ..][0..8], .big));
}
