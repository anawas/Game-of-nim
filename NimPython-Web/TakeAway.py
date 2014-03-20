#!/usr/bin/env python
# encoding: utf-8
"""
TakeAway.py

Simple implemenation of the Nim game. It is inteded to be released
as a web app using Google App Server.

Created by Andreas Wassmer on 2014-03-20.
Copyright (c) 2014 __MyCompanyName__. All rights reserved.
"""

import sys
import numpy

MAXCOINS = 21
MAXCOINSMOVE = 3

gameOver = False

"""
This class handles the interaction with the player
"""
class Player:
	def init(self):
		coinsTaken = 0
		
	def takeCoins(self):
		print("Wieveiele BitCoins (1 - 3) wollen Sie nehmen? ")
		self.key = input()
		if self.checkMove(self.key.__int__()) == False:
			print("ERROR")
		
	
	def checkMove(self, coins):
		if self.key.__int__() > 3:
			print("Sie können maximal " + MAXCOINSMOVE.__str__() + " BitCoins nehmen.")
			return False

		if self.key.__int__() <= 0:
			print("Sie müssen mindestens 1 BitCoin nehmen.")
			return False
		
		return True
		
		
"""
This class contains the game logic for the computer
"""		
class Computer:
	def init(self):
		coinsTaken = 0;
		
class Table:
	def init(self):
		self.player = Player()
		self.computer = Computer()
		self.coinsOnTable = numpy.random.randint(4, MAXCOINS)

	def printCoins(self):
		print("Auf dem Tisch liegen " + self.coinsOnTable.__str__() + " BitCoins")
		
	def play(self):
		self.player.takeCoins();
		
		
def main():
	gameboard = Table()
	gameboard.init()
	gameboard.printCoins()
	gameboard.play()
	

if __name__ == '__main__':
   main()

