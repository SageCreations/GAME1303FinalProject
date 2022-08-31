extends Node

# amount of player's currency
var amt_of_currency: int

# number that it's equal to is the last level completed
var current_level: int

# amount of the player's health
var player_health: int

# example of string that will be created and read - "AAAA 0000 00" (no spaces in final ver.)
# first 4 letters "AAAA" will be used for keeping track of level progression
# "0000" is parsed for amount of coins; amount caps at 9999
# "00" is to get the amount of health; caps at 99
var save_string := "AAAA 0000 00"



func _ready():
	FreshData()
	
func FreshData():
	amt_of_currency = 0
	current_level = 0
	player_health = 10



# String Save _____________________________________________________
# function to create the save string based off of current 
# values at time of creating a save
func SetSaveString():
	pass

# function to get the save string
func GetSaveString():
	pass

# function to parse the save string data and set variables
func ParseSaveString():
	pass



# Health ___________________________________________________________
# function to set health to an amount
func SetHealth(var health: int):
	player_health = health

# function that returns player's health value
func GetHealth() -> int:
	return player_health

# function to add health by an amount of type int
func AddHealth(var amount: int):
	player_health += amount

# function to remove health by an amount of type int
func RemoveHealth(var amount: int):
	player_health -= amount

# function to set players default level everytime they restart the level
func StartOfLevelHealth(amount: int):
	player_health = amount






# currency ____________________________________________________________
# function to set the amount of currency
func SetCurrency(currency: int):
	amt_of_currency = currency

# function to add an amount to the exisiting currency
func AddCurrency(amount: int):
	amt_of_currency += amount

# function to get the amount currency currently held
func GetCurrency() -> int:
	return amt_of_currency



# level __________________________________________________________________
# function to set levels completed
func SetLevel(level_completed: int):
	current_level = level_completed

# function to get levels completed
func GetLevel() -> int:
	return current_level
