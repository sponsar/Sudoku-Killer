//
//  SudokuAlgorithm.m
//
//  Created by : 黄 信尧
//  Project    : Sudoku
//  Date       : 2/5/16
//
//  Copyright (c) 2016 黄 信尧.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "SudokuAlgorithm.h"

// -----------------------------------------------------------------
@implementation SudokuAlgorithm{
    char _table[9][9];
    NSMutableArray *_stack;
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
    return self;
}

- (BOOL)checkPosition:(Position *)position character:(char)c
{
    int row = position.row;
    int col = position.col;
    //先判断行列
    for(int i=0;i<9;i++)
    {
        if((_table[i][col]==c && i!=row)|| (_table[row][i]==c && i!=col))
            return NO;
    }
    //再判断格子
    int grid_row=(row/3)*3;
    int grid_col=(col/3)*3;
    for(int i=0;i<3;i++)
    {
        for(int j=0;j<3;j++)
        {
            if(_table[grid_row+i][grid_col+j]==c && (grid_row+i!=row || grid_col+j!=col))
                return NO;
        }
    }
    return YES;
}

- (BOOL)isValidSudoku:(char [9][9])board
{
    memcpy(_table, board, sizeof(char [9][9]));
    for(int i=0;i<9;i++)
    {
        for(int j=0;j<9;j++)
        {
            Position *pos = [[Position alloc]initWithRow:i andCol:j];
            if(_table[i][j]!='0')//暴力破解
            {
                if(![self checkPosition:pos character:_table[i][j]])
                    return NO;
            }
        }
    }
    return YES;
}

//DFS
- (BOOL)place
{
    if([_stack count] == 0) return YES;
    
    Position *currentPosition =_stack.lastObject;
    [_stack removeLastObject];
    
    //如果下一步都对的话，return true
    for(int i=0;i<9;i++)
    {
        if ([self checkPosition:currentPosition character:'1'+i])
        {
            //先放进去
            _table[currentPosition.row][currentPosition.col]='1'+i;
            //看看下一步对不对了
            if ([self place])
            {
                //下面这段是为了测存不存在其他答案
                if (!_atLeastTwoSolutions)
                {
                    for (int j = i+1; j < 9; j++)
                    {
                        _table[currentPosition.row][currentPosition.col]='1'+j;
                        //需要新建一个对象，否则把table复制给自己就麻烦了
                        SudokuAlgorithm *IsThereAnotherSolution = [[SudokuAlgorithm alloc] init];
                        if ([IsThereAnotherSolution solveSudoku:_table])
                        {
                            _atLeastTwoSolutions = YES;
                            break;
                        }
                    }
                    _table[currentPosition.row][currentPosition.col]='1'+i;
                }
                return YES;
            }
        }
    }
    _table[currentPosition.row][currentPosition.col]='0';
    [_stack addObject:currentPosition];
    return NO;//剩下的空格放什么都不能满足!
}

//要考虑不能解的情况
- (BOOL)solveSudoku:(char [9][9])board//需要改变参数
{
    if (!_stack) _stack = [[NSMutableArray alloc] init];//lazy initialization
    memcpy(_table, board, sizeof(char [9][9]));
    _atLeastTwoSolutions = NO;
    for(int i=0;i<9;i++)
    {
        for(int j=0;j<9;j++)
        {
            if(_table[i][j]=='0')//搜索所有的空格子，把位置记录下来
            {
                Position *pos = [[Position alloc] initWithRow:i andCol:j];
                [_stack addObject:pos];
            }
        }
    }
    if ([self place])
    {
        //在这里_stack已经是空的
        memcpy(board, _table, sizeof(char [9][9]));
        return YES;
    }
    else
    {
        [_stack removeAllObjects];
        return NO;
    }
}
- (BOOL)solvable:(char [9][9])board//不要改变参数
{
    if (!_stack) _stack = [[NSMutableArray alloc] init];//lazy initialization
    memcpy(_table, board, sizeof(char [9][9]));
    _atLeastTwoSolutions = NO;
    for(int i=0;i<9;i++)
    {
        for(int j=0;j<9;j++)
        {
            if(_table[i][j]=='0')//搜索所有的空格子，把位置记录下来
            {
                Position *pos = [[Position alloc] initWithRow:i andCol:j];
                [_stack addObject:pos];
            }
        }
    }
    if ([self place]) return YES;
    else
    {
        [_stack removeAllObjects];
        return NO;
    }
}

// -----------------------------------------------------------------

@end





