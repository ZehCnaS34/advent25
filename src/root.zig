const std = @import("std");
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const splitScalar = std.mem.splitScalar;

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
    pub fn part1() !void {
        var it = splitScalar(u8, input, ',');
        while (it.next()) |line| {
            print("{s}\n", .{line});
        }
    }
};
