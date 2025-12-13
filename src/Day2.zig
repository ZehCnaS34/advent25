const std = @import("std");
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const bufPrint = std.fmt.bufPrint;
const splitScalar = std.mem.splitScalar;
const input = @embedFile("day-2.txt");

const Range = struct {
    start: usize,
    end: usize,

    fn parse(line: []const u8) !Range {
        var lit = splitScalar(u8, std.mem.trim(u8, line, "\n"), '-');

        const start = try parseInt(usize, lit.next().?, 10);
        const end = try parseInt(usize, lit.next().?, 10);

        return .{
            .start = start,
            .end = end,
        };
    }

    fn isInvalid(id: []u8) !usize {
        var size: usize = 1;
        sizeLoop: while (size < id.len) : (size += 1) {
            const reference = id[0..size];
            var offset = size;
            while (offset < id.len) : (offset += size) {
                if (offset > id.len - size) continue :sizeLoop;
                const candidate = id[offset .. offset + size];
                if (!std.mem.eql(u8, reference, candidate)) {
                    continue :sizeLoop;
                }
            }
            return try parseInt(usize, id, 10);
        }
        return 0;
    }
};

pub fn part1() !void {
    var it = splitScalar(u8, input, ',');
    var ans: usize = 0;

    while (it.next()) |line| {
        if (line.len == 0) break;

        const range = try Range.parse(line);

        var buffer: [128]u8 = undefined;
        for (range.start..range.end + 1) |i| {
            const id = try bufPrint(&buffer, "{}", .{i});
            if (@mod(id.len, 2) == 0 and mem.eql(u8, id[0 .. id.len / 2], id[id.len / 2 ..])) {
                ans += try parseInt(usize, id, 10);
            }
        }
    }

    print("Day2 Part1: {d}\n", .{ans});
}

pub fn part2() !void {
    var it = splitScalar(u8, input, ',');
    var ans: usize = 0;

    while (it.next()) |line| {
        if (line.len == 0) break;

        const range = try Range.parse(line);

        var buffer: [128]u8 = undefined;
        for (range.start..range.end + 1) |i| {
            const result = try bufPrint(&buffer, "{}", .{i});
            ans += try Range.isInvalid(result);
        }
    }

    print("Day2 Part1: {d}\n", .{ans});
}
