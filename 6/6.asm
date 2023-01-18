; Se ingresa N. La computadora muestra los primeros N términos de la Secuencia de Connell.

; "D:\NASM\nasm.exe" -f win32 6.asm --PREFIX _

; gcc.exe 6.obj -o 6.exe

; 6.exe

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
    cantidadTerminos:
        resd 1 ; 1 dword (4 bytes)
    contadorSecuencias:
        resd 1 ; 1 dword (4 bytes)
    contadorTerminos:
        resd 1 ; 1 dword (4 bytes)
    contadorImpresos:
        resd 1 ; 1 dword (4 bytes)
    ultimoNumero:
        resd 1 ; 1 dword (4 bytes)
        
section .data
    fmtInt:
        db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
    fmtString:
        db "%s", 0 ; FORMATO PARA CADENAS
    fmtLF:
        db 0xA, 0 ; SALTO DE LINEA (LF)
    pedirCantidadTerminos:
        db "Ingresar la cantidad de terminos de la Secuencia de Connell a mostrar: ", 0
    puntoYcoma:
        db "; ", 0
    

section .text
    leerNumero: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push cantidadTerminos
        push fmtInt 
        call scanf 
        add esp, 8 
        ret
    mostrarUltimoNumero: ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [ultimoNumero]
        push fmtInt 
        call printf 
        add esp, 8 
        ret
    mostrarSaltoDeLinea: ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF 
        call printf
        add esp, 4 
        ret

    mostrarPedirCantidadTerminos:
        push pedirCantidadTerminos 
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarPuntoYComa:
        push puntoYcoma 
        push fmtString 
        call printf 
        add esp, 8 
        ret

    salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

    inicializar:
        mov ecx, 0
        mov [contadorSecuencias], ecx
        mov ecx, 0
        mov [contadorTerminos], ecx
        mov ecx, 0
        mov [contadorImpresos], ecx
        mov ecx, 1
        mov [ultimoNumero], ecx
    ret

main:
_start:
    call inicializar
    call mostrarPedirCantidadTerminos
    call leerNumero

secuenciaConnell:
    mov ecx, [contadorSecuencias] ; if (  contadorSecuencias >  cantidadTerminos )
    cmp ecx, [cantidadTerminos]
    ja salirDelPrograma

    mov ecx, 0
    mov [contadorTerminos], ecx
    call buscarTerminoAdecuado

    mov ecx, [contadorSecuencias] ; contadorSecuencias++
    add ecx, 1
    mov [contadorSecuencias], ecx

    jmp secuenciaConnell

buscarTerminoAdecuado:
    mov ecx, [contadorTerminos]
    cmp ecx, [contadorSecuencias]
    je terminarBuscarTerminoAdecuado

    mov eax, [contadorSecuencias] ; para saber si es par
    mov ecx, 2
    mov edx, 0
    div ecx
    
    cmp edx, 0
    jne vueltaImpar

    vueltaPar:
        mov eax, [ultimoNumero] ; para saber si es par
        mov ecx, 2
        mov edx, 0
        div ecx

        cmp edx, 0
        je imprimir
        jmp noImprimir

    vueltaImpar:
        mov eax, [ultimoNumero] ; para saber si es par
        mov ecx, 2
        mov edx, 0
        div ecx

        cmp edx, 0
        jne imprimir
        jmp noImprimir

    imprimir:
        call mostrarUltimoNumero
        call mostrarPuntoYComa

        mov ecx, [contadorTerminos] ; contadorTerminos++
        add ecx, 1
        mov [contadorTerminos], ecx

        mov ecx, [contadorImpresos] ; contadorImpresos++
        add ecx, 1
        mov [contadorImpresos], ecx

        mov ecx, [contadorImpresos]
        cmp ecx, [cantidadTerminos]
        je salirDelPrograma

    noImprimir:
        mov ecx, [ultimoNumero] ; ultimoNumero++
        add ecx, 1
        mov [ultimoNumero], ecx

        jmp buscarTerminoAdecuado

    terminarBuscarTerminoAdecuado:
        ret
    ret