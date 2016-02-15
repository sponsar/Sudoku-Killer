//
//  SelectDifficultyScene.m
//
//  Created by : 黄 信尧
//  Project    : SudokuByYao
//  Date       : 2/4/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "SelectDifficultyScene.h"
#import "PlayBoardScene.h"

#define EMPTY 0
#define CIRCLE 1
#define TICK 2

// -----------------------------------------------------------------

@implementation SelectDifficultyScene{
    NSMutableArray *_statusArray;
}

// -----------------------------------------------------------------
+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    // Background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;//CGPoint
    background.contentSize = [CCDirector sharedDirector].viewSize;//这是个CGSize的structure
    background.color = [CCColor whiteColor];
    [self addChild:background];
    
    // HomeButton
    CCButton *btnHome = [CCButton buttonWithTitle:@"Home" fontName:nil fontSize:20];
    btnHome.positionType = CCPositionTypeNormalized;
    btnHome.position = (CGPoint){0.1, 0.9};
    btnHome.color = [CCColor blackColor];
    [btnHome setTarget:self selector:@selector(clickHomeButton)];
    [self addChild:btnHome];
    
    // TableView
    CCTableView* tableView = [CCTableView node];
    tableView.rowHeight = 40;
    tableView.positionType = CCPositionTypeNormalized;
    tableView.position = CGPointMake(0.4, 0.25);
    tableView.contentSizeType = CCSizeTypeNormalized;
    tableView.contentSize = CGSizeMake(0.2, 0.5);
    
    //Running Code when a Cell gets selected, 点击tableview自动执行以下代码
    //tableView.block = ^(CCTableView* tableView){ CCLOG(@"Selected cell at level%i", (int)tableView.selectedRow);};//如果写了setTarget就不会执行block
    [tableView setTarget:self selector:@selector(clickTableView:)];
    
    [self addChild:tableView];
    _statusArray = [self loadStatusArray];
    tableView.dataSource = [[TableViewDataSource alloc] initWithNumbersArray:_statusArray];
    
    return self;
}

- (void)clickHomeButton
{
    CCLOG(@"touch home");
    [[CCDirector sharedDirector] popToRootScene];
}

- (void)clickTableView:(CCTableView *)sender
{
    int level = (int)sender.selectedRow+1;
    CCLOG(@"Selected level%i", level);
    [self saveStatusArray:level-1 withStatus:CIRCLE];
    [[CCDirector sharedDirector] presentScene:[[PlayBoardScene alloc] initWithLevel:level]];
}

- (NSString *)filePathOfStatus
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"statusArray"];
}

- (void)saveStatusArray:(int)index withStatus:(int)status
{
    NSNumber *num = [_statusArray objectAtIndex:index];
    if ([num intValue] == TICK) return;//如果已经赢过，就不再设为1（待续）
    NSString *string = [self filePathOfStatus];
    [_statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:status]];
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: _statusArray];
    [encodedData writeToFile:string atomically:YES];
}

- (NSMutableArray *)loadStatusArray
{
    NSString *string = [self filePathOfStatus];
    NSData* decodedData = [NSData dataWithContentsOfFile: string];
    if (decodedData)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];//NSNumber
    }
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<50; i++)
            [array addObject:[NSNumber numberWithInt:EMPTY]];
        return array;
    }
}



// -----------------------------------------------------------------

@end





