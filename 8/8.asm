;  Se ingresa una matriz de NxN componentes enteras. La computadora muestra la matriz transpuesta.

; "D:\NASM\nasm.exe" -f win32 8.asm --PREFIX _
; gcc.exe 8.obj -o 8.exe
; 8.exe

; 1 2 3   1 4 7
; 4 5 6   2 5 8
; 7 8 9   3 6 9

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
    valorIngresado:
        resd 1 
    matriz:
        resd 100 ; maximo una matriz de 10x10
    cantidadFilasYColumnas:
        resd 1 ; 1 dword (4 bytes)
    contadorFilas:
        resd 1 ; 1 dword (4 bytes)
    contadorColumnas:
        resd 1 ; 1 dword (4 bytes)
    posicion:
        resd 1

section .data
    fmtInt:
        db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
    fmtString:
        db "%s", 0 ; FORMATO PARA CADENAS
    fmtChar:
        db "%c", 0 ; FORMATO PARA CARACTERES
    fmtLF:
        db 0xA, 0 ; SALTO DE LINEA (LF)
    pedirCantFilasYColumnas:
        db "Ingresar la cantidad de filas y columnas: ", 0
    pedirValorIngresadoP1:
        db "Ingresar valor para la fila: ", 0
    pedirValorIngresadoP2:
        db " y la columna: ", 0
    igualEspacio:
        db " = ", 0
    espacio:
        db " ", 0

section .text
    leerCantidadFilasYColumnas: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push cantidadFilasYColumnas
        push fmtInt 
        call scanf 
        add esp, 8 
        ret
    leerValorIngresado: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push valorIngresado
        push fmtInt 
        call scanf 
        add esp, 8 
        ret
    mostrarSaltoDeLinea: ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF 
        call printf
        add esp, 4 
        ret
    mostrarPedirValorIngresadoP1: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push pedirValorIngresadoP1 
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarPedirValorIngresadoP2: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push pedirValorIngresadoP2 
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarContadorFilas:
        push dword [contadorFilas]
        push fmtInt 
        call printf 
        add esp, 8 
        ret
    mostrarContadorColumnas:
        push dword [contadorColumnas]
        push fmtInt 
        call printf 
        add esp, 8 
        ret
    mostrarIgualEspacio:
        push igualEspacio 
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarEspacio:
        push espacio 
        push fmtString 
        call printf 
        add esp, 8 
        ret

main:
_start:
    call pedirCantFilasYColumnas
    call leerCantFilas