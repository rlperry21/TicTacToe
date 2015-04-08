//
//  Game.m
//  TicTac
//
//  Created by Richard Perry on 4/7/15.
//  Copyright (c) 2015 IOS. All rights reserved.
//
//Utilizes a magic sqaure for the game board:
//[8,1,6]
//[3,5,7]
//[4,9,2]
//Used for quick check to win/block with only winning pairs equalling up to 15


#import "Game.h"

@implementation Game
NSMutableArray *board;
NSMutableArray *taken;
NSMutableArray *pairs;
NSMutableArray *cpuTaken;
NSMutableArray *cpuPairs;
NSNumber *firstMove;
NSNumber *secondMove;
int moves;
//The singleton method for the game board
+(Game *)mainGame{
    static Game *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Game alloc] init];
    });
    return _sharedInstance;
}

//Initializes all variables to initial state
-(void) setupGame{
    moves = 0;
    self.cpuWin = NO;
    self.playerWin = NO;
    firstMove = [NSNumber numberWithBool:YES];
    secondMove = [NSNumber numberWithBool:NO];
    board = [[NSMutableArray alloc] initWithCapacity:10];
    taken = [[NSMutableArray alloc] initWithCapacity:10];
    cpuTaken = [[NSMutableArray alloc] initWithCapacity:10];
    pairs = [[NSMutableArray alloc] initWithCapacity:16];
    cpuPairs = [[NSMutableArray alloc] initWithCapacity:16];
    NSNumber *myBool = [NSNumber numberWithBool:NO];
    for (int i = 0; i < 10; i++){
        [board addObject:myBool];
        [taken addObject:myBool];
        [cpuTaken addObject:myBool];
    }
    for (int i = 0; i < 16; i++) {
        [pairs addObject:myBool];
        [cpuPairs addObject:myBool];
    }
}
/**
 *The method that controls player selection
 *@params choice: The players choice on the board
 */
-(void) doPlayerMove:(NSInteger) choice{
    NSNumber *amClicked = [NSNumber numberWithBool:YES];
    [board replaceObjectAtIndex:choice withObject:amClicked];
    //Does the user's choice make a winning combination (15-choice) from the pairs array
    if ([[pairs objectAtIndex:15-choice] boolValue]){
        self.playerWin = YES;
        return;
    }else{
        for (int i = 1; i < 10; i++){
            if ([[taken objectAtIndex:i] boolValue] && i + choice < 15){
                [pairs replaceObjectAtIndex:i + choice withObject:[NSNumber numberWithBool:YES]];
            }
        }
    }
    [taken replaceObjectAtIndex:choice withObject:[NSNumber numberWithBool:YES]];
    [board replaceObjectAtIndex:choice withObject:[NSNumber numberWithBool:YES]];
}
//Method that controls CPU logic
-(NSInteger) doCpuMove{
    NSInteger mySpot = 0;
    //Move to center space if not taken otherwise take corner space
    if (![[board objectAtIndex:5] boolValue] && firstMove.boolValue){
        [board replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
        [cpuTaken replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
        firstMove = [NSNumber numberWithBool:NO];
        secondMove = [NSNumber numberWithBool:YES];
        return 5;
    }else if ([[board objectAtIndex:5] boolValue] == YES && firstMove.boolValue){
        mySpot = [self playCorner];
        firstMove = [NSNumber numberWithBool:NO];
        secondMove = [NSNumber numberWithBool:NO];
        return mySpot;
    }
    //Did I win?
    NSInteger didWin = [self checkForWin];
    if (didWin >= 0){
        self.cpuWin = YES;
        return didWin;
    }
    //Can I block
    NSInteger didBlock = [self checkForBlock];
    if (didBlock >= 0){
        return didBlock;
    }else{
        //If I played center first, select edge place
        if (secondMove.boolValue){
            mySpot = [self playMiddle];
            secondMove = [NSNumber numberWithBool:NO];
            
        }else{ //Select corner if otherwise
            mySpot = [self playCorner];
        }
    }
    return mySpot;
}
/**
 *Attempts to have CPU chose an edge place to play on
 *@warning: If board is tampered with will cause infinite loop
 */
-(NSInteger) playMiddle{
    int choice = -1;
    //Choose an edge piece that can make a win
    if (![[board objectAtIndex:1] boolValue] && ![[taken objectAtIndex:9] boolValue]){
        choice = 1;
    }else if (![[board objectAtIndex:3] boolValue] && ![[taken objectAtIndex:7] boolValue]){
        choice = 3;
    }else if (![[board objectAtIndex:7] boolValue] && ![[taken objectAtIndex:3] boolValue]){
        choice = 7;
    }else if (![[board objectAtIndex:9] boolValue] && ![[taken objectAtIndex:1] boolValue]){
        choice = 9;
    }
    //Any valid corner moves?
    if (choice != -1){
        for (int j = 1; j < 10; j++){
            if ([[cpuTaken objectAtIndex:j] boolValue] && j + choice < 15){
                [cpuPairs replaceObjectAtIndex:j + choice withObject:[NSNumber numberWithBool:YES]];
            }
        }
        [cpuTaken replaceObjectAtIndex:choice withObject:[NSNumber numberWithBool:YES]];
        [board replaceObjectAtIndex:choice withObject:[NSNumber numberWithBool:YES]];
    }else{//Choose corner piece if not
        return [self playCorner];
    }
    return choice;
}

/**
 *Attempts to have CPU chose an corner place to play on
 *@warning: If board is tampered with will cause infinite loop
 */
-(NSInteger) playCorner{
    for (int i = 2; i < 10; i+=2){
        if (![[board objectAtIndex:i] boolValue]){
            for (int j = 1; j < 10; j++){
                if ([[cpuTaken objectAtIndex:j] boolValue]&& j + i < 15){
                    [cpuPairs replaceObjectAtIndex:j + i withObject:[NSNumber numberWithBool:YES]];
                }
            }
            [cpuTaken replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
            [board replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
            return i;
        }
    }
    return [self playMiddle];
}

//Checks to see if a block should be made
-(NSInteger) checkForBlock{
    for (int i = 1; i < 10; i++){
        if (![[board objectAtIndex:i] boolValue]){
            if ([[pairs objectAtIndex:15-i] boolValue]){
                NSLog(@"Blocking at %d", i);
                for (int j = 1; j < 10; j++){
                    if ([[cpuTaken objectAtIndex:j] boolValue] && j + i < 15){
                        [cpuPairs replaceObjectAtIndex:j + i withObject:[NSNumber numberWithBool:YES]];
                    }
                }
                [cpuTaken replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                [board replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                return i;
            }
        }
    }
    return -1;
}

//Checks to see if CPU can win
-(NSInteger) checkForWin{
    for (int i = 1; i < 10; i++){
        if (![[board objectAtIndex:i] boolValue]){
            //Does this board location make a winning combination (15-choice) from its pairs array
            if ([[cpuPairs objectAtIndex:15-i] boolValue]){
                NSLog(@"CPU wins with %d", i);
                for (int j = 1; j < 10; j++){
                    if ([[cpuTaken objectAtIndex:j] boolValue] && j + i < 15){
                        [cpuPairs replaceObjectAtIndex:j + i withObject:[NSNumber numberWithBool:YES]];
                    }
                }
                [cpuTaken replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                [board replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                return i;
            }
        }
    }
    return -1;
}
@end
