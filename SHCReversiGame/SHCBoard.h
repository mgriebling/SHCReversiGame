//
//  SHCBoard.h
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCellState.h"
#import "SHCMulticastDelegate.h"

@interface SHCBoard : NSObject <NSCopying>

#define MAX_ROWS    (8)
#define MAX_COLS    (8)

@property (readonly) SHCMulticastDelegate *boardDelegate;

- (BoardCellState) cellStateAtColumn:(NSInteger)column andRow:(NSInteger)row;
- (void)setCellState:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row;
- (void)clearBoard;
- (NSUInteger)countCellsWithState:(BoardCellState)state;

@end
