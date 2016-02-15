//
//  TableViewDataSource.m
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/8/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TableViewDataSource.h"

#define EMPTY 0
#define CIRCLE 1
#define TICK 2

// -----------------------------------------------------------------

@implementation TableViewDataSource{
    float _rowHeight;
    NSArray *_array;
}

// -----------------------------------------------------------------
#pragma protocol

- (instancetype)initWithNumbersArray:(NSArray *)array//50
{
    self = [super init];
    _array = array;
    return self;
}

- (CCTableViewCell*) tableView:(CCTableView*)tableView nodeForRowAtIndex:(NSUInteger) index//从0开始
{
    // Cell
    CCTableViewCell* cell = [CCTableViewCell node];
    cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);//横坐标是百分比，纵坐标是像素点
    cell.contentSize = CGSizeMake(1, 40);
    //_rowHeight = cell.contentSize.height;
    
    // Create a label with the row number
    CCLabelTTF* lbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level%lu", index+1] fontName:nil fontSize:15];
    lbl.color = [CCColor blackColor];
    lbl.positionType = CCPositionTypeNormalized;
    lbl.position = CGPointMake(0.4, 0.5);
    lbl.contentSizeType = CCSizeTypeNormalized;
    lbl.contentSize = CGSizeMake(1, 1);
    [cell addChild:lbl];
    
    // Create a sprite
    NSNumber *num = [_array objectAtIndex:index];
    int status = [num intValue];
    CCSprite *sprite;
    if (status == EMPTY) sprite = [CCSprite spriteWithImageNamed:@"white_square.png"];
    else if (status == CIRCLE) sprite = [CCSprite spriteWithImageNamed:@"circle.png"];
    else sprite = [CCSprite spriteWithImageNamed:@"tick.png"];
    sprite.scale = 0.2;
    sprite.positionType = CCPositionTypeNormalized;
    sprite.position = CGPointMake(0.9, 0.5);
    [cell addChild:sprite];
    
    return cell;
}

-(NSUInteger) tableViewNumberOfRows:(CCTableView*) tableView {
    return 50;//就是在这里决定多少个cells
}
/*
 //optional
 -(float) tableView:(CCTableView*)tableView heightForRowAtIndex:(NSUInteger)index {
 return _rowHeight;
 }
 */
// -----------------------------------------------------------------

@end





