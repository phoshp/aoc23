const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    std.log.info("Part A: {}", .{try common(false, alloc)});
    std.log.info("Part B: {}", .{try common(true, alloc)});
}

pub fn common(partB: bool, alloc: std.mem.Allocator) !u32 {
    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    var input = reader.reader();

    var buffer: [64]u8 = undefined;
    var result: u32 = 0;

    while (try input.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var list = std.ArrayList(u8).init(alloc);
        defer list.deinit();

        if (partB) { // naaaaasty hack
            _ = std.mem.replace(u8, line, "one", "o1e", line);
            _ = std.mem.replace(u8, line, "two", "t2o", line);
            _ = std.mem.replace(u8, line, "three", "t3e", line);
            _ = std.mem.replace(u8, line, "four", "f4r", line);
            _ = std.mem.replace(u8, line, "five", "f5e", line);
            _ = std.mem.replace(u8, line, "six", "s6x", line);
            _ = std.mem.replace(u8, line, "seven", "s7n", line);
            _ = std.mem.replace(u8, line, "eight", "e8t", line);
            _ = std.mem.replace(u8, line, "nine", "n9e", line);
        }

        for (line) |char| {
            if (std.ascii.isDigit(char)) {
                try list.append(char);
            }
        }

        if (list.items.len == 1) {
            try list.append(list.items[0]);
            result += try std.fmt.parseInt(u32, list.items[0..], 10);
        } else {
            result += try std.fmt.parseInt(u32, &[2]u8{ list.items[0], list.getLast() }, 10);
        }
    }

    return result;
}
