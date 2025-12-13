const std = @import("std");
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const bufPrint = std.fmt.bufPrint;
const splitScalar = std.mem.splitScalar;
const input = @embedFile("day-3.txt");

pub fn part1() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var it = splitScalar(u8, input, '\n');
    var ans: i32 = 0;

    while (it.next()) |line| {
        var rtl = try allocator.alloc(u8, line.len);
        var ltr = try allocator.alloc(u8, line.len);

        for (0..line.len) |i| {
            if (i != 0) {
                ltr[i] = @max(line[i], ltr[i - 1]);
                rtl[line.len - i - 1] = @max(line[line.len - i - 1], rtl[line.len - i]);
            } else {
                ltr[i] = line[i];
                rtl[line.len - 1] = line[line.len - 1];
            }
        }

        var max_int: ?u8 = null;

        for (0..line.len - 1) |i| {
            const string = [2]u8{ ltr[i], rtl[i + 1] };
            const value = try parseInt(u8, &string, 10);
            if (max_int == null or value > max_int.?) {
                max_int = value;
            }
        }

        ans += @as(i32, max_int.?);
    }

    print("Day3 Part1: {d}\n", .{ans});
}

pub fn part2() !void {
    var it = splitScalar(u8, input, '\n');
    var ans: i64 = 0;

    while (it.next()) |line| {
        var digit_indices = [_]usize{0} ** 12;
        for (line.len - 12..line.len, 0..) |li, di| {
            digit_indices[di] = li;
        }

        var start: usize = digit_indices[0] - 1;
        while (0 <= start) : (start -= 1) {
            var focus = start;

            for (0..12) |di| {
                if (line[digit_indices[di]] > line[focus]) break;

                const tmp = digit_indices[di];
                digit_indices[di] = focus;
                focus = tmp;
            }

            if (start == 0) {
                break;
            }
        }

        var digits = [_]u8{0} ** 12;
        for (digit_indices, 0..) |di, do| {
            digits[do] = line[di];
        }

        ans += try parseInt(i64, &digits, 10);
    }

    print("Day3 Part2: {d}\n", .{ans});
}
