//
//  NimGameViewController.h
//  NimGame
//
//  Created by Andreas Obrist on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NimGameViewController : UIViewController {
    UILabel *numOfCoinsLabel;
    UILabel *currentPlayerTakesLabel;
    UIImageView *coinAvers, *coinRevers;
    UIView *coinView;
    NSUInteger numOfCoins;
    NSUInteger coinsTaken;
    NSString *coinAversFilename, *coinReversFilename;
    BOOL humanMove;
    
    AVSpeechSynthesizer *synthesizer;
}

@property (nonatomic, retain) IBOutlet UILabel *numOfCoinsLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentPlayerTakesLabel;
@property (retain, nonatomic) IBOutlet UILabel *currentPlayer;
@property (nonatomic, assign) UIView *coinView;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right_GestureRecognizer;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left_GestureRecognizer;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_up_GestureRecognizer;
@property (retain, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_down_GestureRecognizer;
@property (readwrite) BOOL speechEnabled;

- (IBAction)resetGame:(id)sender;
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;
- (IBAction)playerFinished:(id)sender;
- (void)computerMove;
- (void)updateGame;
- (void)displayMessage:(NSString *)message;
- (void)sweepOffCoin:(UISwipeGestureRecognizerDirection)direction;
- (void)rotateCoinRandomly:(UIImageView *)coinImage;

- (void)announceComputerMove:(int)_coinsTaken;
@end
