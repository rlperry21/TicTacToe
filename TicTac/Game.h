//
//  Game.h
//  TicTac
//
//  Created by Richard Perry on 4/7/15.
//  Copyright (c) 2015 Richard Perry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
+(Game*) mainGame;
-(void) setupGame;
-(void) doPlayerMove:(NSInteger) choice;
-(NSInteger) doCpuMove;
@property (assign, nonatomic) BOOL playerWin;
@property (assign, nonatomic) BOOL cpuWin;
@property (assign, nonatomic) BOOL noWin;
@end
