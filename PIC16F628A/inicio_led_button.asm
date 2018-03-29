    ;acende led ao precionar um botao
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
    #define	bank0	bcf STATUS,RP0	    ; cria mnem�noco par banco 0
    #define	bank1	bsf STATUS,RP0	    ;cria mnem�noco par banco 1
    
    ;-- entrada
    #define	botao	PORTA,1		    ; botao 1 
    
    ;--- saida--
    #define	led	PORTA,2		    ;led 1 liga 0 desliga
    
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
    MOVLW	B'11111011'		    ;w= 00000100
    MOVWF	TRISA			    ;RA2 com saida
    bank0				    ;banco 1
    BCF		led			    ;deliga led
  loop:  
    BTFSC	botao			    ; testa se 0 pula proxima linha
    goto	apaga_led		    ; apaga p led
    BSF		led			    ;liga o  led
    goto	loop			    ; volta para loop
apaga_led:
    BCF		led			    ;apaga o led
    goto loop
    
    end
    





