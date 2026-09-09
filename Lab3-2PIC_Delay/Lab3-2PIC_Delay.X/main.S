    ; Abel Doyle
    ; RCET3373
    ; Lab3-2PIC
    ; https://github.com/abeldoyl/Lab-03-Delays/tree/main/Lab3-2PIC_Delay/Lab3-2PIC_Delay.X
    
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
    ; Bank 0 Setup for PORTB
    BCF 0x03,6
    BCF 0x03,5
    CLRF 0x06 ; Setting PORTB low on Reset
    
    ; Bank 1 Setup for PORT B
    BCF 0x03,6
    BSF 0x03,5
    CLRF 0x86 ; Setting TRISB low on Reset so that it's an output
    
    ; Bank 2 Setup for PORTB
    BSF 0x03,6
    BCF 0x03,5
    BSF 0x09,1 ; Setting Bit 1 high for CM2CON1
    
    ; Bank 3 Setup for PORTB
    BSF 0x03,6
    BSF 0x03,5
    CLRF 0x89 ; Setting ANSELH I/O to Digital
    
    BCF 0x03,6
    BCF 0x03,5
    goto Main
    
    
Main:
    count    EQU 0x20                   ;use data memory address 0x20 as an 8-bit loop counter  

MainLoop:
    MOVLW 0x01                      ;1 TCY code not part of delay
    XORWF PORTB,1                   ;1 TCY code not part of delay

    MOVLW 0x0F                      ;1 TCY delay overhead
    MOVWF count                     ;1 TCY delay overhead
    
DelayLoop:                     
    DECFSZ count,1                  ;1(2) 1 TCY if not zero, 2 TCY if zero
    goto DelayLoop                  ;2 TCY
    goto MainLoop                   ;2 TCY code not part of delay
End