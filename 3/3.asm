;Se ingresa un año. La computadora indica si es, o no, bisiesto.

; "D:\NASM\nasm.exe" -f win32 3.asm --PREFIX _

; gcc.exe 3.obj -o 3.exe

; 3.exe

global _start
global main
extern printf
extern scanf
extern exit
extern gets

section .bss
    numero:
        resd 1 ; 1 dword (4 bytes)
    cadena:
        resb 0x0100 ; 256 bytes

section .data
    fmtInt:
        db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
    fmtString:
        db "%s", 0 ; FORMATO PARA CADENAS
    pedirUnAnio:
        db "Ingrese un anio: ", 0
    esBisiesto:
        db "Es un anio bisiesto", 0 
    noEsBisiesto:
        db "No es un anio bisiesto", 0 

section .text
    mostrarCadena: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena 
        push fmtString 
        call printf 
        add esp, 8 
        ret
    leerNumero: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
    salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit
    mostrarPedirUnAnio:
        push pedirUnAnio
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarRsultadoNegativo:
        push noEsBisiesto
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarRsultadoPositivo:
        push esBisiesto
        push fmtString 
        call printf 
        add esp, 8 
        ret
main:
_start:
    call mostrarPedirUnAnio
    call leerNumero

    mov eax, [numero]
    mov ecx, 4
    mov edx, 0
    div ecx
    cmp edx, 0
    jne salirMal

    mov eax, [numero]
    mov ecx, 100
    mov edx, 0
    div ecx
    cmp edx, 0
    je salirMal

    salirBien:
        call  mostrarRsultadoPositivo
        call salirDelPrograma

    salirMal:
        mov eax, [numero]
        mov ecx, 400
        mov edx, 0
        div ecx
        cmp edx, 0
        je salirBien
        call  mostrarRsultadoNegativo
        call salirDelPrograma

    


