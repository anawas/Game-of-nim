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

/**
 ** Die App wurde beendet. Nun müssen wir aufräumen.
 **/
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

/**
 ** Das Betriebssystem meldet uns, dass nur noch wenig Speicher zu Verfügung
 ** steht und bittet uns aufzuräumen. Da können wir aber nichts tun.
 **/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

/**
 ** Damit setzen wir das Spiel zurück. Wir verteilen die Münzen neu und löschen
 ** den Speilstand.
 ** Diese Methode kann immer aufgerufen werden. Wir könnten uns überlegen, ob 
 ** wir das Zurücksetzen nur am Spielende gestatten wollen.  
 **/
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
        
        /** 
         ** Schön wäre, wenn die Münze zwei Seiten hätte...
         **/
        coin = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:coinAversFilename]];

        coin.tag = i+1;
        CGRect coinSize = [coin frame];
        CGPoint ulc = CGPointMake(viewFrame.size.width/2 + rand()%100, viewFrame.size.height/2+rand()%100);

        /** 
         ** Etwas weniger Ordnung im Stapel bitte...
         **/

        ulc.x -= coinSize.size.width/2.0f;
        ulc.y -= coinSize.size.height/2.0f;
        [coin setCenter:ulc];
        [coinView addSubview:coin];
        [coin release];
    }
    [[self view] addSubview:coinView];
    [coinView release];
    
    self.currentPlayer.text = [NSString stringWithString:@"Sie nehmen"];
}

/**
 ** Reagiert, wenn der Spieler das Display berührt. Sucht eine Swipe-Bewegung
 ** (ein Wischen) und bestimmt die Richtung.
 **/
- (IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    
    if (!humanMove) {
        [self displayMessage:@"Sie sind nicht an der Reihe"];
        return;
    }
    
    /**
     ** Was, wenn der Spieler mehr als 3 Münzen nimmt?
     **/
    
    [self sweepOffCoin:sender.direction];
    
    self.currentPlayerTakesLabel.text = [[NSNumber numberWithInteger:coinsTaken] stringValue];    
    self.numOfCoinsLabel.text = [[NSNumber numberWithInteger:numOfCoins] stringValue];
    
    /**
     ** Wenn der Spieler die letzte Münze nimmt soll das Spiel zu Ende sein.
     **/
}

#pragma mark - View lifecycle

/**
 ** Aufgerufen, wenn die App geladen wurde.
 ** Hier müssen noch die Münzen dargestellt werden...
 **/
 - (void)viewDidLoad
{
    [super viewDidLoad];
    
    coinView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    coinAversFilename = [[NSBundle mainBundle]pathForResource:@"coin_avers" ofType:@"png"];
    [coinAversFilename retain];
    coinReversFilename = [[NSBundle mainBundle]pathForResource:@"coin_revers" ofType:@"png"];
    [coinReversFilename retain];
    self.currentPlayer.text = @"Sie nehmen";

    humanMove = YES;
}

/**
 ** Wird aufgerufen, wenn die App beendet wird. Wir müssen alles löschen
 ** was wir zuvor definiert haben.
 **/
- (void)viewDidUnload
{
    [self setSwipe_right_GestureRecognizer:nil];
    [self setSwipe_left_GestureRecognizer:nil];
    [self setSwipe_up_GestureRecognizer:nil];
    [self setSwipe_down_GestureRecognizer:nil];
    [self setCurrentPlayer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/**
 ** Die Anzeige unseres Spiels unterstützt nur den Portrait-Modus. Daher unterbinden
 ** wir das Drehen des Displays.
 **/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 ** Diese Methode wird nach jedem Zug vom Spieler oder Computer aufgerufen.
 ** Sie prüft, ob schon jemand gewonnen hat und falls ja, gibt den Sieger aus.
 ** Sie macht den Zug für den Computer falls der Mensch soeben gespielt hat.
 **/
- (void)updateGame {
    self.numOfCoinsLabel.text = [NSString stringWithFormat:@"%d", numOfCoins];
    
    // Hat schon jemand gewonnen?
    if (numOfCoins == 0) {
        
        // ja, wer ist es?
        NSString *winner;
        if (humanMove) {  
            winner = @"Sie gewinnen";
        } else {
            winner = @"iPod gewinnt";
        }
        
        // Den Gewinner ausgeben.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Spielende"
                                                        message:[NSString stringWithFormat:@"%@ das Spiel!", winner]
                                                       delegate:nil                                              
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // nein, es gibt noch keinen Sieger
    
    // Hat der Mensch den letzten Zug gemacht?
    if (humanMove) {
        
        // ja, jetzt ist der Computer dran
        coinsTaken = 0;
        [self computerMove];
        humanMove = YES;
    }
    coinsTaken = 0;
    
}


/**
 ** Nun ist der Computer an der Reihe. Was muss er tun??
 **/
- (void)computerMove {
    // was tun???
}


/**
 ** Gibt eine Fehlermeldung auf dem Display aus.
 **/
- (void)displayMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:nil                                              
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

/**
 ** Diese Methode sieht kompliziert aus. Sie wird einerseits aufgerufen, wenn 
 ** der Spieler über das Display streicht. Aber auch, um das Wegnehmen beim
 ** Computerzug zu simulieren.
 ** In der Methode wird die oberste Münze aus dem Bild bewegt
 ** und zwar in die Richtung, in welche der Spieler gewischt hat. 
 **/
- (void)sweepOffCoin:(UISwipeGestureRecognizerDirection)direction {

    CGRect viewFrame = self.view.frame;
    
    if (humanMove) {
        self.currentPlayer.text = [NSString stringWithString:@"Sie nehmen"];
    } else {
        self.currentPlayer.text = [NSString stringWithString:@"iPod nimmt"];
    }
    
    // Hole den Münzstapel
    NSArray *coinSubviews = [coinView subviews];

    
    // In welche Richtung wurde gewischt?
    switch(direction) {
            
            // nach rechts
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
            
            // nach links
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
            
            // nach oben
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
            
            // nach unten
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
    
    // aktualisiere die Anzahl Münzen
    ++coinsTaken;
    self.currentPlayerTakesLabel.text = [[NSNumber numberWithInteger:coinsTaken] stringValue];

    --numOfCoins;
}

/**
 ** Um dem Spiel ein realistischeres Aussehen zu geben drehen wir die Bilder der
 ** Münzen im einen zufälligen Winkel.
 **/
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

@end
