const std = @import("std");
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const bufPrint = std.fmt.bufPrint;
const splitScalar = std.mem.splitScalar;
const input = @embedFile("Day4.txt");

const Board = struct {
    allocator: std.mem.Allocator,
    lines: std.ArrayList([]const u8),

    fn init(gpa: std.mem.Allocator) !Board {
        var lines: std.ArrayList([]const u8) = .empty;
        var lines_it = splitScalar(u8, input, '\n');
        while (lines_it.next()) |line| {
            try lines.append(gpa, line);
        }
        return Board{ .allocator = gpa, .lines = lines };
    }

    fn deinit(self: *Board) void {
        self.lines.deinit(self.allocator);
    }
};

pub fn part1() !void {
    var board = try Board.init(std.heap.page_allocator);
    defer board.deinit();

    for (0..board.lines.items.len) |row| {
        for (0..board.lines.items[row].len) |col| {
            if (board.lines.items[row][col] == '@') {
                const irow: isize = @intCast(row);
                const icol: isize = @intCast(col);
                for (irow - 1..irow + 2) |r| {
                    for (icol - 1..icol + 2) |c| {
                        if (r >= 0 and r < board.lines.items.len and c >= 0 and c < board.lines.items[r].len) {
                            print("Found @ at ({}, {})\n", .{ irow, icol });
                        }
                    }
                }
            }
        }
    }
}

pub fn part2() !void {}
