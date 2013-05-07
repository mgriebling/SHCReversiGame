//
//  SHCReversiBoardView.m
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCReversiBoardView.h"
#import "SHCBoardSquare.h"

@implementation SHCReversiBoardView

- (id)initWithFrame:(CGRect)frame andBoard:(SHCReversiBoard *)board {
    if (self = [super initWithFrame:frame]) {
        float rowHeight = frame.size.height / MAX_ROWS;
        float columnWidth = frame.size.width / MAX_COLS;
        
        // create the 8 x 8 cells for this board
        for (int row = 0; row < MAX_ROWS; row++) {
            for (int col = 0; col < MAX_COLS; col++) {
                SHCBoardSquare *square = [[SHCBoardSquare alloc] initWithFrame:CGRectMake(col*columnWidth, row*rowHeight, columnWidth, rowHeight) column:col row:row board:board];
                [self addSubview:square];
            }
        }
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
