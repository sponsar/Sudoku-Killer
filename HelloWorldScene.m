//
//  HelloWorldScene.m
//
//  Created by : 黄 信尧
//  Project    : SudokuByYao
//  Date       : 2/2/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"
#import "SolveBoardScene.h"
#import "SelectDifficultyScene.h"

// -----------------------------------------------------------------------

@implementation HelloWorldScene

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    
    [[OALSimpleAudio sharedInstance] playBg:@"AngryBird.mp3" loop:YES];
    
    // Background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;//CGPoint
    background.contentSize = [CCDirector sharedDirector].viewSize;//这是个CGSize的structure
    background.color = [CCColor whiteColor];
    [self addChild:background];
    
    // The standard Hello World text
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Sudoku" fontName:@"ArialMT" fontSize:56];//64
    label.positionType = CCPositionTypeNormalized;//就是用比例还是用具体像素
    label.position = (CGPoint){0.5, 0.8};//就是CGPointMake(0.5, 0.5)
    label.color = [CCColor blackColor];
    [self addChild:label];
    
    //Button1
    CCButton *btnPlay = [CCButton buttonWithTitle:@"Play" fontName:nil fontSize:28];
    btnPlay.positionType = CCPositionTypeNormalized;
    btnPlay.position = (CGPoint){0.5, 0.6};
    btnPlay.color = [CCColor blackColor];
    [btnPlay setTarget:self selector:@selector(clickPlayButton)];
    [self addChild:btnPlay];
    
    //Button2
    CCButton *btnSolve = [CCButton buttonWithTitle:@"Solve" fontName:nil fontSize:28];
    btnSolve.positionType = CCPositionTypeNormalized;
    btnSolve.position = (CGPoint){0.5, 0.4};
    btnSolve.color = [CCColor blackColor];
    [btnSolve setTarget:self selector:@selector(clickSolveButton)];
    [self addChild:btnSolve];
    
    // done
    return self;
}



- (void)clickPlayButton
{
    CCLOG(@"touch play");
    [[CCDirector sharedDirector] pushScene:[[SelectDifficultyScene alloc] init]];
}

- (void)clickSolveButton
{
    CCLOG(@"touch solve");
    [[CCDirector sharedDirector] pushScene:[[SolveBoardScene alloc] init]];
}

// -----------------------------------------------------------------------

@end
