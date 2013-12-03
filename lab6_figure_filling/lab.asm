.286
.model  small,stdcall
.stack 256	

.data

.code			

gfx_mode_push MACRO
	mov ah,0fh
	int 10h
	mov gfxModeB,al
ENDM

gfx_mode_pop MACRO
	gfx_mode_set gfxModeB
ENDM


gfx_mode_set MACRO mode
	mov	ah,00h		
	mov	al,mode    
	int	10h       	
ENDM

wait_key MACRO
	xor	ax,ax		;ожидание нажатия клавиши
	int	16h
ENDM

exit MACRO code
 	mov ah,4ch	;выход из графики с возвратом
	mov al,code
	INT	21H		;в предыдущий режим
ENDM

set_color MACRO color
   mov  dx,3c4h        ;setting address register
   mov  al,2           ;индекс регистра маски карты
   out  dx,al          ;установка адреса
   inc  dx             ;указываем на регистр данных
   mov  al,color           ;код цвета
   out  dx,al          ;посылаем код цвета
ENDM

;POINT DRAW FUNCTION
point proc _x:word,_y:word
pusha
	   mov  ax,0a000h      ;указываем на видеобуфер
	mov  es,ax          ;
	mov  bx,0          ;указываем на первый байт буфера ;;;тут смещение по видеопамяти
	mov cx,_y
ckl:
	add bx,80
loop ckl
mov cl,128
   mov si,_x
   shr si,3
   add bx,si
   
   mov di,_x
   push ax
   xor ax,ax
   mov ax,di
   shl si,3
   sub ax,si
	xchg ax,cx
	ror al,cl
	xchg ax,cx
  pop ax 
   
   mov  dx,3ceh        ;указываем на адресный регистр
   mov  al,8           ;номер регистра
   out  dx,al          ;посылаем его
   inc  dx             ;указываем на регистр данных
   mov  al,cl   ;маска
   out  dx,al          ;посылаем данные
;---чистим текущее содержимое задвижки
   mov  al,es:[bx]     ;читаем содержимое в задвижку
   mov  al,0           ;готовимся к очистке
   mov  es:[bx],al     ;чистим задвижку
   
   mov  al,cl     ;любое значение с установленным 7 битом
   mov  es:[bx],al     ;выводим точку
popa
ret
point endp
	
;HORISONTAL LINE FUNCTION
hline proc _x:word,_y:word,leng:word
pusha
	mov cx,leng
	mov dx,_x
	cycle:
		invoke point,dx,_y
		inc dx
	loop cycle
popa
ret
hline endp

;VERTICAL LINE FUNCTION
vline proc _x:word,_y:word,leng:word
pusha
	mov cx,leng
	mov dx,_y
	cycle:
		invoke point,_x,dx
		inc dx
	loop cycle
popa
ret
vline endp

line proc x1:word,y1:word,x2:word,y2:word
LOCAL _dx:word,_dy:word,d:word,d1:word,d2:word
pusha
;int dx = x2 - x1;
mov ax,x2
sub ax,x1
mov _dx,ax
;int dy = y2 - y1;
mov ax,y2
sub ax,y1
mov _dy,ax
;int d = 2 * dy - dx;
mov ax,_dy
sal ax,1
sub ax,_dx
mov d,ax
;int d1 = 2*dy;
mov ax,_dy
sal ax,1
mov d1,ax
;int d2 = 2*(dy - dx);
mov ax,_dy
sub ax,_dx
sal ax,1
mov d2,ax
;SetPixel(x1, y1, color);
invoke point,x1,y1
;for (int x = x1 + 1; int y = y1; x <= x2; x++) {
mov si,x1;si=x,di=y
inc si
mov di,y1
	.WHILE si<=x2
	;if (d < 0) {
	mov dx,d
	.IF dx<0
		;d += d1;
		add dx,d1
		mov d,dx
		;} else {
	.ELSE
		add dx,d2
		mov d,dx
		inc di
	;d += d2;
	;y += 1;
	;}
	.ENDIF
	;SetPixel( x, y, color);
	invoke point,si,di
	;// Очередная точка отрезка
	inc si
	.ENDW
;} 

popa
ret
line endp

octant proc _x:word,_y:word,r:word,Noctant:word
pusha
;si - x, di - y, bx - d, cx - iteration
mov si,0
mov di,r
xor bx,bx
xor cx,cx
	.WHILE si<di
		inc si
		add bx,si
			.IF bx<di
			.ENDIF
			.IF bx>=di
				dec di
				sub bx,di
			.ENDIF
			push si
			push di
				mov ax,Noctant
				.IF(ax==1)
					xchg si,di
					neg di
				.ELSEIF(ax==2)
					neg di
				.ELSEIF(ax==3)
					neg si
					neg di
				.ELSEIF(ax==4)
					neg di
					xchg si,di
					neg di
				.ELSEIF(ax==5)
					neg di
					xchg si,di
				.ELSEIF(ax==6)
					neg si
				.ELSEIF(ax==7)
					;nothing
				.ELSEIF(ax==8)
					neg di	
					neg si
					xchg si,di
					neg di	
					neg si
				.ENDIF
			add si,_x
			add si,r
			sub di,r
			add di,_y
		invoke point,si,di
			pop di
			pop si
	.ENDW	
popa
ret
octant endp

round proc _x:word,_y:word,r:word
pusha
	mov cx,1
	.WHILE cx<9
		invoke octant,_x,_y,r,cx
		inc cx
	.ENDW
popa
ret
round endp

filloctant proc _x:word,_y:word,r:word,Noctant:word
pusha
	mov cx,r
	mov ax,_x
	mov bx,_y
	.WHILE cx>0
		invoke octant,ax,bx,cx,Noctant
	dec cx
	inc ax
	dec bx
	.ENDW
popa
ret
filloctant endp

fillround proc _x:word,_y:word,r:word
pusha
	mov cx,r
	mov ax,_x
	mov bx,_y
	.WHILE cx>0
		invoke round,ax,bx,cx
	dec cx
	inc ax
	dec bx
	.ENDW
popa
ret
fillround endp

figure proc
pusha
	invoke filloctant,320,200,100,1
	invoke filloctant,320,200,100,2
	invoke filloctant,320,200,100,7
	invoke filloctant,320,200,100,8
	
	invoke vline,421,150,201
	
	invoke octant,320,400,50,5
	invoke octant,320,400,50,6
	invoke octant,320,400,50,7
	invoke octant,320,400,50,8
	

popa
ret
figure endp

;ENTRY POINT	
main:   
 	
	gfx_mode_set 12h	
	set_color 13

	invoke figure
	wait_key
	

	exit 0

end main