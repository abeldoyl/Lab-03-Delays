    ; Abel Doyle
    ; RCET3373
    ; Lab2-1PIC
    ; https://github.com/abeldoyl/Lab-02-PIC-I-O/tree/main/Lab2-1PIC/Lab2-1PIC.X
    
; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

; config statements should precede project file includes.
#include <xc.inc>

; Reset Vector at 0000h. Execution starts here after reset.
PSECT resetVect,class=CODE,delta=2
ResetVector: 
    goto Setup


; Main code section starts at 0008h. User code goes here.
PSECT code,class=CODE,delta=2
 
Setup:
    ; add device setup here
     ; Bank 0
    BCF 0x03,6  ;Set Bank 0
    BCF 0x03,5  ;Set Bank 0
    CLRF 0x06   ;Setting PortB on reset low known
    CLRF 0x07   ;Set PortC on reset to LOW
    
    ; Bank 1
    BCF 0x03,6  ;Set Bank 1
    BSF 0x03,5  ;Set Bank 1
    CLRF 0x0B   ;Set INTCON low to remove interrupt flags 
    CLRF 0x87   ;Set PortC as an Output TRISC
    MOVLW 0xFF  ;Set TRISB high
    MOVWF 0x86  ;Set PortB as an Input TRISB
    
    ;Bank 3
    BSF 0x03,6  ;Set Bank 3
    BSF 0x03,5  ;Set Bank 3
    CLRF 0x89   ;Setting the I/O to digital PortB ANSELH
    
    BCF 0x03,6        ; Sets Bank 0
    BCF 0x03,5        ; Sets Bank 0
    outCount EQU 0x20
    midCount EQU 0x21
    inCount EQU 0x22
    MOVLW 0x30	;Initalizes DLG7137 to display 0
    MOVWF 0x07	;
    goto Main
    
    
Main:
    ; main code goes here
    MOVLW 0x05 ;1 TCY
    XORWF 0x07,1 ;1TCY
    CALL outDelay ;2TCY
    goto Main ;2TCY

outDelay:
    MOVLW 0x04 ;1 TCY
    MOVWF outCount ;1 TCY

outLoop:
    CALL midDelay ;2 TCY
    DECFSZ outCount; 1 (2) TCY
    goto outLoop ;2 TCY
    NOP
    NOP
    NOP
    RETURN ;2 TCY

midDelay:
    MOVLW 0xB7 ;1 TCY
    MOVWF midCount ;1 TCY

midLoop:
    CALL inDelay ;2 TCY
    DECFSZ midCount ;1 (2) TCY
    goto midLoop ;2 TCY
    NOP
    NOP
    NOP
    NOP
    NOP
    RETURN ;2 TCY

inDelay:
    MOVLW 0xE1 ;1 TCY
    MOVWF inCount ;1 TCY

inLoop:
    DECFSZ inCount ;1 (2) TCY
    goto inLoop ;2 TCY
    RETURN ;2 TCY

End 

    