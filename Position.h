//
//  Position.h
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/6/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface Position : NSObject

// -----------------------------------------------------------------
// properties
@property (nonatomic) int row;
@property (nonatomic) int col;
// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)initWithRow:(int)row andCol:(int)col;
// -----------------------------------------------------------------

@end


