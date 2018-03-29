;
; Curso de Assembly para PIC WR Kits Aula 39
;
;
; Interrup��o por Ovf do Timer 2
;
; EQUA��O PARA C�LCULO DO ESTOURO DO TIMER 2:
;
;
; OvfTimer2 = ciclo de m�quina x PR2 x prescaler x postscaler
;           =      1E-6        x 255 x    16      x    16   65ms
;
;
; Dispon�vel em https://wrkits.com.br/catalog/show/141 
;
; Clock: 4MHz    Ciclo de m�quina = 1�s
;
; Autor: Eng. Wagner Rambo   Data: Agosto de 2016
;
;

; --- Listagem do Processador Utilizado ---
	list	p=16F628A						;Utilizado PIC16F628A
		
	
; --- Arquivos Inclusos no Projeto ---
	#include <p16F628a.inc>					;inclui o arquivo do PIC 16F628A
	
	
; --- FUSE Bits ---
; - Cristal de 4MHz
; - Desabilitamos o Watch Dog Timer
; - Habilitamos o Power Up Timer
; - Brown Out desabilitado
; - Sem programa��o em baixa tens�o, sem prote��o de c�digo, sem prote��o da mem�ria EEPROM
; - Master Clear Habilitado
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
	
	
; --- Pagina��o de Mem�ria ---
	#define		bank0	bcf	STATUS,RP0		;Cria um mnem�nico para selecionar o banco 0 de mem�ria
	#define		bank1	bsf	STATUS,RP0		;Cria um mnem�nico para selecionar o banco 1 de mem�ria
	
	
; --- Mapeamento de Hardware (PARADOXUS PEPTO) ---
	;#define		LED1	PORTA,3				;LED1 ligado ao pino RA3
	;#define		LED2	PORTA,2				;LED2 ligado ao pino RA2


; --- Registradores de Uso Geral ---
	cblock		H'20'						;In�cio da mem�ria dispon�vel para o usu�rio
	
	W_TEMP									;Registrador para armazenar o conte�do tempor�rio de work
	STATUS_TEMP								;Registrador para armazenar o conte�do tempor�rio de STATUS
	 
 
	endc									;Final da mem�ria do usu�rio
	

; --- Vetor de RESET ---
	org			H'0000'						;Origem no endere�o 00h de mem�ria
	goto		inicio						;Desvia para a label in�cio
	

; --- Vetor de Interrup��o ---
	org			H'0004'						;As interrup��es deste processador apontam para este endere�o
	
; -- Salva Contexto --
	movwf 		W_TEMP						;Copia o conte�do de Work para W_TEMP
	swapf 		STATUS,W  					;Move o conte�do de STATUS com os nibbles invertidos para Work
	bank0									;Seleciona o banco 0 de mem�ria (padr�o do RESET) 
	movwf 		STATUS_TEMP					;Copia o conte�do de STATUS com os nibbles invertidos para STATUS_TEMP
; -- Final do Salvamento de Contexto --


	; Trata ISR...
	btfss		PIR1,TMR2IF					;houve overflow do Timer2?
	goto		exit_ISR					;N�o, desvia para sa�da da interrup��o
	bcf			PIR1,TMR2IF				;limpa flag
	
	comf		PORTB						;inverte RB0



; -- Recupera Contexto (Sa�da da Interrup��o) --
exit_ISR:

	swapf 		STATUS_TEMP,W			;Copia em Work o conte�do de STATUS_TEMP com os nibbles invertidos
	movwf 		STATUS 				;Recupera o conte�do de STATUS
	swapf 		W_TEMP,F 			;W_TEMP = W_TEMP com os nibbles invertidos 
	swapf 		W_TEMP,W  			;Recupera o conte�do de Work
	
	retfie						;Retorna da interrup��o
	
	
inicio:

	bank1						;Seleciona o banco 1 de mem�ria
	movlw		H'0'				;move 11111110 W
	movwf		TRISB				;configuro RB0 como sa�da
	movlw		D'255'				;move 255d para work
	movwf		PR2				;PR2 = 255d (limite de estouro tmr2)
	bsf		PIE1,TMR2IE			;habilita interrup��o do Timer2
	
	bank0
	movlw		H'0'				;move 0h para work
	movwf		PORTB				;iniciar RB0 em low
	movlw		B'11111111'			;move B'00100101' para work
	movwf		T2CON				;postscaler 1:16, liga Timer2, prescaler 1:16
	bsf			INTCON,GIE		;habilita interrup��o global
	bsf			INTCON,PEIE		;habilita interrup��o dos perif�ricos

 
 

; --- Loop Infinito ---	
	goto		$				;aguarda interrup��o...	

; --- Final do Programa ---	
	end						;Final do Programa
	
	
	



