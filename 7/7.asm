global _start
global main
extern printf
extern scanf
extern exit
extern gets

; ingresamos nuestras funciones externas
extern printf
extern scanf

section .bss
    numero:
        resd 1 ; 1 dword (4 bytes)

section .data
    fmtInt:
        db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
    fmtString:
        db "%s", 0 ; FORMATO PARA CADENAS
    fmtChar:
        db "%c", 0 ; FORMATO PARA CARACTERES
    fmtLF:
        db 0xA, 0 ; SALTO DE LINEA (LF)

section .text
    leerNumero: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt 
        call scanf 
        add esp, 8 
        ret
    mostrarNumero: ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt 
        call printf 
        add esp, 8 
        ret
    mostrarSaltoDeLinea: ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF 
        call printf
        add esp, 4 
        ret

    salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

main:
_start: