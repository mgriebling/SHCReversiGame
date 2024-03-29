//
//  SHCComputerOpponent.m
//  SHCReversiGame
//
//  Created by Michael Griebling on 7May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCComputerOpponent.h"

typedef struct {
    NSInteger column;
    NSInteger row;
} Move;

@implementation SHCComputerOpponent {
    SHCReversiBoard * _board;
    BoardCellState _computerColor;
    NSInteger _maxDepth;
}

- (id)initWithBoard:(SHCReversiBoard *)board color:(BoardCellState)computerColor maxDepth:(NSInteger)depth {
    if (self = [super init]) {
        _board = board;
        _computerColor = computerColor;
        _maxDepth = depth;
        
        // listen to game state changes in order to know when to make a move
        [_board.reversiBoardDelegate addDelegate:self];
    }
    return self;
}

- (void)gameStateChanged {
    if (_board.nextMove == _computerColor) {
        // pause 1 second, then make a move
        [self performSelector:@selector(makeNextMove) withObject:nil afterDelay:1.0];
    }
}

- (NSArray *)validMovesForBoard:(SHCReversiBoard *)board {
    NSMutableArray *moves = [NSMutableArray array];
    for (NSInteger row = 0; row < MAX_ROWS; row++) {
        for (NSInteger col = 0; col < MAX_COLS; col++) {
            if ([_board isValidMoveToColumn:col andRow:row]) {
                Move move = {.column = col, .row = row};
                [moves addObject:[NSValue valueWithBytes:&move objCType:@encode(Move)]];
            }
        }
    }
    return moves;
}

- (void)makeNextMove {
    Move bestMove = {.column = -1, .row = -1};
    NSInteger bestScore = NSIntegerMin;
    
    // check every possible move, then select the one with the best 'score'
    NSArray *moves = [self validMovesForBoard:_board];
    for (NSValue *moveValue in moves) {
        Move nextMove;
        [moveValue getValue:&nextMove];
        
        // clone the current board
        SHCReversiBoard *testBoard = [_board copyWithZone:nil];
        [testBoard makeMoveToColumn:nextMove.column andRow:nextMove.row];
        
        // compute the score -- i.e., difference between black and white scores
        NSInteger scoreForMove = [self scoreForBoard:testBoard depth:1];
        
        if (scoreForMove > bestScore || bestScore == NSIntegerMin) {
            bestScore = scoreForMove;
            bestMove.row = nextMove.row;
            bestMove.column = nextMove.column;
        }
    }
    
    if (bestMove.column != -1 && bestMove.row != -1) {
        [_board makeMoveToColumn:bestMove.column andRow:bestMove.row];
    }
}

- (NSInteger)scoreForBoard:(SHCReversiBoard *)board depth:(NSInteger)depth {
    // if we have reached the maximum search depth, the just compute the
    // score of the current board state
    if (depth >= _maxDepth) {
        return _computerColor == BoardCellStateWhitePiece ? board.whiteScore - board.blackScore : board.blackScore - board.whiteScore;
    }
    
    NSInteger minMax = NSIntegerMin;
    
    // check every valid next move for this particular board
    NSArray *moves = [self validMovesForBoard:board];
    for (NSValue *moveValue in moves) {
        Move nextMove;
        [moveValue getValue:&nextMove];
        
        // clone the board and make the move
        SHCReversiBoard *testBoard = [_board copyWithZone:nil];
        [testBoard makeMoveToColumn:nextMove.column andRow:nextMove.row];
        
        // compute the score for this board with a recursive call
        NSInteger score = [self scoreForBoard:testBoard depth:depth+1];
        
        // pick the best score
        if (depth % 2 == 0) {
            if (score > minMax || minMax == NSIntegerMin) {
                minMax = score;
            }
        } else {
            if (score < minMax || minMax == NSIntegerMin) {
                minMax = score;
            }
        }
    }
    return minMax;
}

@end
