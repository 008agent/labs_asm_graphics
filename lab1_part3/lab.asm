.286	  		
.model  small
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
	mov ah,0ch
	mov cx,x
	mov dx,y
	mov al,color
	int 10h
ENDM

;///ожидание нажатия клавиши
getch MACRO
	xor	ax,ax
	int	16h
ENDM

;///точка входа
main:
	init_gfx 
	point 333,225,1101b
	getch
	exit 0

end main
