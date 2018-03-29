    ;interrupl�ao led blink
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
    
    ;--- variaveis
    cblock H'20'
    W_TEMP				    ;guarda dasdo do w
    STATUS_TEMP				    ;guarda dados do status
    endc
    ;-- vetor de interrup��o		    
    org H'0004'				    ;As interrup��es deste processador apontam para esse ebdere�o
    ; -- salva dados temporarioas
    MOVWF W_TEMP			    ;copia w para W_TEMPO
    SWAPF STATUS,W			    ;copia status invertido para w invetido
    bank0				    ;vai para banco 0
    MOVWF STATUS_TEMP			    ;salva estatus em status_tempo

; tratar impterrupcao aqui
  btfss	    INTCON,T0IF			    ;testa desvia se for =1
  goto	    exit_ISR			    ; se 0 saia da interrupcoa
  bcf	    INTCON,T0IF			    ; limpa flag de sinal da interrupacoa
  
  ;rotina de interrupcao tmro
  MOVLW	H'0'			    ;w=07
  COMF	PORTA			    ; NOT
  MOVLW	D'1'			    ; move 1 para w
  MOVWF	TMR0			    ; inicia TMR0 em 1 tempo 256-1=255=> 255*eslar*tempo_do_clok
  
;---recupera dados
  exit_ISR:
    SWAPF STATUS_TEMP,W			    ;copia dados de STATUS_TEMP para w
    MOVWF STATUS			    ;move W para STATUS
    SWAPF W_TEMP,F			    ;inverte resitradoe
    SWAPF W_TEMP,W			    ;copia  W_TEMP para W
    retfie				    ;retorna da interrup��o
    
inicio:
    bank0
    MOVLW	H'07'			    ; move 0x07 para w
    MOVWF	CMCON			    ; desabilita comparador
    bank1				    ; banco 1
    MOVLW	H'00'			    ;w=00h
    MOVWF	TRISA			    ;trisa como saida (00)
    movlw	B'10000111'		    ;10000111
    movwf	OPTION_REG		    ; set pre escalar 1:256 para timer0
    bank0
    MOVLW	H'07'			    ;w=07
    MOVWF	PORTA			    ; PORTA = 00000111
    MOVLW	H'A0'			    ; carrega literal para w
    MOVWF	INTCON			    ;abilita intrrup��o global e do trm0
    MOVLW	D'1'			    ; move 1 para w
    MOVWF	TMR0			    ; inicia TMR0 em 1
    
   loop:
    
    nop
    goto loop
  
    end
    





