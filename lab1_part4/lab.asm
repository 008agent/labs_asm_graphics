.286	  		
.model  small,stdcall
.stack 256		 
.code			

;///������������� �������
init_gfx MACRO
		mov ah,0fh		;��������� ������� ����������
		int 10h			;� si ������� ����������
		mov ah,0h
		mov si,ax
	mov	ah,00h			;������������� ������������
	mov	al,012h 		;������
	int	10h    			;������������� �����
   	mov ax,0A000h    	;��������� �� ����������
  	mov es,ax          
ENDM

;///���������� ��������� � ��������� �����
exit MACRO code
	mov ax,si
	mov ah,0h
	int 10h
	mov ah,4ch
	mov al,code
	int 21h
ENDM

;///����� ����� � ���������� ������������ � ������
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

;///�������� ������� �������
getch MACRO
	xor	ax,ax
	int	16h
ENDM

;///����� �����
main:
	init_gfx 
	invoke hline,10,20,100,100
	invoke hline,20,30,100,5
	invoke hline,10,40,100,25
	invoke hline,20,50,200,5
	getch
	exit 0

end main
