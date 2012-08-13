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
    UILabel *computerTakesLabel;
    
    IBOutlet UISegmentedControl *playerTakesControl;
    
    NSUInteger numOfCoins;
    NSUInteger coinsTaken;
    BOOL humanMove;
}

@property (nonatomic, retain) IBOutlet UILabel *numOfCoinsLabel;
@property (nonatomic, retain) IBOutlet UILabel *computerTakesLabel;

- (IBAction)playerSelectedCoins:(id)sender;
- (IBAction)resetGame:(id)sender;

- (void)computerMove;
- (void)updateGame;
@end
