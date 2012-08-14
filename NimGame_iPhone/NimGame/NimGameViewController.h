//
//  NimGameViewController.h
//  NimGame
//
//  Created by Andreas Obrist on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NimGameViewController : UIViewController {
    UILabel *numOfCoinsLabel;
    UILabel *currentPlayerTakesLabel;
    UIImageView *coinAvers, *coinRevers;
    UIView *coinView;
    NSUInteger numOfCoins;
    NSUInteger coinsTaken;
    NSString *coinAversFilename, *coinReversFilename;
    BOOL humanMove;
}

@property (nonatomic, retain) IBOutlet UILabel *numOfCoinsLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentPlayerTakesLabel;
@property (nonatomic, assign) UIView *coinView;

- (IBAction)playerSelectedCoins:(id)sender;
- (IBAction)resetGame:(id)sender;

- (void)computerMove;
- (void)updateGame;
@end
