;
; Curso de Assembly para PIC WR Kits Aula 27
;
;
; Sub-Rotina para Divisão
;
; Divide dois número (A0 e B0) e armazena o resultado em C0
;
; Sistema Embarcado Sugerido: PARADOXUS PEPTO
;
; Disponível em https://wrkits.com.br/catalog/show/141 
;
; Clock: 4MHz    Ciclo de máquina = 1µs
;
; Autor: Eng. Wagner Rambo   Data: Maio de 2016
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
; - Sem programação em baixa tensão, sem proteção de código, sem proteção da memória EEPROM
	__config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_ON
	
	
; --- Paginação de Memória ---
	#define		bank0	bcf	STATUS,RP0		;Cria um mnemônico para selecionar o banco 0 de memória
	#define		bank1	bsf	STATUS,RP0		;Cria um mnemônico para selecionar o banco 1 de memória
	
	
; --- Registradores de Uso Geral ---
	cblock		H'20'						;Início da memória disponível para o usuário
	
	A0										;armazena o conteúdo de um dos números a serem multiplicados
	B0										;armazena o conteúdo de um dos números a serem multiplicados
	C0										;byte menos significativo do resultado
	 
 
	endc									;Final da memória do usuário
	

; --- Vetor de RESET ---
	org			H'0000'						;Origem no endereço 00h de memória
	goto		inicio						;Desvia para a label início
	

; --- Vetor de Interrupção ---
	org			H'0004'						;As interrupções deste processador apontam para este endereço
	retfie									;Retorna da interrupção
	
	
inicio:
	bank0									;Seleciona o banco 0 de memória
	movlw		H'07'						;w = 7h
	movwf		CMCON						;CMCON = 7h (apenas I/Os digitais) desabilita os comparadores internos
	bank1									;Seleciona o banco 1 de memória
	movlw		H'00'						;w = 00h
	movwf		OPTION_REG					;Habilita resistores de pull-up internos
	bank0									;Seleciona o banco 0 de memória
	
 	movlw		D'145'						;Carrega número em W
 	movwf		A0							;A0 = número
 	movlw		D'5'						;Carrega número em W
 	movwf		B0							;B0 = número
 	call		div							;chama sub-rotina de multiplicação
 											;Retornará -> <C1:C0> = A0 x B0



	goto		$							;prenda o programa nesta linha
		
	
; --- Desenvolvimento das Sub-Rotinas Auxiliares ---
div:

	clrf		C0							;limpa registrador C0
	
	
div_loop:

	movf		B0,W						;Copia divisor para W
	subwf		A0,F						;subtrai divisor B0 do dividendo A0
	btfss		STATUS,C					;testa para ver se houve carry
	goto		div_menor					;dividendo menor que zero, desvia para label div_menor
	incf		C0,F						;se dividendo maior que zero incrementa o quociente
	goto		div_loop					;retorna para novo ciclo de subtração
	
div_menor:

	
	return									;retorna
	

	
	end										;Final do Programa
	
	


