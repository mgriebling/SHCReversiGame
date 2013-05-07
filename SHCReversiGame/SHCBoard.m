//
//  SHCBoard.m
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCBoard.h"
#import "SHCBoardDelegate.h"

@implementation SHCBoard {
    BoardCellState _board[MAX_COLS][MAX_ROWS];
    id<SHCBoardDelegate> _delegate;
}

- (id)init {
    if (self = [super init]) {
        [self clearBoard];
        _boardDelegate = [[SHCMulticastDelegate alloc] init];
        _delegate = (id)_boardDelegate;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    SHCBoard *board = [[[self class] allocWithZone:zone] init];
    memcpy(board->_board, _board, sizeof(NSUInteger) * MAX_COLS * MAX_ROWS);
    board->_boardDelegate = [[SHCMulticastDelegate alloc] init];
    board->_delegate = (id)_boardDelegate;
    return board;
}

- (void)checkBoundsForColumn:(NSInteger)column andRow:(NSInteger)row {
    if (column < 0 || column > MAX_COLS-1 || row < 0 || row > MAX_ROWS-1) {
        [NSException raise:NSRangeException format:@"row or column out of bounds"];
    }
}

- (BoardCellState)cellStateAtColumn:(NSInteger)column andRow:(NSInteger)row {
    [self checkBoundsForColumn:column andRow:row];
    return _board[column][row];
}

- (void)informDelegateOfStateChanged:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row {
    if ([_delegate respondsToSelector:@selector(cellStateChanged:forColumn:andRow:)]) {
        [_delegate cellStateChanged:state forColumn:column andRow:row];
    }
}

- (void)setCellState:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row {
    [self checkBoundsForColumn:column andRow:row];
    _board[column][row] = state;
    [self informDelegateOfStateChanged:state forColumn:column andRow:row];
}

- (void)clearBoard {
    memset(_board, BoardCellStateEmpty, sizeof(BoardCellState) * MAX_COLS * MAX_ROWS);
    [self informDelegateOfStateChanged:BoardCellStateEmpty forColumn:-1 andRow:-1];
}

- (NSUInteger)countCellsWithState:(BoardCellState)state {
    NSUInteger count = 0;
    for (int row = 0; row < MAX_ROWS; row++) {
        for (int col = 0; col < MAX_COLS; col++) {
            if ([self cellStateAtColumn:col andRow:row] == state) {
                count++;
            }
        }
    }
    return count;
}

@end
