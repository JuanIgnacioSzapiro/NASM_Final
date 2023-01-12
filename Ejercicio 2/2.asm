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

; ingresamos nuestras funciones externas
extern printf
extern scanf

section .bss
    numero:
        resd 1 ; 1 dword (4 bytes)

    contador:
        resd 1 ; 1 dword (4 bytes)
        
    cadena:
        resb 0x0100 ; 256 bytes

    cadenaPar:
        resb 0x0100 ; 256 bytes

    cadenaImpar:
        resb 0x0100 ; 256 bytes

    cadenaIngresada:
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

section .text
leerCadena: ; RUTINA PARA LEER UNA CADENA USANDO GETS
    push cadena 
    call gets 
    add esp, 4 
    ret 

leerNumero: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
    push numero
    push fmtInt 
    call scanf 
    add esp, 8 
    ret

mostrarCadena: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
    push cadena 
    push fmtString 
    call printf 
    add esp, 8 
    ret

mostrarNumero: ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
    push dword [numero]
    push fmtInt 
    call printf 
    add esp, 8 
    ret

mostrarCaracter: ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
    push dword [caracter] 
    push fmtChar 
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

mostrarPedirCadena:
    mov esi, 0 ; print ( "Ingrese una cadena de caracteres: " )
    mov ebx, 0
    imprimirpedirCadenaMnsj:
        mov eax, [ebx+pedirCadenaMnsj] 
        mov [ebx+cadena], eax
        inc ebx
        cmp eax, 0
        jne imprimirpedirCadenaMnsj 
        call mostrarCadena
    ret

mostrarCadenasArmadas:
    mov eax, [cadenaPar]
    mov [cadena], eax
    call mostrarCadena

    call mostrarSaltoDeLinea

    mov eax, [cadenaImpar]
    mov [cadena], eax
    call mostrarCadena
    
    call salirDelPrograma

siguienteCaracter:
    mov ecx, 0
    mov [contador], ecx

    for:
        mov ecx, [contador]
        mov eax, [cadenaIngresada + ecx]
        mov [caracter], eax
        cmp eax, 0
        je salirDelPrograma
        
        mov eax, [contador]
        mov ecx, 2
        mov edx, 0
        div ecx
        cmp edx, 0
        je concatCadenaPar

        mov ecx, cadenaImpar
        mov eax, [ecx + caracter]
        mov [cadenaImpar], eax
        jmp siguienteIteracion

        concatCadenaPar:
            mov ecx, cadenaPar
            mov eax, [ecx + caracter]
            mov [cadenaPar], eax

        siguienteIteracion:
            mov ecx, [contador]
            add ecx, 1
            mov [contador], ecx
            jmp for

        call mostrarCadenasArmadas

main:
_start:
    call mostrarPedirCadena

    call leerCadena

    mov eax, [cadena]
    mov [cadenaIngresada], eax ; cadenaIngresada = cadena

    ; DEBUG input /*
    ; mov eax, [cadenaIngresada]
    ; mov [cadena], eax

    ; call mostrarCadena
    ; */

    call siguienteCaracter