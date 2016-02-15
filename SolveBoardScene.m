//
//  SolveBoardScene.m
//
//  Created by : 黄 信尧
//  Project    : SudokuByYao
//  Date       : 2/3/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "SolveBoardScene.h"
#import "SudokuAlgorithm.h"
#import "Oops.h"
@interface SolveBoardScene()

@end
// -----------------------------------------------------------------

@implementation SolveBoardScene{
    NSMutableArray *_buttonsArray;//记录所有buttons的数组
    CCSprite *_suDoKuBoard;
    CGSize _screenSize;
    SudokuAlgorithm *_algorithm;
    
    char _board[9][9];
    BOOL _highLight;
    int _highLightX;//哪个格子，0123456789
    int _highLightY;
}

// -----------------------------------------------------------------

+ (instancetype)node//不知道干啥用的
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    self.userInteractionEnabled = YES;

    // class initalization goes here
    memset(_board, '0', sizeof(_board));
    _highLight = NO;
    _screenSize = [CCDirector sharedDirector].viewSize;//iphone5,6是320，568 iphone4是320 480
    _algorithm = [[SudokuAlgorithm alloc] init];
    
    // Background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;//CGPoint
    background.contentSize = _screenSize;//这是个CGSize的structure, 320 568
    //background.color = [CCColor whiteColor];
    [self addChild:background];
    
    // Board
    _suDoKuBoard = [CCSprite spriteWithImageNamed:@"board.jpg"];//514 554
    _suDoKuBoard.scale = 0.6;
    _suDoKuBoard.positionType = CCPositionTypeNormalized;
    _suDoKuBoard.position = (CGPoint){0.5, 0.5};
    [self addChild:_suDoKuBoard];
    
    // HomeButton
    CCButton *btnHome = [CCButton buttonWithTitle:@"Home" fontName:nil fontSize:20];
    btnHome.positionType = CCPositionTypeNormalized;
    btnHome.position = (CGPoint){0.1, 0.9};
    btnHome.color = [CCColor blackColor];
    [btnHome setTarget:self selector:@selector(clickHomeButton)];
    [self addChild:btnHome];
    
    // FixButton
    CCButton *btnFix = [CCButton buttonWithTitle:@"Fix" fontName:nil fontSize:20];
    btnFix.positionType = CCPositionTypeNormalized;
    btnFix.position = (CGPoint){0.9, 0.9};
    btnFix.color = [CCColor blackColor];
    [btnFix setTarget:self selector:@selector(clickFixButton)];
    [self addChild:btnFix];
    
    // ResetButton
    CCButton *btnReset;
    if (_screenSize.width / _screenSize.height < 0.6)//0.56
    {
        btnReset = [CCButton buttonWithTitle:@"Reset" fontName:nil fontSize:10];
        btnReset.positionType = CCPositionTypeNormalized;
        btnReset.position = (CGPoint){0.5, 0.82};
    }
    else//0.66
    {
        btnReset = [CCButton buttonWithTitle:@"Reset" fontName:nil fontSize:8];
        btnReset.positionType = CCPositionTypeNormalized;
        btnReset.position = (CGPoint){0.5, 0.86};
    }
    btnReset.color = [CCColor blackColor];
    [btnReset setTarget:self selector:@selector(clickResetButton)];
    [self addChild:btnReset];

    // NumberButtons
    if (!_buttonsArray) _buttonsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<9; i++)
    {
        NSString *btnName = [NSString stringWithFormat:@"%d.jpg", i+1];
        CCButton *btn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:btnName]];
        btn.positionType = CCPositionTypeNormalized;
        double w,h;
        //CCLOG(@"width: %f, height: %f", _screenSize.width, _screenSize.height);
        if (_screenSize.width / _screenSize.height < 0.6)//0.56
        {
            btn.scale = 0.1;
            w = 0.06 + 0.11 * i;
            h = ( i & 1 ) ? 0.07 : 0.16;
        }
        else//0.66
        {
            btn.scale = 0.08;
            w = 0.06 + 0.11 * i;
            h = ( i & 1 ) ? 0.07 : 0.1;
        }
        btn.position = (CGPoint){w, h};
        [btn setTarget:self selector:@selector(clickNumberButton:)];
        [_buttonsArray addObject:btn];
        [self addChild:btn];
    }
    return self;
}

- (void)clickHomeButton
{
    CCLOG(@"touch home");
    [[CCDirector sharedDirector] popToRootScene];
}

