//
//  NimGameViewController.m
//  NimGame
//
//  Created by Andreas Obrist on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NimGameViewController.h"

#define DIVISOR 4

@implementation NimGameViewController

@synthesize numOfCoinsLabel, computerTakesLabel;

- (void)dealloc
{
    numOfCoinsLabel = nil;
    computerTakesLabel = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)resetGame:(id)sender {
    srandom(time(NULL));
    coinsTaken = 0;
    numOfCoins = (rand() % 15) + 10; 
    self.numOfCoinsLabel.text = [NSString stringWithFormat:@"%d", numOfCoins];
    self.computerTakesLabel.text = @"0";
    playerTakesControl.enabled = YES;

}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [playerTakesControl addTarget:self
                           action:@selector(playerSelectedCoins:) 
                 forControlEvents:UIControlEventValueChanged];
    [playerTakesControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self resetGame:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)playerSelectedCoins:(id)sender {
    coinsTaken = [sender selectedSegmentIndex]+1;
    humanMove = YES;
    [self updateGame];
}

- (void)updateGame {
    numOfCoins = numOfCoins - coinsTaken;
    self.numOfCoinsLabel.text = [NSString stringWithFormat:@"%d", numOfCoins];
    if (numOfCoins == 0) {
        NSString *winner;
        if (humanMove) {  
            winner = @"Sie gewinnen";
        } else {
            winner = @"iPod gewinnt";
        }
        
        playerTakesControl.enabled = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Spielende"
                                                        message:[NSString stringWithFormat:@"%@ das Spiel!", winner]
                                                       delegate:nil                                              
                                               cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];        
        return;
    }

    if (humanMove)
        [self computerMove];
    
}

- (void)computerMove {
    
    if ((numOfCoins % DIVISOR) == 0) {
        coinsTaken = (random() % (DIVISOR-1)) + 1;
        if (coinsTaken == 0) {
            NSLog(@"coinsTaken == 0 !!!!!!");
        }
    } else {
        coinsTaken = numOfCoins % DIVISOR;
    } 
    
    self.computerTakesLabel.text = [NSString stringWithFormat:@"%d", coinsTaken];
    humanMove = NO;
    [self updateGame];
}

@end
