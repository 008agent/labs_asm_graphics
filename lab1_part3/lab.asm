.286	  		
.model  small
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
	mov ah,0ch
	mov cx,x
	mov dx,y
	mov al,color
	int 10h
ENDM

;///�������� ������� �������
getch MACRO
	xor	ax,ax
	int	16h
ENDM

;///����� �����
main:
	init_gfx 
	point 333,225,1101b
	getch
	exit 0

end main
