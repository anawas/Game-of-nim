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
@property (retain, nonatomic) IBOutlet UILabel *currentPlayer;
@property (nonatomic, assign) UIView *coinView;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right_GestureRecognizer;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left_GestureRecognizer;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_up_GestureRecognizer;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_down_GestureRecognizer;

- (IBAction)resetGame:(id)sender;
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;
- (void)computerMove;
- (void)updateGame;
- (void)displayMessage:(NSString *)message;
- (void)sweepOffCoin:(UISwipeGestureRecognizerDirection)direction;

- (void)rotateCoinRandomly:(UIImageView *)coinImage;
@end
