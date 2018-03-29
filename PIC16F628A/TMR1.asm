;
;trabalhando como timer 1 de 16 bits
;
; Clock: 4MHz    Ciclo de máquina = 1µs
;
; Autor: elton fernandes dos santos   Data: outubro de 2017

; --- Listagem do Processador Utilizado ---
	list	p=16F628A					;Utilizado PIC16F628A
		
	
; --- Arquivos Inclusos no Projeto ---
	#include <p16F628a.inc>					;inclui o arquivo do PIC 16F628A
	
	
; --- FUSE Bits ---
; - Cristal de 4MHz
; - Desabilitamos o Watch Dog Timer
; - Habilitamos o Power Up Timer
; - Brown Out desabilitado
; - Sem programação em baixa tensão, sem proteção de código, sem proteção da memória EEPROM
; - Master Clear Habilitado
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
	
	
; --- Paginação de Memória ---
	#define		bank0	bcf	STATUS,RP0		;Cria um mnemônico para selecionar o banco 0 de memória
	#define		bank1	bsf	STATUS,RP0		;Cria um mnemônico para selecionar o banco 1 de memória
	
	
; --- Mapeamento de Hardware (PARADOXUS PEPTO) ---
	;#define		LED1	PORTA,3				;LED1 ligado ao pino RA3
	;#define		LED2	PORTA,2				;LED2 ligado ao pino RA2


; --- Registradores de Uso Geral ---
	cblock		H'20'						;Início da memória disponível para o usuário
	
	W_TEMP									;Registrador para armazenar o conteúdo temporário de work
	STATUS_TEMP								;Registrador para armazenar o conteúdo temporário de STATUS
	 
 
	endc									;Final da memória do usuário
	

; --- Vetor de RESET ---
	org			H'0000'						;Origem no endereço 00h de memória
	goto		inicio						;Desvia para a label início
	

; --- Vetor de Interrupção ---
	org			H'0004'						;As interrupções deste processador apontam para este endereço
	
; -- Salva Contexto --
	movwf 		W_TEMP						;Copia o conteúdo de Work para W_TEMP
	swapf 		STATUS,W  					;Move o conteúdo de STATUS com os nibbles invertidos para Work
	bank0									;Seleciona o banco 0 de memória (padrão do RESET) 
	movwf 		STATUS_TEMP					;Copia o conteúdo de STATUS com os nibbles invertidos para STATUS_TEMP
; -- Final do Salvamento de Contexto --


	; Trata ISR...
	btfss		PIR1,TMR1IF					;houve overflow do Timer1?
	goto		exit_ISR					;Não, desvia para saída da interrupção
	bcf			PIR1,TMR1IF				;limpa flag do tmr1
	
	comf		PORTB						;inverte RB0



; -- Recupera Contexto (Saída da Interrupção) --
exit_ISR:

	swapf 		STATUS_TEMP,W			;Copia em Work o conteúdo de STATUS_TEMP com os nibbles invertidos
	movwf 		STATUS 				;Recupera o conteúdo de STATUS
	swapf 		W_TEMP,F 			;W_TEMP = W_TEMP com os nibbles invertidos 
	swapf 		W_TEMP,W  			;Recupera o conteúdo de Work
	
	retfie						;Retorna da interrupção
	
	
inicio:

	bank1						;Seleciona o banco 1 de memória
	movlw		H'0'				;move 11111110 W
	movwf		TRISB				;configuro RB0 como saída
	movlw		D'255'				;move 255d para work
	movwf		PR2				;PR2 = 255d (limite de estouro tmr2)
	bsf		PIE1,TMR1IE			;habilita interrupção do Timer1
	
	bank0
	movlw		H'0'				;move 0h para work
	movwf		PORTB				;iniciar RB0 em low
	movlw		B'00110001'			;configura pre-escalar e liga tmr1
	movwf		T1CON				;
	bsf			INTCON,GIE		;habilita interrupção global
	bsf			INTCON,PEIE		;habilita interrupção dos periféricos


; --- Loop Infinito ---	
	goto		$				;aguarda interrupção...	

; --- Final do Programa ---	
	end						;Final do Programa
	
	
	






