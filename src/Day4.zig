const std = @import("std");
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const bufPrint = std.fmt.bufPrint;
const splitScalar = std.mem.splitScalar;
const input = @embedFile("Day4.txt");

const Board = struct {
    allocator: std.mem.Allocator,
    grid: []const []const u8,
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

    fn iter(self: *const Board) Location {
        return .{ .board = self, .row = 0, .col = 0 };
    }

    fn cols(self: *const Board) usize {
        return self.lines.items[0].len;
    }

    fn rows(self: *const Board) usize {
        return self.lines.items.len;
    }
};

const Location = struct {
    board: *const Board,
    row: usize,
    col: usize,
    fn next(self: *Location) ?struct { usize, usize } {
        self.col += 1;
        if (self.col >= self.board.cols()) {
            self.col = 0;
            self.row += 1;
        }
        if (self.row >= self.board.rows()) {
            return null;
        }
        return .{
            self.row, self.row,
        };
    }
};

pub fn part1() !void {
    var board = try Board.init(std.heap.page_allocator);
    defer board.deinit();

    var iter = board.iter();
    while (iter.next()) |loc| {
        print("{}\n", .{loc});
    }
}

pub fn part2() !void {}
