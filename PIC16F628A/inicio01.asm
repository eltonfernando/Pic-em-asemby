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
    ; Brown out desabilitado (se abilitado o micro reset acaso a tens�oo de alimenta��o baixar (3v , 4v))
    ; sem programa��o de baixa tens�o  (vamos usar os 13v vpp para programar)
    ; sem prote��o de codigo
    ; sem prote��o da eprom
    
    __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_ON
    
    ;-- pagina�ao de memoria
    #define	bank0 bcf STATUS,RP0	    ; cria mnem�noco par banco 0
    #define	bank1 bsf STATUS,RP0	    ;cria mnem�noco par banco 1
    
    ;-- vetor de reset
    org H'0000'				    ;Origem no endere�o 00h de memoria
    goto inicio				    ;Desvia para label inicio
    
    ;-- vetor de interrup��o		    
    org H'0004'				    ;As interrup��es deste processador apontam para esse ebdere�o
    retfie				    ;retorna da interrup��o
    
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
    


