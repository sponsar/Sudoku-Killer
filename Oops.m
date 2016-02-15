//
//  Oops.m
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/7/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "Oops.h"

// -----------------------------------------------------------------

@implementation Oops

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)initWithString:(NSString *)hint
{
    self = [super initWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.5]];//size自动是windows size
    self.userInteractionEnabled = YES;
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    CCLabelTTF *hintLabel = [CCLabelTTF labelWithString:hint fontName:@"ArialMT" fontSize:10];//dimensions:(CGSize){200,200}
    hintLabel.positionType = CCPositionTypeNormalized;
    hintLabel.position = (CGPoint){0.5, 0.5};
    [self addChild:hintLabel];
    return self;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event//这个方法属于父类，override这个方法
{
    [self removeFromParentAndCleanup:YES];
}

// -----------------------------------------------------------------

@end





