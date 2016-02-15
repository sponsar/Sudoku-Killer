//
//  PlayBoardScene.m
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/9/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "PlayBoardScene.h"
#import "SudokuAlgorithm.h"
#import "Oops.h"
#import "SelectDifficultyScene.h"

#define EMPTY 0
#define CIRCLE 1
#define TICK 2

// -----------------------------------------------------------------

@implementation PlayBoardScene{
    NSMutableArray *_buttonsArray;//记录所有buttons的数组
    CCSprite *_suDoKuBoard;
    CGSize _screenSize;
    SudokuAlgorithm *_algorithm;
    CCLabelTTF *_scoreLabel;
    NSMutableArray *_statusArray;//记录赢了还是待续
    
    char _board[9][9];
    char _originalBoard[9][9];
    BOOL _highLight;
    BOOL _cross;
    int _highLightX;//哪个格子，0123456789
    int _highLightY;
    int _score;
    int _level;
}

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)initWithLevel:(int)level
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    self.userInteractionEnabled = YES;
    
    // class initalization goes here
    //memset(_board, '0', sizeof(_board));
    _highLight = NO;
    _cross = NO;
    _screenSize = [CCDirector sharedDirector].viewSize;
    _algorithm = [[SudokuAlgorithm alloc] init];
    _level = level;
    [self loadBoard];//将数据读进来
    
    // Background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;//CGPoint
    background.contentSize = _screenSize;//这是个CGSize的structure, 320 568
    //background.color = [CCColor whiteColor];
    [self addChild:background];
    
    // LevelLabel
    CCLabelTTF *levelLabel;
    if (_screenSize.width / _screenSize.height < 0.6)//0.56
    {
        levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %i", level] fontName:nil fontSize:10];
        levelLabel.positionType = CCPositionTypeNormalized;
        levelLabel.position = (CGPoint){0.2, 0.82};
    }
    else//0.66
    {
        levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %i", level] fontName:nil fontSize:8];
        levelLabel.positionType = CCPositionTypeNormalized;
        levelLabel.position = (CGPoint){0.2, 0.86};
    }
    levelLabel.color = [CCColor blackColor];
    [self addChild:levelLabel];
    
    // ScoreLabel
    if (_screenSize.width / _screenSize.height < 0.6)//0.56
    {
        _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", _score] fontName:nil fontSize:10];
        _scoreLabel.positionType = CCPositionTypeNormalized;
        _scoreLabel.position = (CGPoint){0.5, 0.82};
    }
    else//0.66
    {
        _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", _score] fontName:nil fontSize:8];
        _scoreLabel.positionType = CCPositionTypeNormalized;
        _scoreLabel.position = (CGPoint){0.5, 0.86};
    }
    _scoreLabel.color = [CCColor blackColor];
    [self addChild:_scoreLabel];
    
    // ResetButton
    CCButton *btnReset;
    if (_screenSize.width / _screenSize.height < 0.6)//0.56
    {
        btnReset = [CCButton buttonWithTitle:@"Reset" fontName:nil fontSize:10];
        btnReset.positionType = CCPositionTypeNormalized;
        btnReset.position = (CGPoint){0.8, 0.82};
    }
    else//0.66
    {
        btnReset = [CCButton buttonWithTitle:@"Reset" fontName:nil fontSize:8];
        btnReset.positionType = CCPositionTypeNormalized;
        btnReset.position = (CGPoint){0.8, 0.86};
    }
    btnReset.color = [CCColor redColor];
    [btnReset setTarget:self selector:@selector(clickResetButton)];
    [self addChild:btnReset];
    
    // Board
    _suDoKuBoard = [CCSprite spriteWithImageNamed:@"board.jpg"];//514 554
    _suDoKuBoard.scale = 0.6;
    _suDoKuBoard.positionType = CCPositionTypeNormalized;
    _suDoKuBoard.position = (CGPoint){0.5, 0.5};
    [self addChild:_suDoKuBoard];
    
    // BackButton
    CCButton *btnBack = [CCButton buttonWithTitle:@"Back" fontName:nil fontSize:20];
    btnBack.positionType = CCPositionTypeNormalized;
    btnBack.position = (CGPoint){0.1, 0.9};
    btnBack.color = [CCColor blackColor];
    [btnBack setTarget:self selector:@selector(clickBackButton)];
    [self addChild:btnBack];
    
    // TipsButton
    CCButton *btnTips = [CCButton buttonWithTitle:@"Tips" fontName:nil fontSize:20];
    btnTips.positionType = CCPositionTypeNormalized;
    btnTips.position = (CGPoint){0.9, 0.9};
    btnTips.color = [CCColor blackColor];
    [btnTips setTarget:self selector:@selector(clickTipsButton)];
    [self addChild:btnTips];
    
    
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
    [self showAllNumbersOnTheBoard];
    return self;
}

- (void)clickBackButton
{
    CCLOG(@"touch back");
    [[CCDirector sharedDirector] presentScene:[[SelectDifficultyScene alloc] init]];
}

