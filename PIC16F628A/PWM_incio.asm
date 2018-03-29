;utilizando PWM para pic
;
; Clock: 4MHz    Ciclo de máquina = 1µs
;
; Autor: Elton fernandes dos santos  Data: outubro de 2017
; semiciclo ativo = CCPR1L:CCP1CON<5:4> x ciclo de oscilação x TMR2
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
; - Sem programação em baixa tensão, sem proteção de código, sem proteção da memória EEPROM
; - Master Clear Habilitado
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
	
	
; --- Paginação de Memória ---
	#define		bank0	bcf	STATUS,RP0  ;Cria um mnemônico para selecionar o banco 0 de memória
	#define		bank1	bsf	STATUS,RP0  ;Cria um mnemônico para selecionar o banco 1 de memória
					
; --- Vetor de RESET ---
	org			H'0000'		    ;Origem no endereço 00h de memória
	goto		inicio			    ;Desvia para a label início
	

; --- Vetor de Interrupção ---
	org			H'0004'		    ;As interrupções deste processador apontam para este endereço

	retfie					    ;Retorna da interrupção
	
	
inicio:

	bank1					    ;Seleciona o banco 1 de memória
	movlw		H'0'			    ;move 11111110 W
	movwf		TRISB			    ;configuro RB0 como saída
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
	goto		$			    ;aguarda interrupção...	

; --- Final do Programa ---	
	end					    ;Final do Programa
	
	
	






