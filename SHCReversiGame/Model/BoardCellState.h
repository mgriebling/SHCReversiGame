//
//  BoardCellState.h
//  SHCReversiGame
//
//  Created by Michael Griebling on 6May2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#ifndef SHCReversiGame_BoardCellState_h
#define SHCReversiGame_BoardCellState_h

typedef NS_ENUM (NSUInteger, BoardCellState) {
    BoardCellStateEmpty = 0,
    BoardCellStateBlackPiece = 1,
    BoardCellStateWhitePiece = 2
};

#endif