- (void)clickTipsButton//for fun
{
    CCLOG(@"touch tips");
    Oops *hintNode = [[Oops alloc] initWithString:@"No kidding! Do it yourself!..."];
    [self addChild:hintNode];
}

- (void)clickResetButton
{
    CCLOG(@"touch reset");
    memcpy(_board, _originalBoard, sizeof(char [9][9]));
    _score = 0;
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %i", _score];
    [self saveWithLevel:_level];
    [self showAllNumbersOnTheBoard];
}

- (void)clickNumberButton:(CCButton *)sender
{
    unsigned long index = [_buttonsArray indexOfObject:sender];
    CCLOG(@"touch button number %lu", index+1);
    
    if (_highLight || _cross)
    {
        if (_highLight)
        {
            _highLight = NO;
            [self unHighLight];
        }
        else
        {
            _cross = NO;
            [self unCross];
        }
        _board[_highLightX][_highLightY] = '1' + index;//将数字写入_board数组
        //先判断这个格子能不能放进这个数字
        if ([_algorithm isValidSudoku:_board] && [_algorithm solvable:_board])
        {
            _score += 1;//加分
            CCSprite *numberImage = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%lu.jpg", index+1]];
            numberImage.name = [NSString stringWithFormat:@"%d%d", _highLightX, _highLightY];//记录下名字，好删除
            numberImage.scale = 0.1;
            numberImage.positionType = CCPositionTypeNormalized;
            numberImage.position = CGPointMake((_highLightX / 9.0 + 1 / 18.0), (_highLightY / 9.0 + 1 / 18.0));
            [_suDoKuBoard addChild:numberImage];
        }
        else
        {
            _board[_highLightX][_highLightY] = '0';
            _cross = YES;
            _score -= 3;//扣分
            CCSprite *crossImage = [CCSprite spriteWithImageNamed:@"cross.png"];
            crossImage.name = @"CrossImage";
            crossImage.scale=0.5;
            crossImage.positionType = CCPositionTypeNormalized;
            crossImage.position = CGPointMake((_highLightX / 9.0 + 1 / 18.0), (_highLightY / 9.0 + 1 / 18.0));
            [_suDoKuBoard addChild:crossImage];
        }
        [self saveWithLevel:_level];
        _scoreLabel.string = [NSString stringWithFormat:@"Score: %i", _score];
        
        if ([self win])//如果赢了
        {
            Oops *hintNode = [[Oops alloc] initWithString:@"Done!"];
            [self addChild:hintNode];
        }
    }
}

- (BOOL)win//判断赢了没
{
    for (int i=0; i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            if (_board[i][j] == '0')
                return NO;
        }
    }
    _statusArray = [self loadStatusArray];
    [self saveStatusArray:_level-1 withStatus:TICK];
    return YES;
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

- (void)unCross
{
    _cross = NO;
    [_suDoKuBoard removeChildByName:@"CrossImage" cleanup:YES];
}

- (void)loadBoard//将数据读入board
{
    NSString *path = [[NSBundle mainBundle] pathForResource: @"sudoku" ofType: @"txt"];
    NSString *sudokuData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [sudokuData componentsSeparatedByString:@"\n"];
    for (int i=0; i<9; i++)
    {
        NSString *line = array[(_level-1)*10+1+i];
        for (int j=0; j<9; j++)
            _originalBoard[i][j] = [line characterAtIndex:j];
    }
    NSData *decodedData = [self loadWithLevel:_level];
    if (decodedData)
    {
        NSLog(@"load: successful");
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];//NSNumber
        for (int i=0; i<9; i++)
        {
            for (int j=0; j<9; j++)
            {
                NSNumber *num = [array objectAtIndex:i*9+j];
                char c = [num charValue];
                _board[i][j] = c;
            }
        }
        _score = [[array lastObject] intValue];
    }
    else
    {
        NSLog(@"new game");
        _score = 0;
        memcpy(_board, _originalBoard, sizeof(char [9][9]));
    }
}

- (NSString *)filePathWithLevel:(int)level
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:[NSString stringWithFormat:@"game_data_%d",level]];
}

- (void)saveWithLevel:(int)level//保存哪一盘
{
    NSString *string = [self filePathWithLevel:level];
    //NSLog(@"save: %@", string);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<9; i++)
        for (int j=0; j<9; j++)
            [array addObject:[NSNumber numberWithChar:_board[i][j]]];
    [array addObject:[NSNumber numberWithInt:_score]];
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: array];
    [encodedData writeToFile:string atomically:YES];
}

- (NSData *)loadWithLevel:(int)level
{
    NSString *string = [self filePathWithLevel:level];
    //NSLog(@"load: %@", string);
    NSData* decodedData = [NSData dataWithContentsOfFile: string];
    return decodedData;
}

- (NSString *)filePathOfStatus//statusArray
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"statusArray"];
}

- (void)saveStatusArray:(int)index withStatus:(int)status
{
    NSNumber *num = [_statusArray objectAtIndex:index];
    if ([num intValue] == TICK) return;//如果已经赢过
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
            if (_cross) [self unCross];
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
        //如果这个格子已经有数字，不能取下
    }
}

// -----------------------------------------------------------------

@end





