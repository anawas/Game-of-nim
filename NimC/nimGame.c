#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DIVISOR 4   // This lets the each player choose 1..3 coins
#define YES 1;
#define NO 0;

int movePlayer(void);
int moveComputer(void);
int updateGame(void);

int numOfCoins;
int humanMove = YES;

int main (int argc, char **argv) {
	int coinsTaken = 0;
	int gameOver = NO;
	
	printf("\n**** NIM - SPIEL ****\n");
	srand(time(NULL));
	numOfCoins = (rand() % 15) + 10;
	
	while (!gameOver) {
		printf("Auf dem Tischen liegen %d Münzen\n", numOfCoins);
		gameOver = updateGame();
	}
	
	if (humanMove) {
		printf("!!!!!! SIE HABEN GEWONNEN! !!!!!!\n");	
	} else {
		printf("** DER COMPUTER HAT GEWONNEN **\n");	
	}
	return 0;
}

int movePlayer() {
	int coins;
	
	humanMove = YES;

	do {
		printf("Wieviele nehmen Sie (1, 2, 3)? ");
		scanf("%d", &coins);	
	} while ((coins <= 0) || (coins > DIVISOR));
	return coins;
}

int moveComputer() {
	int coins;
	
	humanMove = NO;
	
	if ((numOfCoins % DIVISOR) == 0) {
		coins = (rand() % (DIVISOR-1)) + 1;  // Computer cannot win anymore --> choose some coins			
	} else {
		coins = numOfCoins % DIVISOR;	
	}
	
	printf("Der Computer nimmt %d\n", coins);
	return coins;
}

int updateGame(void) {
	int coins;
	
	coins = movePlayer();
	numOfCoins = numOfCoins - coins;
	if (numOfCoins == 0) {
		return YES;	
	} 
	coins = moveComputer();
	numOfCoins = numOfCoins - coins;
	if (numOfCoins == 0) {
		return YES;	
	} 
	return NO;
}