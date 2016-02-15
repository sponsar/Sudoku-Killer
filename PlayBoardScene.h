//
//  PlayBoardScene.h
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/9/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------

@interface PlayBoardScene : CCScene

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)initWithLevel:(int)level;

// -----------------------------------------------------------------

@end




