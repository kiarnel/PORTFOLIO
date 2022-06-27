import random 
import tkinter as tk
from tkinter import  Button, Label, messagebox as mb



GameScreen = tk.Tk()
GameScreen.title('영단어 맞추기게임')
GameScreen.geometry('400x600')

words = ['shuffle', 'candidate', 'terminate', 'python', 'append', 'vulnerable','profitable','precarious','negligible','corollary']
random.shuffle(words)

def click_btn2():
    user_ans=inp.get()

    if(user_ans == word ):
        mb.showinfo(title='결과',message='정 답')
        lambada=click_btn1()
        
    else:
        mb.showinfo(title='결과',message='떙!!!!!!')
def click_btn1():
    global word
    
    for word in words:
        word=random.choice(words)
        characters = list(word)  
        random.shuffle(characters)
        shuffled_word = ''.join(characters)
        computer_choice = shuffled_word
        label2["text"] = computer_choice
        label2.update



label1=tk.Label(master= GameScreen, text='영어단어 맞추기',font=('Times New Roman',15))
label1.place( x=100, y=50 ,width=200 , height=100)
label2=tk.Label(master = GameScreen, text='?????',font=('Times New Roman',15))
label2.place( x=150, y=200,width=200, height=50 )
button1=tk.Button( master=GameScreen, text= '단어', font=('Arial', 13), command=click_btn1)
button1.place(x=50, y=200, width=50, height=50)
inp = tk.Entry( master=GameScreen,font=('Arial', 13))
inp.place(x=150, y=300, width= 200, height=50)
inp.insert(0,'')
label4=tk.Label(master=GameScreen, text= '정답', font=('Arial', 13))
label4.place(x=50, y=300, width=50, height=50)
button2=tk.Button(master=GameScreen, text='확인',font=('Arial', 13), command=click_btn2)
button2.place(x=150, y=400, width=100,height=50)

   
GameScreen.mainloop()
