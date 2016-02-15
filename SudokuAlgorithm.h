//
//  SudokuAlgorithm.h
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/5/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Position.h"

// -----------------------------------------------------------------




@interface SudokuAlgorithm : NSObject

// -----------------------------------------------------------------
// properties
@property (nonatomic) BOOL atLeastTwoSolutions;
// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;

- (BOOL)checkPosition:(Position *)position character:(char)c;
- (BOOL)isValidSudoku:(char [9][9])board;
- (BOOL)place;
- (BOOL)solveSudoku:(char [9][9])board;
- (BOOL)solvable:(char [9][9])board;

// -----------------------------------------------------------------

@end




