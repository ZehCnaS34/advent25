const std = @import("std");
const fmt = std.fmt;
const print = std.debug.print;
const day1 = @import("day1.zig");

pub fn solveDay1Part1() !void {
    const size: i32 = 100;
    var it = std.mem.splitScalar(u8, day1.input, '\n');
    var position: i32 = 50;
    var times: i32 = 0;
    while (it.next()) |c| {
        const value: i32 = try fmt.parseInt(i32, c[1..], 10);
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
    const assert = std.debug.assert;

    fn new() Dial {
        return .{
            .position = 50,
            .times = 0,
        };
    }
    
    fn rotateRight(self: *Dial, amount: i32) *Dial {
        if (amount == 0) return self;
        self.position += 1;
        if (self.position == 0) {
            self.times += 1;
        } 
        if (self.position == 100) {
            self.position = 0;
        }
        return self.rotateRight(amount+1);
    }

    fn rotateLeft(self: *Dial, amount: i32) *Dial {
        if (amount == 0) return self;
        self.position -= 1;
        if (self.position == 0) {
            self.times += 1;
        } 
        if (self.position == -1) {
            self.position = 99;
        }
        return self.rotateLeft(amount-1);
    }
};

test "over rotate right" {
    var dial = Dial.new();
    dial.rotateRight(220);
    try std.testing.expectEqual(70, dial.position);
    try std.testing.expectEqual(2, dial.times);
}

test "over rotate left" {
    const dial = Dial.new();
    dial.rotateLeft(220);
    try std.testing.expectEqual(30, dial.position);
    try std.testing.expectEqual(2, dial.times);
}

pub fn solveDay1Part2() !void {
    var it = std.mem.splitScalar(u8, day1.input, '\n');
    var dial = Dial.new();

    while (it.next()) |line| {
        const amount: i32 = try fmt.parseInt(i32, line[1..], 10);
        if (line[0] == 'L') {
            dial.rotateLeft(amount);
        } else if (line[0] == 'R') {
            dial.rotateRight(amount);
        }
    }

    print("Day1 Part2: {d}\n", .{dial.times});
}
