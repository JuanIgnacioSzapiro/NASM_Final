; Se ingresa una cadena. La computadora muestra las subcadenas formadas por las posiciones pares e impares de la cadena. Ej: FAISANSACRO : ASNAR FIASCO

; "D:\NASM\nasm.exe" -f win32 2.asm --PREFIX _

; gcc.exe 2.obj -o 2.exe

; 2.exe

global _start
global main
extern printf
extern scanf
extern exit
extern gets

section .bss
    numero:
        resd 1 ; 1 dword (4 bytes)

    contador:
        resd 1 ; 1 dword (4 bytes)
        
    cadena:
        resb 0x0100 ; 256 bytes
        
    caracter: ; 4 bytes
        resb 1 ; 1 byte (dato)
        resb 3 ; 3 bytes (relleno)

section .data
    fmtInt:
        db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
    fmtString:
        db "%s", 0 ; FORMATO PARA CADENAS
    fmtChar:
        db "%c", 0 ; FORMATO PARA CARACTERES
    fmtLF:
        db 0xA, 0 ; SALTO DE LINEA (LF)
    pedirCadenaMnsj:
        db "Ingrese una cadena de caracteres: ", 0
    espacio:
        db " ", 0
    dosPuntos:
        db ": ", 0

section .text
leerCadena: ; RUTINA PARA LEER UNA CADENA USANDO GETS
    push cadena 
    call gets 
    add esp, 4 
    ret 

mostrarCadena: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
    push cadena 
    push fmtString 
    call printf 
    add esp, 8 
    ret

mostrarCaracter: ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
    push dword [caracter] 
    push fmtChar 
    call printf 
    add esp, 8 
    ret

mostrarCadenaPedirCadenaMnsj:
    push pedirCadenaMnsj
    push fmtString 
    call printf 
    add esp, 8 
    ret

mostrarCadenaEspcaio:
    push espacio
    push fmtString 
    call printf 
    add esp, 8 
    ret

mostrarCadenaDosPuntos:
    push dosPuntos
    push fmtString 
    call printf 
    add esp, 8 
    ret


salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
    push 0
    call exit

siguienteCaracter:
    call mostrarCadena
    call mostrarCadenaDosPuntos

    mov edi, 0
    for:
        mov eax, dword[edi + cadena]
        mov [caracter], al

        call mostrarCaracter

        mov al, [caracter] ; si es el fin de la cadena
        cmp al, 0
        je siguienteCadena

        jmp siguienteIteracion

        siguienteCadena:
            mov eax, edi
            mov ecx, 2
            mov edx, 0
            div ecx
            cmp edx, 0 ; if edx != 0 esta en la vuelta impar
            jne salir

            mov edi, 1 ; contador = 1 ; impares

            jmp for
        
        siguienteIteracion:
            add edi, 2

            jmp for

        salir:
            call salirDelPrograma

main:
_start:
    call mostrarCadenaPedirCadenaMnsj
    call leerCadena

    call siguienteCaracter