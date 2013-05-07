//
//  SHCReversiBoard.m
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCReversiBoard.h"
#import "SHCReversiBoardDelegate.h"

typedef void (^BoardNavigationFunction)(NSInteger*, NSInteger*);

BoardNavigationFunction BoardNavigationFunctionRight = ^(NSInteger * c, NSInteger * r) {
    (*c)++;
};

BoardNavigationFunction BoardNavigationFunctionLeft = ^(NSInteger * c, NSInteger * r) {
    (*c)--;
};

BoardNavigationFunction BoardNavigationFunctionUp = ^(NSInteger * c, NSInteger * r) {
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionDown = ^(NSInteger * c, NSInteger * r) {
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionRightUp = ^(NSInteger * c, NSInteger * r) {
    (*c)++;
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionRightDown = ^(NSInteger * c, NSInteger * r) {
    (*c)++;
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionLeftUp = ^(NSInteger * c, NSInteger * r) {
    (*c)--;
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionLeftDown = ^(NSInteger * c, NSInteger * r) {
    (*c)--;
    (*r)--;
};

@implementation SHCReversiBoard {
    BoardNavigationFunction _boardNavigationFunctions[8];
    id<SHCReversiBoardDelegate> _delegate;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
        [self setToInitialState];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    SHCReversiBoard *board = [super copyWithZone:zone];
    board->_nextMove = _nextMove;
    board->_whiteScore = _whiteScore;
    board->_blackScore = _blackScore;
    return board;
}

- (void)commonInit {
    _boardNavigationFunctions[0] = BoardNavigationFunctionUp;
    _boardNavigationFunctions[1] = BoardNavigationFunctionDown;
    _boardNavigationFunctions[2] = BoardNavigationFunctionLeft;
    _boardNavigationFunctions[3] = BoardNavigationFunctionRight;
    _boardNavigationFunctions[4] = BoardNavigationFunctionLeftDown;
    _boardNavigationFunctions[5] = BoardNavigationFunctionLeftUp;
    _boardNavigationFunctions[6] = BoardNavigationFunctionRightDown;
    _boardNavigationFunctions[7] = BoardNavigationFunctionRightUp;
    _reversiBoardDelegate = [[SHCMulticastDelegate alloc] init];
    _delegate = (id)_reversiBoardDelegate;
}

- (void)setToInitialState {
    [super clearBoard];
    
    // add initial play counters
    [super setCellState:BoardCellStateWhitePiece forColumn:3 andRow:3];
    [super setCellState:BoardCellStateBlackPiece forColumn:4 andRow:3];
    [super setCellState:BoardCellStateBlackPiece forColumn:3 andRow:4];
    [super setCellState:BoardCellStateWhitePiece forColumn:4 andRow:4];
    
    _whiteScore = 2;
    _blackScore = 2;
    _nextMove = BoardCellStateBlackPiece;
}

- (BOOL)canPlayerMakeAMove:(BoardCellState)state {
    for (int row = 0; row < MAX_ROWS; row++) {
        for (int col = 0; col < MAX_COLS; col++) {
            if ([self isValidMoveToColumn:col andRow:row forState:state]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)hasGameFinished {
    return ![self canPlayerMakeAMove:BoardCellStateBlackPiece] && ![self canPlayerMakeAMove:BoardCellStateWhitePiece];
}

- (BOOL)moveSurroundsCountersForColumn:(NSInteger)column andRow:(NSInteger)row withNavigationFunction:(BoardNavigationFunction)navigationFunction toState:(BoardCellState)state {
    NSInteger index = 1;
    
    // advance to the next cell
    navigationFunction(&column, &row);
    
    // while within the boards of the board
    while (column >= 0 && column < MAX_COLS && row >= 0 && row < MAX_ROWS) {
        BoardCellState currentCellState = [super cellStateAtColumn:column andRow:row];
        
        // the cell that is the immediate neighbour must be of the other colour
        if (index == 1) {
            if (currentCellState != [self invertState:state]) {
                return NO;
            }
        } else {
            if (currentCellState == state) {
                return YES;
            }
            
            // if we have reached an empty cell -fail
            if (currentCellState == BoardCellStateEmpty) {
                return NO;
            }
        }
        
        index++;
        
        // advance to the next cell
        navigationFunction(&column, &row);
    }
    return NO;
}

- (BOOL)isValidMoveToColumn:(NSInteger)column andRow:(NSInteger)row {
    return [self isValidMoveToColumn:column andRow:row forState:self.nextMove];
}

- (BOOL)isValidMoveToColumn:(NSInteger)column andRow:(NSInteger)row forState:(BoardCellState)state {
    // check the cell is empty
    if ([super cellStateAtColumn:column andRow:row] != BoardCellStateEmpty) {
        return NO;
    }
    
    // check each direction
    for (int i=0; i<8; i++) {
        if ([self moveSurroundsCountersForColumn:column andRow:row withNavigationFunction:_boardNavigationFunctions[i] toState:state]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)makeMoveToColumn:(NSInteger)column andRow:(NSInteger)row {
    [self setCellState:self.nextMove forColumn:column andRow:row];
    
    // check the 8 playing directions and flip pieces
    for (int i=0; i<8; i++) {
        [self flipOpponentsCountersForColumn:column andRow:row withNavigationFunction:_boardNavigationFunctions[i] toState:self.nextMove];
    }
    
    [self switchTurns];
    
    _gameHasFinished = [self hasGameFinished];
    _whiteScore = [self countCellsWithState:BoardCellStateWhitePiece];
    _blackScore = [self countCellsWithState:BoardCellStateBlackPiece];
    
    if ([_delegate respondsToSelector:@selector(gameStateChanged)]) {
        [_delegate gameStateChanged];
    }
}

- (void)switchTurns {
    // switch players
    BoardCellState nextMoveTemp = [self invertState:self.nextMove];
    
    // only switch play if this player can make a move
    if ([self canPlayerMakeAMove:nextMoveTemp]) {
        _nextMove = nextMoveTemp;
    }
}

- (BoardCellState)invertState:(BoardCellState)state {
    if (state == BoardCellStateBlackPiece) {
        return BoardCellStateWhitePiece;
    }
    
    if (state == BoardCellStateWhitePiece) {
        return BoardCellStateBlackPiece;
    }
    
    return BoardCellStateEmpty;
}

- (void) flipOpponentsCountersForColumn:(NSInteger)column andRow:(NSInteger)row withNavigationFunction:(BoardNavigationFunction)navigationFunction toState:(BoardCellState)state {
    // are any pieces surrounded in this direction?
    if (![self moveSurroundsCountersForColumn:column andRow:row withNavigationFunction:navigationFunction toState:state]) {
        return;
    }
    
    BoardCellState opponentsState = [self invertState:state];
    BoardCellState currentCellState;
    
    // flip counters until the edge of the board is reached, or
    // a piece of the current state is reached
    do {
        // advance to the next cell
        navigationFunction(&column, &row);
        currentCellState = [super cellStateAtColumn:column andRow:row];
        [self setCellState:state forColumn:column andRow:row];
    } while (column>=0 && column<MAX_COLS && row>=0 && row<MAX_ROWS && currentCellState == opponentsState);
}

@end
