//
//  SHCBoardSquare.m
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCBoardSquare.h"

@implementation SHCBoardSquare {
    int _row;
    int _column;
    SHCReversiBoard * _board;
    UIImageView * _blackView;
    UIImageView * _whiteView;
}

- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(SHCReversiBoard *)board {
    self = [super initWithFrame:frame];
    if (self) {
        _row = (int)row;
        _column = (int)column;
        _board = board;
        
        // create the views for the playing piece graphics
        UIImage *blackImage = [UIImage imageNamed:@"ReversiBlackPiece.png"];
        _blackView = [[UIImageView alloc] initWithImage:blackImage];
        _blackView.alpha = 0.0;
        [self addSubview:_blackView];
        
        UIImage *whiteImage = [UIImage imageNamed:@"ReversiWhitePiece.png"];
        _whiteView = [[UIImageView alloc] initWithImage:whiteImage];
        _whiteView.alpha = 0.0;
        [self addSubview:_whiteView];
        
        self.backgroundColor = [UIColor clearColor];
        [self update];
        [_board.boardDelegate addDelegate:self];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)cellTapped:(UITapGestureRecognizer *)recognizer {
    if ([_board isValidMoveToColumn:_column andRow:_row]) {
        [_board makeMoveToColumn:_column andRow:_row];
    }
}

- (void)cellStateChanged:(BoardCellState)state forColumn:(int)column andRow:(int)row {
    if ((column == _column && row == _row) || (column == -1 && row == -1)) {
        [self update];
    }
}

- (void)update {
    // show/hide the images based on the cell state
    BoardCellState state = [_board cellStateAtColumn:_column andRow:_row];
    
    [UIView animateWithDuration:0.5 animations:^{ 
        self->_whiteView.alpha = state == BoardCellStateWhitePiece ? 1.0 : 0.0;
        self->_whiteView.transform = state == BoardCellStateWhitePiece ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, -20);
        self->_blackView.alpha = state == BoardCellStateBlackPiece ? 1.0 : 0.0;
        self->_blackView.transform = state == BoardCellStateBlackPiece ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, 20);
    }];

}

@end
