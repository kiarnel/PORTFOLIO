import random
from re import A

from matplotlib.style import available

deck=[]

shapes = '♥♣♠◆'
numbers = []
for i in range(2,11):
    numbers.append(str(i))
    
for j in 'JQKA':
    numbers.append(j)

#전체 카드 덱 
for shape in shapes:
    for num in numbers:
        deck.append((shape,num))        #deck 은 (shape,num) 카드 들의 모임

deck.append(('Joker','black'))
deck.append(('Joker','color'))
random.shuffle(deck) #deck 카드 섞기

#플레이어 , 컴퓨터 카드 나누기
player =[]
computer=[]

for i in range(7):              #7번 뽑기
    player.append(deck.pop())
    computer.append(deck.pop())

#처음 카드 놓는 판 하나 카드 생성
pan = []
pan.append(deck.pop())

#게임 규칙 및 게임 설정

#처음 카드를 판에 놓고 게임시작. 플레이어 차례 선공. 컴퓨터 후공 플레이어 현재 소지한 패 중
#낼 수 있는 패를 선택하여 플레이어 가지고 있는 패를 없애고 낼 수 있는 패가 없다면
# 소지하고 있는 패 증가(중복 없이) 턴 넘어가면 컴퓨터가 동일한 처리 먼저 0장이 되는 
#유저가 승리

while True:
    #선공 플레이어 차례
    print('플레이어 차례입니다')
    print('현재 소지한 패',player)
    print('놓여진 카드 ',pan[-1])

    
    able = []
    for  card in player:
        if (card[0] == pan[-1],[0]    #카드가 모양이 같은가?
            or card[1] == pan[-1][1]   #카드가 숫자가 같은가?
            or card[0] == 'Joker'       #카드가 조커인가
            or pan[-1][0] == 'Joker' ): #판에 놓인 카드가 조커인가?
            able.append(card)
    print('낼 수 있는 카드:', able)

    #낼수 있는 카드 

    if len(able) > 0:       #낼수 있는 카드 가 있을떄
        i = int(input('몇 번쨰 카드를 내시겠습니까?'))
        i -= 1
        select = able[i]        #낼 수 있는 카드 중  몇번쨰인지 선택
        player.remove(select)   #선택된 카드 player 패에서 삭제
        pan.append(select)      #놓여진 카드에 선택된 카드 추가
    else:
        print('낼 수 있는 카드가 없습니다.')
        player.append(deck.pop())
    if len(player) == 0:        #플레이어 패가 없으면 플레이어 승리

        print('player win!')
        break

    #컴퓨터 차례
    print('컴퓨터 차례입니다')
    print('놓여진 카드 :',pan[-1])

    able=[]
    for card in computer:
        if (card[0] == pan[-1],[0]    #카드가 모양이 같은가?
            or card[1] == pan[-1][1]   #카드가 숫자가 같은가?
            or card[0] == 'Joker'       #카드가 조커인가
            or pan[-1][0] == 'Joker' ): #판에 놓인 카드가 조커인가?
            able.append(card) 
    if len(able) > 0:
        select = random.choice(able)
        computer.remove(select)
        pan.append(select)
        print('컴퓨터가 ',select,'냈습니다.')

    else:
        print('낼 수 있는 카드가 없어 카드를 가집니다')
        computer.append(deck.pop())
    if len(computer) == 0:
        print('컴퓨터가 승리했습니다')
        break

