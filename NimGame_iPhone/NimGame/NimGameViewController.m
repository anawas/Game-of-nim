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
@synthesize swipe_right_GestureRecognizer;
@synthesize swipe_left_GestureRecognizer;
@synthesize swipe_up_GestureRecognizer;
@synthesize swipe_down_GestureRecognizer;

@synthesize numOfCoinsLabel, currentPlayerTakesLabel, coinView;

- (void)dealloc
{
    numOfCoinsLabel = nil;
    currentPlayerTakesLabel = nil;
    [coinReversFilename release];
    [coinAversFilename release];
    [swipe_right_GestureRecognizer release];
    [swipe_left_GestureRecognizer release];
    [swipe_up_GestureRecognizer release];
    [swipe_down_GestureRecognizer release];
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
    self.currentPlayerTakesLabel.text = @"0";
    

    [coinView retain];
    NSArray *coinSubviewArray = [coinView subviews];
    for (int i = 0; i < [coinSubviewArray count]; i++) {
        [[coinSubviewArray objectAtIndex:i] removeFromSuperview];
    }
    [coinView removeFromSuperview];
    
    CGRect viewFrame = [[self view] frame];
    
    for (int i = 0; i < numOfCoins; i++) {
        UIImageView *coin;
        if (rand() % 2) {
            coin = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:coinAversFilename]];
        } else {
            coin = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:coinReversFilename]];        
        }
        coin.tag = i;
        CGRect coinSize = [coin frame];
        CGPoint ulc = CGPointMake(viewFrame.size.width/2 + rand()%100, viewFrame.size.height/2+rand()%100);
        
        ulc.x -= coinSize.size.width/2.0f;
        ulc.y -= coinSize.size.height/2.0f;
        [coin setCenter:ulc];
        [coinView addSubview:coin];
        [coin release];
    }
    [[self view] addSubview:coinView];
    [coinView release];

}

- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    NSString *message;
    
    switch(sender.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            message = @"Swiped right";
            break;
        case  UISwipeGestureRecognizerDirectionLeft:
            message = @"Swiped left";
            break;
        case UISwipeGestureRecognizerDirectionUp:
            message = @"Swiped up";
            break;
        case UISwipeGestureRecognizerDirectionDown:
            message = @"Swiped down";
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gesture"
                                                    message:message
                                                   delegate:nil                                              
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];


}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    coinView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 200, 200)];
    coinAversFilename = [[NSBundle mainBundle]pathForResource:@"coin_avers" ofType:@"png"];
    [coinAversFilename retain];
    coinReversFilename = [[NSBundle mainBundle]pathForResource:@"coin_revers" ofType:@"png"];
    [coinReversFilename retain];
    [self resetGame:self];    
}

- (void)viewDidUnload
{
    [self setSwipe_right_GestureRecognizer:nil];
    [self setSwipe_left_GestureRecognizer:nil];
    [self setSwipe_up_GestureRecognizer:nil];
    [self setSwipe_down_GestureRecognizer:nil];
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
    
    self.currentPlayerTakesLabel.text = [NSString stringWithFormat:@"%d", coinsTaken];
    humanMove = NO;
    [self updateGame];
}

@end
