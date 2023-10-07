import random
logo = ''' 
 _                                             
| |                                            
| |__   __ _ _ __   __ _ _ __ ___   __ _ _ __  
| '_ \ / _` | '_ \ / _` | '_ ` _ \ / _` | '_ \ 
| | | | (_| | | | | (_| | | | | | | (_| | | | |
|_| |_|\__,_|_| |_|\__, |_| |_| |_|\__,_|_| |_|
                    __/ |                      
                   |___/    '''
print(logo)
stages = ['''
  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
=========
''', '''
  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========
''', '''
  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========
''', '''
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========''', '''
  +---+
  |   |
  O   |
  |   |
      |
      |
=========
''', '''
  +---+
  |   |
  O   |
      |
      |
      |
=========
''', '''
  +---+
  |   |
      |
      |
      |
      |
=========
''']
print("Welcome to hangman")
print("There are these four words in the list: aadvark, pineapple, jackfruit, and rambutan")
print("You have to guess which word has been chosen by computer")
print("Play carefully as you will only have 6 lives")
word_list = ['aadvark',"pineapple","jackfruit","rambutan"]
choosen_word = random.choice(word_list)


display=[]
for i in choosen_word:
    display.append("_")



for i in range(len(choosen_word)):
    lives = 6
    while display[i] == "_":
        guess = input("guess a leter\n").lower()
        if guess in display:
            print("You have already chosen this word")
            lives = lives -1
            print(f"You have {lives} lives left")
            print(stages[lives])
        for i in range(len(choosen_word)):
            if choosen_word[i] == guess:
                display[i]= guess
        print(display)
        if guess not in choosen_word:
            lives = lives -1
            print(f"You have {lives} lives left")
            print(stages[lives])
        if lives == 0:
            break
    if lives == 0:
        print("So Sorry you lost")
        break
if "_" not in display:
    print("Congratulations you have won the game")

            
            

    