- (void)clickFixButton
{
    CCLOG(@"touch fix");
    
    if (_highLight) [self unHighLight];
    //1 冲突,加一个提示窗口
    if ( ![_algorithm isValidSudoku:_board])//
    {
        Oops *hintNode = [[Oops alloc] initWithString:@"Oops...The numbers you provide conflict with each other!"];
        [self addChild:hintNode];
    }
    else if ([_algorithm solveSudoku:_board])//有解
    {
        [self showAllNumbersOnTheBoard];
        if (_algorithm.atLeastTwoSolutions)
            CCLOG(@"At least two solutions!!!!!!!!!!!!!!!!!!!!!!!");
        /*
        Oops *hintNode = [[Oops alloc] initWithString:@"At least two solutions for your Sudoku!"];
        [self addChild:hintNode];
         */
    }
    else//没解
    {
        Oops *hintNode = [[Oops alloc] initWithString:@"Oops...This is unsolvable!"];
        [self addChild:hintNode];
    }
}

- (void)clickResetButton
{
    CCLOG(@"touch reset");
    _highLight = NO;
    memset(_board, '0', sizeof(_board));
    [_suDoKuBoard removeAllChildrenWithCleanup:YES];
}

- (void)clickNumberButton:(CCButton *)sender
{
    unsigned long index = [_buttonsArray indexOfObject:sender];
    CCLOG(@"touch button number %lu", index+1);
    
    if (_highLight)
    {
        _highLight = NO;
        [self unHighLight];
        
        _board[_highLightX][_highLightY] = '1' + index;//将数字写入_board数组
        
        CCSprite *numberImage = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%lu.jpg", index+1]];
        numberImage.name = [NSString stringWithFormat:@"%d%d", _highLightX, _highLightY];//记录下名字，好删除
        numberImage.scale = 0.1;
        numberImage.positionType = CCPositionTypeNormalized;
        numberImage.position = CGPointMake((_highLightX / 9.0 + 1 / 18.0), (_highLightY / 9.0 + 1 / 18.0));
        [_suDoKuBoard addChild:numberImage];
    }
}

- (void)highLightX:(int)x andY:(int)y
{
    _highLight = YES;
    _highLightX = x;
    _highLightY = y;
    CCSprite *highLightImage =[CCSprite spriteWithImageNamed:@"QuestionMark.jpg"];
    highLightImage.name = @"QuestionMarkImage";
    highLightImage.scale=0.09;
    highLightImage.positionType = CCPositionTypeNormalized;
    highLightImage.position = CGPointMake((x / 9.0 + 1 / 18.0), (y / 9.0 + 1 / 18.0));
    [_suDoKuBoard addChild:highLightImage];
}

- (void)unHighLight
{
    _highLight = NO;
    [_suDoKuBoard removeChildByName:@"QuestionMarkImage" cleanup:YES];
}

- (void)showAllNumbersOnTheBoard
{
    [_suDoKuBoard removeAllChildrenWithCleanup:YES];
    
    for (int i = 0; i < 9; i++)
    {
        for (int j = 0; j < 9; j++)
        {
            if (_board[i][j] != '0')
            {
                CCSprite * numberImage = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%d.jpg", _board[i][j] - '0']];
                numberImage.name = [NSString stringWithFormat:@"%d%d", i, j];
                numberImage.scale = 0.1;
                numberImage.positionType = CCPositionTypeNormalized;
                numberImage.position = CGPointMake((i / 9.0 + 1 / 18.0), (j / 9.0 + 1 / 18.0));
                [_suDoKuBoard addChild:numberImage];
            }
        }
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event//这个方法属于父类，override这个方法
{
    CGPoint point = [touch locationInNode:_suDoKuBoard];//点击的"相对"位置
    //判断是不是在棋盘内
    if (point.x >0 && point.y >0 && point.x < _suDoKuBoard.contentSize.width && point.y < _suDoKuBoard.contentSize.height)
    {
        int x = 9 * point.x / _suDoKuBoard.contentSize.width;//先判断在哪一个格子（0,0）代表左下方
        int y = 9 * point.y / _suDoKuBoard.contentSize.height;
        
        //如果这个格子没有填数字
        if (_board[x][y] == '0')
        {
            //如果没有highlight
            if (!_highLight) [self highLightX:x andY:y];
            
            //取消highlight的格子
            else if (x == _highLightX && y == _highLightY) [self unHighLight];
            
            //highlight另一个格子
            else
            {
                [self unHighLight];
                [self highLightX:x andY:y];
            }
        }
        
        //如果这个格子已经有数字，取下来
        else
        {
            _board[x][y] = '0';
            [_suDoKuBoard removeChildByName:[NSString stringWithFormat:@"%d%d", x, y] cleanup:YES];
        }
    }
}

// -----------------------------------------------------------------

@end





