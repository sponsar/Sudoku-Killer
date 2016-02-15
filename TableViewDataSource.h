//
//  TableViewDataSource.h
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/8/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

// -----------------------------------------------------------------

@interface TableViewDataSource : NSObject<CCTableViewDataSource>
- (instancetype)initWithNumbersArray:(NSArray *)array;
@end




