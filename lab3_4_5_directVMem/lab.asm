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
	xor	ax,ax		;�������� ������� �������
	int	16h
ENDM

exit MACRO code
 	mov ah,4ch	;����� �� ������� � ���������
	mov al,code
	INT	21H		;� ���������� �����
ENDM

set_color MACRO color
   mov  dx,3c4h        ;setting address register
   mov  al,2           ;������ �������� ����� �����
   out  dx,al          ;��������� ������
   inc  dx             ;��������� �� ������� ������
   mov  al,color           ;��� �����
   out  dx,al          ;�������� ��� �����
ENDM

;POINT DRAW FUNCTION
point proc x:word,y:word
pusha
	   mov  ax,0a000h      ;��������� �� ����������
	mov  es,ax          ;
	mov  bx,0          ;��������� �� ������ ���� ������ ;;;��� �������� �� �����������
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
   
   mov  dx,3ceh        ;��������� �� �������� �������
   mov  al,8           ;����� ��������
   out  dx,al          ;�������� ���
   inc  dx             ;��������� �� ������� ������
   mov  al,cl   ;�����
   out  dx,al          ;�������� ������
;---������ ������� ���������� ��������
   mov  al,es:[bx]     ;������ ���������� � ��������
   mov  al,0           ;��������� � �������
   mov  es:[bx],al     ;������ ��������
   
   mov  al,cl     ;����� �������� � ������������� 7 �����
   mov  es:[bx],al     ;������� �����
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