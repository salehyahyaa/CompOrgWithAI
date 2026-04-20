INCLUDE Irvine32.inc


EMPTY = 0
PLAYER = 1
AI = 2

RESULT_CONTINUE = 0
RESULT_PLAYER_WIN = 1
RESULT_AI_WIN = 2
RESULT_DRAW = 3


.data
board BYTE 9 DUP(0)

introMsg BYTE "Tic Tac Toe (You = X, AI = O)", 0
promptMsg BYTE "Enter your move (1-9): ", 0
invalidMsg BYTE "Invalid move. Try again.", 0
playerWinMsg BYTE "You win!", 0
aiWinMsg BYTE "AI wins!", 0
drawMsg BYTE "It's a draw!", 0
lineMsg BYTE "-------------", 0
sepMsg BYTE "|", 0

xSymbol BYTE "X", 0
oSymbol BYTE "O", 0
blankSymbol BYTE " ", 0


.code
main PROC
    call Clrscr

    mov edx, OFFSET introMsg
    call WriteString
    call Crlf
    call Crlf

    call GameLoop

    exit
main ENDP


DisplayBoard PROC
    pushad

    call Crlf

    mov ecx, 3
    mov esi, 0

rowLoop:
    mov edx, OFFSET lineMsg
    call WriteString
    call Crlf

    mov ebx, 3

colLoop:
    mov edx, OFFSET sepMsg
    call WriteString

    mov al, board[esi]
    cmp al, PLAYER
    je showX
    cmp al, AI
    je showO

    mov edx, OFFSET blankSymbol
    jmp printCell

showX:
    mov edx, OFFSET xSymbol
    jmp printCell

showO:
    mov edx, OFFSET oSymbol

printCell:
    call WriteString

    mov edx, OFFSET sepMsg
    call WriteString

    inc esi
    dec ebx
    jnz colLoop

    call Crlf

    loop rowLoop

    mov edx, OFFSET lineMsg
    call WriteString
    call Crlf
    call Crlf

    popad
    ret
DisplayBoard ENDP


GetUserMove PROC
inputLoop:
    mov edx, OFFSET promptMsg
    call WriteString
    call ReadInt

    cmp eax, 1
    jl invalidInput
    cmp eax, 9
    jg invalidInput

    dec eax
    mov esi, eax

    mov al, board[esi]
    cmp al, EMPTY
    jne invalidInput

    mov board[esi], PLAYER
    ret

invalidInput:
    mov edx, OFFSET invalidMsg
    call WriteString
    call Crlf
    jmp inputLoop
GetUserMove ENDP


AIMove PROC
    pushad

    mov ecx, 9
    mov esi, 0

findSlot:
    mov al, board[esi]
    cmp al, EMPTY
    je placeAiMove

    inc esi
    loop findSlot
    jmp doneAiMove

placeAiMove:
    mov board[esi], AI

doneAiMove:
    popad
    ret
AIMove ENDP


CheckWin PROC
    mov eax, RESULT_CONTINUE

    ; Row 0
    mov bl, board[0]
    cmp bl, EMPTY
    je checkRow1
    cmp bl, board[1]
    jne checkRow1
    cmp bl, board[2]
    jne checkRow1
    jmp resolveWinner

checkRow1:
    mov bl, board[3]
    cmp bl, EMPTY
    je checkRow2
    cmp bl, board[4]
    jne checkRow2
    cmp bl, board[5]
    jne checkRow2
    jmp resolveWinner

checkRow2:
    mov bl, board[6]
    cmp bl, EMPTY
    je checkCol0
    cmp bl, board[7]
    jne checkCol0
    cmp bl, board[8]
    jne checkCol0
    jmp resolveWinner

checkCol0:
    mov bl, board[0]
    cmp bl, EMPTY
    je checkCol1
    cmp bl, board[3]
    jne checkCol1
    cmp bl, board[6]
    jne checkCol1
    jmp resolveWinner

checkCol1:
    mov bl, board[1]
    cmp bl, EMPTY
    je checkCol2
    cmp bl, board[4]
    jne checkCol2
    cmp bl, board[7]
    jne checkCol2
    jmp resolveWinner

checkCol2:
    mov bl, board[2]
    cmp bl, EMPTY
    je checkDiag0
    cmp bl, board[5]
    jne checkDiag0
    cmp bl, board[8]
    jne checkDiag0
    jmp resolveWinner

checkDiag0:
    mov bl, board[0]
    cmp bl, EMPTY
    je checkDiag1
    cmp bl, board[4]
    jne checkDiag1
    cmp bl, board[8]
    jne checkDiag1
    jmp resolveWinner

checkDiag1:
    mov bl, board[2]
    cmp bl, EMPTY
    je checkDraw
    cmp bl, board[4]
    jne checkDraw
    cmp bl, board[6]
    jne checkDraw
    jmp resolveWinner

checkDraw:
    mov ecx, 9
    mov esi, 0

scanBoard:
    mov bl, board[esi]
    cmp bl, EMPTY
    je continueGame
    inc esi
    loop scanBoard

    mov eax, RESULT_DRAW
    ret

resolveWinner:
    cmp bl, PLAYER
    jne aiWinner
    mov eax, RESULT_PLAYER_WIN
    ret

aiWinner:
    mov eax, RESULT_AI_WIN
    ret

continueGame:
    mov eax, RESULT_CONTINUE
    ret
CheckWin ENDP


GameLoop PROC
gameStart:
    call DisplayBoard

    call GetUserMove

    call CheckWin
    cmp eax, RESULT_CONTINUE
    jne gameOver

    call AIMove

    call CheckWin
    cmp eax, RESULT_CONTINUE
    jne gameOver

    jmp gameStart

gameOver:
    call DisplayBoard

    cmp eax, RESULT_PLAYER_WIN
    je showPlayerWin
    cmp eax, RESULT_AI_WIN
    je showAiWin

    mov edx, OFFSET drawMsg
    call WriteString
    call Crlf
    ret

showPlayerWin:
    mov edx, OFFSET playerWinMsg
    call WriteString
    call Crlf
    ret

showAiWin:
    mov edx, OFFSET aiWinMsg
    call WriteString
    call Crlf
    ret
GameLoop ENDP


END main
