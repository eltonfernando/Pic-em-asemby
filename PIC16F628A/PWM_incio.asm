;utilizando PWM para pic
;
; Clock: 4MHz    Ciclo de m�quina = 1�s
;
; Autor: Elton fernandes dos santos  Data: outubro de 2017
; semiciclo ativo = CCPR1L:CCP1CON<5:4> x ciclo de oscila��o x TMR2
; 10 bits
;   CCPR1L	    CCP1CON,5	CCPR1CON,4
;0 0 0 0 0 0 0 0	0	    0
; --- Listagem do Processador Utilizado ---
	list	p=16F628A		    ;Utilizado PIC16F628A
			
; --- Arquivos Inclusos no Projeto ---
	#include <p16F628a.inc>		    ;inclui o arquivo do PIC 16F628A
		
; --- FUSE Bits ---
; - Cristal de 4MHz
; - Desabilitamos o Watch Dog Timer
; - Habilitamos o Power Up Timer
; - Brown Out desabilitado
; - Sem programa��o em baixa tens�o, sem prote��o de c�digo, sem prote��o da mem�ria EEPROM
; - Master Clear Habilitado
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
	
	
; --- Pagina��o de Mem�ria ---
	#define		bank0	bcf	STATUS,RP0  ;Cria um mnem�nico para selecionar o banco 0 de mem�ria
	#define		bank1	bsf	STATUS,RP0  ;Cria um mnem�nico para selecionar o banco 1 de mem�ria
					
; --- Vetor de RESET ---
	org			H'0000'		    ;Origem no endere�o 00h de mem�ria
	goto		inicio			    ;Desvia para a label in�cio
	

; --- Vetor de Interrup��o ---
	org			H'0004'		    ;As interrup��es deste processador apontam para este endere�o

	retfie					    ;Retorna da interrup��o
	
	
inicio:

	bank1					    ;Seleciona o banco 1 de mem�ria
	movlw		H'0'			    ;move 11111110 W
	movwf		TRISB			    ;configuro RB0 como sa�da
	bank0
	movlw		B'11111111'		    ;move B'00100101' para work
	movwf		T2CON			    ;postscaler 1:16, liga Timer2, prescaler 1:16
	movlw		D'128'			    ;
	
	bcf		CCP1CON,4		    ; bit (0) menos significativo do duy
	bcf		CCP1CON,5		    ;bit 1 significativo do duy
	movwf		CCPR1L			    ; incial duty
	movlw		H'0c'			    ;00001100
	movwf		CCP1CON
			
; --- Loop Infinito ---	
	goto		$			    ;aguarda interrup��o...	

; --- Final do Programa ---	
	end					    ;Final do Programa
	
	
	






