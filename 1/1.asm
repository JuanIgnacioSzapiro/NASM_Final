; Dado un entero N, la computadora lo muestra descompuesto en sus factores primos. Ej: 132 = 2 × 2 × 3 × 11

; "D:\NASM\nasm.exe" -f win32 1.asm --PREFIX _

; gcc.exe 1.obj -o 1.exe

; 1.exe

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

    numeroIngresado:
        resd 1 ; 1 dword (4 bytes)

    contadorDivisores:
        resd 1 ; 1 dword (4 bytes)

    resultado:
        resd 1 ; 1 dword (4 bytes)

    resultadoLocal:
        resd 1 ; 1 dword (4 bytes)
    
    resto:
        resd 1 ; 1 dword (4 bytes)

    numeroPorAnalizar:
        resd 1 ; 1 dword (4 bytes)

    contador:
        resd 1 ; 1 dword (4 bytes)

    contadorLocal:
        resd 1 ; 1 dword (4 bytes)

    cadena:
        resb 0x0100 ; 256 bytes

section .data
    fmtInt:
        db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
    fmtString:
        db "%s", 0 ; FORMATO PARA CADENAS
    fmtLF:
        db 0xA, 0 ; SALTO DE LINEA (LF)
    mnsj0:
        db "Ingresar un numero: ", 0
    mnsjIgual:
        db " = ", 0 
    mnsjMultiplicacion:
        db " x ", 0 

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
    mostrarSaltoDeLinea: ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF 
        call printf
        add esp, 4 
        ret

    salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

    mostrarIgual:
        mov esi, 0 ; print ( " = " )
        mov ebx, 0
        imprimirmnsjIgual:
            mov eax, [ebx+mnsjIgual] 
            mov [ebx+cadena], eax
            inc ebx
            cmp eax, 0
            jne imprimirmnsjIgual 
            call mostrarCadena
        ret
        
    mostrarMultiplicacion:
        mov esi, 0 ; print ( " x " )
        mov ebx, 0
        imprimirmnsjMultiplicacion:
            mov eax, [ebx+mnsjMultiplicacion] 
            mov [ebx+cadena], eax
            inc ebx
            cmp eax, 0
            jne imprimirmnsjMultiplicacion
            call mostrarCadena
        ret

    saberSiPrimo:
        mov eax, 1
        mov [contadorLocal], eax ; contadorDivisores = 1 ; NO SE PUEDE DIVIDIR POR CERO
        mov eax, 0
        mov [contadorDivisores], eax

        bucle_0:
            mov eax, [contadorLocal]
            cmp eax, [numeroPorAnalizar]
            ja terminaSaberSiPrimo ; if contadorLocal > numeroPorAnalizar

            ; if contadorLocal <= numeroPorAnalizar
            mov ecx, [contadorLocal]
            mov eax, [numeroPorAnalizar]
            mov edx, 0
            div ecx ; numeroPorAnalizar / contadorLocal= eax ; resto = edx
            mov [resultadoLocal], eax
            mov [resto], edx

            mov eax, 0
            cmp [resto], eax ;
            jne siguienteIteracionBucle_0 ; if resto !=0

            ; if resto == 0
            mov eax, [contadorDivisores] 
            add eax, 1
            mov [contadorDivisores], eax ; contadorDivisores++

            siguienteIteracionBucle_0:
                mov eax, [contadorLocal]
                add eax, 1
                mov [contadorLocal], eax ; contadorLocal++

                jmp bucle_0

        terminaSaberSiPrimo:
        ret

    mostrarFactoresPrimos:
        mov eax, 2
        mov [contador], eax ; contadorDivisores = 2 ; NO SE PUEDE DIVIDIR POR CERO porque es absurdo matematico ni por 1 porque generaría un bucle infinito
        
        bucle_1:
            mov eax, [contador]
            cmp eax, [numeroPorAnalizar]
            ja terminarMostrarFactoresPrimos ; if contador > numeroPorAnalizar

            ; if contador <= numeroPorAnalizar
            mov eax, [numeroPorAnalizar]
            mov ecx, [contador]            
            mov edx, 0
            div ecx ; numeroPorAnalizar / contador = eax ; resto = edx
            mov [resultado], eax
            mov [resto], edx

            mov eax, 0
            cmp [resto], eax ;
            jne siguienteIteracionBucle_1 ; if resto !=0

            ; if resto == 0 ; contador es divisor
            mov eax, [contador]
            mov [numeroPorAnalizar], eax
            call saberSiPrimo
            mov eax, 2
            cmp [contadorDivisores], eax
            jne siguienteIteracionBucle_1 ; if contadorDivisores != 2

            ; if contadorDivisores == 2 ; contador es primo
            mov eax, [contador]
            mov [numero], eax
            call mostrarNumero ; print ( contador )

            call mostrarMultiplicacion

            mov eax, [resultado]
            mov [numeroPorAnalizar], eax
            
            ; DEBUG /*
            ; call mostrarSaltoDeLinea

            ; mov eax, [resultado]
            ; mov [numero], eax
            ; call mostrarNumero ; print ( resultado )

            ; call mostrarSaltoDeLinea
            ; */

            jmp mostrarFactoresPrimos

            siguienteIteracionBucle_1:
                mov eax, [contador]
                add eax, 1
                mov [contador], eax ; contador++

                jmp bucle_1

        terminarMostrarFactoresPrimos:
            mov eax, 1
            mov [numero], eax
            call mostrarNumero ; print ( "1" )
        ret

main:
_start:
    mov esi, 0 ; printf ( "Ingresar un numero: " )
    mov ebx, 0 
    imprimirmnsj0:
        mov eax, [ebx+mnsj0] 
        mov [ebx+cadena], eax
        inc ebx
        cmp eax, 0
        jne imprimirmnsj0 
        call mostrarCadena

    call leerNumero ; numero = scanf ( )

    mov eax, [numero]
    mov [numeroIngresado], eax ; numeroIngresado = numero

    mov eax, [numeroIngresado]
    mov [numeroPorAnalizar], eax ; numeroPorAnalizar = numeroIngresado

    mov eax, [numeroIngresado]
    mov [numero], eax
    call mostrarNumero

    call mostrarIgual

    call mostrarFactoresPrimos

    call salirDelPrograma