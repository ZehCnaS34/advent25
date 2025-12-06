const std = @import("std");
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const bufPrint = std.fmt.bufPrint;
const splitScalar = std.mem.splitScalar;
const allocator = std.heap.page_allocator;

pub const Day1 = struct {
    const input = @embedFile("day-1.txt");

    pub fn part1() !void {
        const size: i32 = 100;
        var it = splitScalar(u8, input, '\n');
        var position: i32 = 50;
        var times: i32 = 0;
        while (it.next()) |c| {
            if (c.len == 0) break;
            const value: i32 = try parseInt(i32, c[1..], 10);
            if (c[0] == 'L') {
                position = @mod(position - value, size);
            } else if (c[0] == 'R') {
                position = @mod(position + value, size);
            }
            if (position == 0) {
                times += 1;
            }
        }
        print("Day1 Part1: {d}\n", .{times});
    }

    const Dial = struct {
        position: i32,
        times: i32,

        const size: i32 = 100;

        fn new() Dial {
            return .{
                .position = 50,
                .times = 0,
            };
        }

        fn rotateRight(self: *Dial, amount: i32) void {
            if (amount == 0) return;
            self.position += 1;
            if (self.position == 100) {
                self.position = 0;
            }
            if (self.position == 0) {
                self.times += 1;
            }
            self.rotateRight(amount - 1);
        }

        fn rotateLeft(self: *Dial, amount: i32) void {
            if (amount == 0) return;
            self.position -= 1;
            if (self.position == -1) {
                self.position = 99;
            }
            if (self.position == 0) {
                self.times += 1;
            }
            self.rotateLeft(amount - 1);
        }
    };

    pub fn part2() !void {
        var it = splitScalar(u8, input, '\n');
        var dial = Dial.new();

        while (it.next()) |line| {
            if (line.len == 0) break;
            const amount: i32 = try parseInt(i32, line[1..], 10);
            if (line[0] == 'L') {
                dial.rotateLeft(amount);
            } else if (line[0] == 'R') {
                dial.rotateRight(amount);
            }
        }

        print("Day1 Part2: {d}\n", .{dial.times});
    }

    test "over rotate right" {
        var dial = Dial.new();
        dial.rotateRight(220);
        try std.testing.expectEqual(70, dial.position);
        try std.testing.expectEqual(2, dial.times);
    }

    test "over rotate left" {
        var dial = Dial.new();
        dial.rotateLeft(220);
        try std.testing.expectEqual(30, dial.position);
        try std.testing.expectEqual(2, dial.times);
    }
};

pub const Day2 = struct {
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
};

pub const Day3 = struct {
    const input = @embedFile("day-3.txt");

    pub fn part1() !void {
        var buffer: [1000]u8 = undefined;
        var fba = std.heap.FixedBufferAllocator.init(&buffer);
        const allo = fba.allocator();
        var it = splitScalar(u8, input, '\n');
        var ans: i32 = 0;

        while (it.next()) |line| {
            var digits = try allo.alloc(u8, line.len);
            var rtl = try allo.alloc(u8, line.len);
            var ltr = try allo.alloc(u8, line.len);
            defer allo.free(digits);
            defer allo.free(rtl);
            defer allo.free(ltr);

            for (line, 0..) |c, i| {
                digits[i] = c - '0';
            }

            for (0..digits.len) |i| {
                if (i != 0) {
                    ltr[i] = @max(digits[i], ltr[i - 1]);
                    rtl[line.len - i - 1] = @max(digits[line.len - i - 1], rtl[line.len - i]);
                } else {
                    ltr[i] = digits[i];
                    rtl[line.len - 1] = digits[line.len - 1];
                }
            }

            var max_int: ?u8 = null;

            for (0..digits.len - 1) |i| {
                const string = [2]u8{ ltr[i] + '0', rtl[i + 1] + '0' };
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
        const ans: i32 = 0;

        while (it.next()) |line| {
            var digits = try allocator.alloc(u8, line.len);
            for (line, 0..) |c, i| {
                digits[i] = c - '0';
            }
        }

        print("Day3 Part1: {d}\n", .{ans});
    }
};

test "example problem" {
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;

    var it = splitScalar(u8, input, '\n');

    while (it.next()) |line| {
        var digits = try allocator.alloc(u8, line.len);

        for (line, 0..) |c, i| {
            digits[i] = c - '0';
        }
    }
}
