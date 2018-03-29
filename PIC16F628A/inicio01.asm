    ;EXEMPLO DE selecao de banco de memoria
    ;pic16f628a
    ; autor: Elton fernandes dos Santos data 28/09/2017
    
    ; 4Mhz ciclo de maquina = 1us
    
    ;-- listagem do processador
    list p=16F628A	    ;pic utilizado
    
    ;-- include
    #include<p16F628a.inc>
    
;--- fuse bits
    ; cristal de 4MHz
    ;desabilita Watch dog TIMER
    ; habilita tempo de espera ao iniciar (estabilisador)
    ; Brown out desabilitado (se abilitado o micro reset acaso a tensãoo de alimentação baixar (3v , 4v))
    ; sem programação de baixa tensão  (vamos usar os 13v vpp para programar)
    ; sem proteção de codigo
    ; sem proteção da eprom
    
    __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_ON
    
    ;-- paginaçao de memoria
    #define	bank0 bcf STATUS,RP0	    ; cria mnemônoco par banco 0
    #define	bank1 bsf STATUS,RP0	    ;cria mnemônoco par banco 1
    
    ;-- vetor de reset
    org H'0000'				    ;Origem no endereço 00h de memoria
    goto inicio				    ;Desvia para label inicio
    
    ;-- vetor de interrupção		    
    org H'0004'				    ;As interrupções deste processador apontam para esse ebdereço
    retfie				    ;retorna da interrupção
    
inicio:
    bank0
    MOVLW	H'07'			    ; move 0x07 para w
    MOVWF	CMCON			    ; desabilita comparador
    bank1				    ; banco 1
    MOVLW	H'00'			    ;w=00h
    MOVWF	TRISA			    ;trisb como saida (00)
    bank0
    MOVLW	H'07'			    ;w=00
    MOVWF	PORTA			    ; PORTA = 00000111
    
    end
    


