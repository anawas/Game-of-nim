//
//  NimGameViewController.m
//  NimGame
//
//  Created by Andreas Obrist on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NimGameViewController.h"

#define DIVISOR 4
#define OUTOFSCREEN 400.0F
#define ANIM_SPEED 0.5

@implementation NimGameViewController
@synthesize currentPlayer;
@synthesize swipe_right_GestureRecognizer;
@synthesize swipe_left_GestureRecognizer;
@synthesize swipe_up_GestureRecognizer;
@synthesize swipe_down_GestureRecognizer;
@synthesize numOfCoinsLabel, currentPlayerTakesLabel, coinView;

@synthesize speechEnabled;

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
    [currentPlayer release];
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
    numOfCoins = (rand() % 10) + 10; 
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
        
        [self rotateCoinRandomly:coin];

        coin.tag = i+1;
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
    
    self.currentPlayer.text = @"Sie nehmen";
}

- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    
    if (!humanMove) {
        [self displayMessage:@"Sie sind nicht an der Reihe"];
        return;
    }
    
    if (coinsTaken == 2) {
        [self updateGame];
        return;
    }
    
    [self sweepOffCoin:sender.direction];
    
    self.currentPlayerTakesLabel.text = [[NSNumber numberWithInteger:coinsTaken] stringValue];    
    self.numOfCoinsLabel.text = [[NSNumber numberWithInteger:numOfCoins] stringValue];
    
    if (numOfCoins == 0) {
        [self updateGame];
    }
}

- (IBAction)playerFinished:(id)sender {
    if (coinsTaken == 0) {
        [self displayMessage:@"Sie müssen mind. 1 Münze nehmen."];
        return;
    }
    [self updateGame];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    coinView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    coinAversFilename = [[NSBundle mainBundle]pathForResource:@"coin_avers" ofType:@"png"];
    [coinAversFilename retain];
    coinReversFilename = [[NSBundle mainBundle]pathForResource:@"coin_revers" ofType:@"png"];
    [coinReversFilename retain];
    self.currentPlayer.text = @"Sie nehmen";
    [self resetGame:self];
    humanMove = YES;
    
    // Check if there is a german voice installed
    AVSpeechSynthesisVoice *currVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"de-DE"];
    if (currVoice == nil) {
        self.speechEnabled = NO;
    } else {
        self.speechEnabled = YES;
    }
    
    synthesizer = nil;
    if (self.speechEnabled == YES) {
        synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
}

- (void)viewDidUnload
{
    [self setSwipe_right_GestureRecognizer:nil];
    [self setSwipe_left_GestureRecognizer:nil];
    [self setSwipe_up_GestureRecognizer:nil];
    [self setSwipe_down_GestureRecognizer:nil];
    [self setCurrentPlayer:nil];
    
    [synthesizer release];
    synthesizer = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateGame {
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
    
    if (humanMove) {
        coinsTaken = 0;
        [self computerMove];
        humanMove = YES;
    }
    coinsTaken = 0;
    
}

- (void)computerMove {
    
    int takeCoins;
    
    if ((numOfCoins % DIVISOR) == 0) {
        takeCoins = (random() % (DIVISOR-1)) + 1;
        if (takeCoins == 0) {
            NSLog(@"coinsTaken == 0 !!!!!!");
        }
    } else {
        takeCoins = numOfCoins % DIVISOR;
    } 
    
    if (self.speechEnabled == YES) {
        [self announceComputerMove:takeCoins];
    }

    humanMove = NO;
    while (takeCoins > 0) {
        [self sweepOffCoin:(1 << rand()%(DIVISOR -1))];
        takeCoins--;
    }
                            
    [self updateGame];
}


- (void)displayMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:nil                                              
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)sweepOffCoin:(UISwipeGestureRecognizerDirection)direction {

    CGRect viewFrame = self.view.frame;
    
    if (humanMove) {
        self.currentPlayer.text = @"Sie nehmen";
    } else {
        self.currentPlayer.text = @"iPod nimmt";
    }
    NSArray *coinSubviews = [coinView subviews];
    //direction = 1;
    switch(direction) {
        case UISwipeGestureRecognizerDirectionRight:
            for (UIImageView *coin in coinSubviews) {
                if (coin.tag == numOfCoins) {
                    [UIImageView animateWithDuration:ANIM_SPEED 
                                          animations:^{
                                              coin.center = CGPointMake(OUTOFSCREEN, viewFrame.size.height/2);}
                                          completion:^(BOOL finished){[coin removeFromSuperview];}];
                    break;
                }
            }
            
            break;
        case  UISwipeGestureRecognizerDirectionLeft:
            for (UIImageView *coin in coinSubviews) {
                if (coin.tag == numOfCoins) {
                    [UIImageView animateWithDuration:ANIM_SPEED 
                                          animations:^{
                                              coin.center = CGPointMake(-OUTOFSCREEN, viewFrame.size.height/2);}
                                          completion:^(BOOL finished){[coin removeFromSuperview];}];
                    break;
                }
            }
            break;
        case UISwipeGestureRecognizerDirectionUp:
            for (UIImageView *coin in coinSubviews) {
                if (coin.tag == numOfCoins) {
                    [UIImageView animateWithDuration:ANIM_SPEED 
                                          animations:^{
                                              coin.center = CGPointMake(viewFrame.size.width/2, -OUTOFSCREEN);}
                                          completion:^(BOOL finished){[coin removeFromSuperview];}];
                    break;
                }
            }
            break;
        case UISwipeGestureRecognizerDirectionDown:
            for (UIImageView *coin in coinSubviews) {
                if (coin.tag == numOfCoins) {
                    [UIImageView animateWithDuration:ANIM_SPEED 
                                          animations:^{
                                              coin.center = CGPointMake(viewFrame.size.width/2, 3*OUTOFSCREEN);}
                                          completion:^(BOOL finished){[coin removeFromSuperview];}];
                    break;
                }
            }
            break;
    }
    
    ++coinsTaken;
    self.currentPlayerTakesLabel.text = [[NSNumber numberWithInteger:coinsTaken] stringValue];

    --numOfCoins;
}

- (void)rotateCoinRandomly:(UIImageView *)coinImage {
    float angle;
    CGAffineTransform _transform;
    
    _transform = CGAffineTransformIdentity;
    angle = rand()%360;
    angle *= 0.018;
    _transform.a = sinf(angle);
    _transform.b = cosf(angle);
    _transform.c = -_transform.b;
    _transform.d = _transform.a;
    coinImage.transform = _transform;
}

#pragma mark -
#pragma mark Speech output
- (void)announceComputerMove:(int)_coinsTaken {
    
    NSString *message;
    
    if (_coinsTaken == 1) {
        message = @"Ich nehme eine Münze.";
    } else {
        message = [[NSString alloc] initWithFormat:@"Ich nehme %d Münzen.", _coinsTaken];
    }
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:message];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"de-DE"];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate - 0.3;
    [synthesizer speakUtterance:utterance];
    [utterance release];
    [message release];
}


@end
