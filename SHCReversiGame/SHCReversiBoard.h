//
//  SHCReversiBoard.h
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCBoard.h"

@interface SHCReversiBoard : SHCBoard <NSCopying>

@property (readonly) NSInteger whiteScore;
@property (readonly) NSInteger blackScore;
@property (readonly) BoardCellState nextMove;
@property (readonly) SHCMulticastDelegate *reversiBoardDelegate;
@property (readonly) BOOL gameHasFinished;

- (void)setToInitialState;
- (BOOL)isValidMoveToColumn:(NSInteger)column andRow:(NSInteger)row;
- (void)makeMoveToColumn:(NSInteger)column andRow:(NSInteger)row;

@end
