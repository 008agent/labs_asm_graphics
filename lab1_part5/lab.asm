.286	  		
.model  small,stdcall
.stack 256		 
.code			

;///инициализация графики
init_gfx MACRO
		mov ah,0fh		;сохраняем текущий видеорежим
		int 10h			;в si прошлый видеорежим
		mov ah,0h
		mov si,ax
	mov	ah,00h			;инициализация графического
	mov	al,012h 		;режима
	int	10h    			;устанавливаем режим
   	mov ax,0A000h    	;указываем на видеобуфер
  	mov es,ax          
ENDM

;///завершение программы с указанным кодом
exit MACRO code
	mov ax,si
	mov ah,0h
	int 10h
	mov ah,4ch
	mov al,code
	int 21h
ENDM

;///вывод точки с указанными координатами и цветом
point MACRO x,y,color
pusha
	mov ah,0ch
	mov cx,x
	mov dx,y
	mov al,color
	int 10h
popa
ENDM

hline proc x:word,y:word,offs:word,color:byte
pusha
	mov cx,offs
	mov dx,cx
	add dx,x
cycle:
	point dx,y,color
	dec dx	
loop cycle
popa
ret
hline endp

vline proc x:word,y:word,offs:word,color:byte
pusha
	mov cx,offs
	mov dx,cx
	add dx,y
cycle:
	point x,dx,color
	dec dx	
loop cycle
popa
ret
vline endp

;///ожидание нажатия клавиши
getch MACRO
	xor	ax,ax
	int	16h
ENDM

;///точка входа
main:
	init_gfx 
	invoke vline,10,20,100,100
	invoke hline,10,20,100,5


	getch
	exit 0

end main
