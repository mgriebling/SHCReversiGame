//
//  SHCBoardDelegate.h
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCellState.h"

@protocol SHCBoardDelegate <NSObject>

- (void)cellStateChanged:(BoardCellState)state forColumn:(int)column andRow:(int)row;

@end
