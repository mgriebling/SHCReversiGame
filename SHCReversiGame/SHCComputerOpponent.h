//
//  SHCComputerOpponent.h
//  SHCReversiGame
//
//  Created by Michael Griebling on 7May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCReversiBoardDelegate.h"
#import "SHCReversiBoard.h"

@interface SHCComputerOpponent : NSObject <SHCReversiBoardDelegate>

- (id)initWithBoard:(SHCReversiBoard *)board color:(BoardCellState)computerColor maxDepth:(NSInteger)depth;

@end
