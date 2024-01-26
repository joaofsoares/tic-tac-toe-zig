const std = @import("std");
const print = std.debug.print;
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var space = [3][3]u8{
        [_]u8{ '1', '2', '3' },
        [_]u8{ '4', '5', '6' },
        [_]u8{ '7', '8', '9' },
    };

    var buf_player1: [20]u8 = undefined;
    var buf_player2: [20]u8 = undefined;

    print("====================================\n", .{});
    print("Enter the name of the Player 1: ", .{});
    const player1 = (try stdin.readUntilDelimiterOrEof(&buf_player1, '\n')).?;

    print("\n====================================\n", .{});
    print("Enter the name of the Player 2: ", .{});
    const player2 = (try stdin.readUntilDelimiterOrEof(&buf_player2, '\n')).?;
    print("\n====================================\n", .{});

    var row: u8 = 0;
    var column: u8 = 0;
    var token: u8 = 'X';
    var tie = false;

    while (!check_winner(&space, &tie)) {
        print_board(&space);
        try assign_position(&row, &column, &token, &space, player1, player2);
    }

    if (token == 'X' and tie == false) {
        print("\nPlayer {s} wins!!!\n\n", .{player2});
    } else if (token == '0' and tie == false) {
        print("\nPlayer {s} wins!!!\n\n", .{player1});
    } else {
        print("\nIt's a draw!\n\n", .{});
    }

    print_board(&space);
}

fn print_board(space: *[3][3]u8) void {
    print("     |     |     \n", .{});
    print("  {c}  |  {c}  |  {c}  \n", .{ space[0][0], space[0][1], space[0][2] });
    print("_____|_____|_____\n", .{});
    print("     |     |     \n", .{});
    print("  {c}  |  {c}  |  {c}  \n", .{ space[1][0], space[1][1], space[1][2] });
    print("_____|_____|_____\n", .{});
    print("     |     |     \n", .{});
    print("  {c}  |  {c}  |  {c}  \n", .{ space[2][0], space[2][1], space[2][2] });
    print("     |     |     \n", .{});
}

fn assign_position(row: *u8, column: *u8, token: *u8, space: *[3][3]u8, p1: []u8, p2: []u8) !void {
    var digit: i16 = undefined;
    var input: [4]u8 = undefined;

    if (token.* == 'X') {
        print("\nPlayer 1 - {s} - enter a digit: ", .{p1});
        if (try stdin.readUntilDelimiterOrEof(input[0..], '\n')) |user_input| {
            digit = try std.fmt.parseInt(i16, user_input, 10);
        }
    }

    if (token.* == '0') {
        print("\nPlayer 2 - {s} - enter a digit: ", .{p2});
        if (try stdin.readUntilDelimiterOrEof(input[0..], '\n')) |user_input| {
            digit = try std.fmt.parseInt(i16, user_input, 10);
        }
    }

    if (digit == 1) {
        row.* = 0;
        column.* = 0;
    }

    if (digit == 2) {
        row.* = 0;
        column.* = 1;
    }

    if (digit == 3) {
        row.* = 0;
        column.* = 2;
    }

    if (digit == 4) {
        row.* = 1;
        column.* = 0;
    }

    if (digit == 5) {
        row.* = 1;
        column.* = 1;
    }

    if (digit == 6) {
        row.* = 1;
        column.* = 2;
    }

    if (digit == 7) {
        row.* = 2;
        column.* = 0;
    }

    if (digit == 8) {
        row.* = 2;
        column.* = 1;
    }

    if (digit == 9) {
        row.* = 2;
        column.* = 2;
    }

    if ((digit < 1) or (digit > 9)) {
        print("Invalid!", .{});
    } else if (token.* == 'X' and space[row.*][column.*] != 'X' and space[row.*][column.*] != '0') {
        space[row.*][column.*] = 'X';
        token.* = '0';
    } else if (token.* == '0' and space[row.*][column.*] != 'X' and space[row.*][column.*] != '0') {
        space[row.*][column.*] = '0';
        token.* = 'X';
    } else {
        print("There is no empty space!\n", .{});
        try assign_position(&row.*, &column.*, &token.*, &space.*, p1, p2);
    }
}

fn check_winner(space: *[3][3]u8, tie: *bool) bool {
    for (0..3) |i| {
        if (space[i][0] == space[i][1] and space[i][0] == space[i][2] or space[0][i] == space[1][i] and space[0][i] == space[2][i]) {
            return true;
        }
    }

    if (space[0][0] == space[1][1] and space[1][1] == space[2][2] or space[0][2] == space[1][1] and space[1][1] == space[2][0]) {
        return true;
    }

    for (0..3) |i| {
        for (0..3) |j| {
            if (space[i][j] != 'X' and space[i][j] != '0') {
                return false;
            }
        }
    }

    tie.* = true;
    return false;
}
