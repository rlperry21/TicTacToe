//
//  ViewController.m
//  TicTac
//
//  Created by Richard Perry on 4/6/15.
//  Copyright (c) 2015 Richard Perry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
int moves;
Game *myGame;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self gameOver];
    myGame = [Game mainGame];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gameOver{
    for (int i = 1; i < 10; i++){
        UIButton *myButton = (UIButton*)[self.view viewWithTag:i];
        [myButton setUserInteractionEnabled:NO];
    }
}

- (IBAction)btnChoice:(id)sender {
    UIButton *clicked = sender;
    NSLog(@"User clicked %ld", clicked.tag);
    clicked.userInteractionEnabled = NO;
    [clicked setTitle:@"X" forState:UIControlStateNormal];
    [myGame doPlayerMove:clicked.tag];
    if (myGame.playerWin){
        [self.lblInfo setText:@"Player Wins!"];
        [self gameOver];
    }else
    moves++;
    if (moves == 9){
        [self.lblInfo setText:@"Tie! No Winner"];
        [self gameOver];
    }else{
        NSInteger cpuChose = [myGame doCpuMove];
        if (myGame.cpuWin){
            [self.lblInfo setText:@"CPU Wins!"];
            [self gameOver];
        }
        UIButton *myButton = (UIButton*)[self.view viewWithTag:cpuChose];
        [myButton setTitle:@"O" forState:UIControlStateNormal];
        [myButton setUserInteractionEnabled:NO];
        moves++;
    }
    
}

- (IBAction)btnNewGame:(id)sender {
    [myGame setupGame];
    for (int i = 1; i < 10; i++){
        UIButton *myButton = (UIButton*)[self.view viewWithTag:i];
        [myButton setUserInteractionEnabled:YES];
        [myButton setTitle:@"-" forState:UIControlStateNormal];
    }
    moves = 0;
    [self.lblInfo setText:@""];
}

@end
