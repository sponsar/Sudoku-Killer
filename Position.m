//
//  Position.m
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/6/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Position.h"

// -----------------------------------------------------------------

@implementation Position

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)initWithRow:(int)row andCol:(int)col
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    self.row = row;
    self.col = col;
    return self;
}

// -----------------------------------------------------------------

@end





