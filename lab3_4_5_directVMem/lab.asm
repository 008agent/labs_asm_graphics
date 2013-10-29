.286
.model  small,stdcall
.stack 256	

.data
gfxModeB DB ?
	 
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
point proc x:word,y:word
pusha
	   mov  ax,0a000h      ;указываем на видеобуфер
	mov  es,ax          ;
	mov  bx,0          ;указываем на первый байт буфера ;;;тут смещение по видеопамяти
	mov cx,y
ckl:
	add bx,80
loop ckl
mov cl,128
   mov si,x
   shr si,3
   add bx,si
   
   mov di,x
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
hline proc x:word,y:word,leng:word
pusha
	mov cx,leng
	mov dx,x
	cycle:
		invoke point,dx,y
		inc dx
	loop cycle
popa
ret
hline endp

;VERTICAL LINE FUNCTION
vline proc x:word,y:word,leng:word
pusha
	mov cx,leng
	mov dx,y
	cycle:
		invoke point,x,dx
		inc dx
	loop cycle
popa
ret
vline endp

;ENTRY POINT	
main:   
	gfx_mode_push
 	
	gfx_mode_set 12h	

	set_color 13
	invoke point,150,150
	
	set_color 9
	invoke hline,100,100,100
	set_color 6
	invoke hline,100,200,100
	set_color 4
	invoke vline,100,100,100
	set_color 2
	invoke vline,200,100,100
	
	wait_key
	
	gfx_mode_pop

	exit 0

end main