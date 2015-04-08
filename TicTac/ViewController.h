//
//  ViewController.h
//  TicTac
//
//  Created by Richard Perry on 4/6/15.
//  Copyright (c) 2015 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ViewController : UIViewController
- (IBAction)btnChoice:(id)sender;

- (IBAction)btnNewGame:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@end

