; Se ingresan un entero N y, a continuación, N números enteros. La computadora muestra el promedio de los números impares ingresados y la suma de los pares.

; "D:\NASM\nasm.exe" -f win32 4.asm --PREFIX _

; gcc.exe 4.obj -o 4.exe

; 4.exe

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
    numeroIngresado:
        resd 1 ; 1 dword (4 bytes)

    cantDeN:
        resd 1 ; 1 dword (4 bytes)

    sumaDePromedioDeImpares:
        resd 1 ; 1 dword (4 bytes)

    promedioDeImpares:
        resd 1 ; 1 dword (4 bytes)
    
    restoPromedioDeImpares:
        resd 1 ; 1 dword (4 bytes)

    decimalesPromedioDeImpares:
        resd 1 ; 1 dword (4 bytes) 

    cantDeNImpares:
        resd 1 ; 1 dword (4 bytes)

    sumaDePares:
        resd 1 ; 1 dword (4 bytes)
    
    contador:
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
    pedirNumero:
        db "Ingresar N, que sera la cantidad de enteros a ingresar posteriormente: ", 0
    punto:
        db "." , 0
    mnjePromedio:
        db "Promedio de impares: " , 0
    mnjeSuma:
        db "Suma de pares: " , 0

section .text
leerNumeroIngresado: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
    push numeroIngresado
    push fmtInt 
    call scanf 
    add esp, 8 
    ret

leerCantDeN: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
    push cantDeN
    push fmtInt 
    call scanf 
    add esp, 8 
    ret

mostrarSaltoDeLinea: ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
    push fmtLF 
    call printf
    add esp, 4
    ret

mostrarPedirNumero:
    push pedirNumero ; print ( "Ingresar N, que sera la cantidad de enteros a ingresar posteriormente: " )
    push fmtString 
    call printf
    add esp, 8 
    ret

mostrarPromedio:
    push dword [promedioDeImpares]
    push fmtInt 
    call printf
    add esp, 8
    ret

mostrarPunto:
    push punto
    push fmtString
    call printf
    add esp, 8
    ret

mostrarDecimalesPromedioDeImpares:
    push dword [decimalesPromedioDeImpares]
    push fmtInt
    call printf
    add esp, 8
    ret

mostrarSumaDePares:
    push dword [sumaDePares]
    push fmtInt
    call printf
    add esp, 8
    ret

mostrarMnjePromedio:
    push mnjePromedio
    push fmtString
    call printf
    add esp, 8
    ret

mostrarMnjeSuma:
    push mnjeSuma
    push fmtString
    call printf
    add esp, 8
    ret

salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
    push 0
    call exit

inicializar:
    call mostrarPedirNumero
    call leerCantDeN
    mov eax, 0 ; promedioDeImpares = 0
    mov [promedioDeImpares], eax
    mov eax, 0 ; promedioDeImpares = 0
    mov [decimalesPromedioDeImpares], eax
    mov eax, 0 ; sumaDePromedioDeImpares = 0
    mov [sumaDePromedioDeImpares], eax
    mov eax, 0 ; cantDeNImpares = 0
    mov [cantDeNImpares], eax
    mov eax, 0 ; sumaDePares = 0
    mov [sumaDePares], eax
    mov eax, 0 ; contador = 0
    mov [contador], eax
    ret

llevarCuenta:
    mov eax, [contador]
    cmp eax, [cantDeN]
    jge terminar ; if  contador >= cantDeN

    call leerNumeroIngresado

    call revisarSiPar

    sigue:
        mov eax, [contador]
        add eax, 1
        mov [contador], eax
        jmp llevarCuenta

    ret

revisarSiPar:
    mov eax, [numeroIngresado]
    mov ecx, 2
    mov edx, 0
    div ecx
    cmp edx, 0
    je calcularSumaDePares
    jmp calcularPromedioDeImpares
    ret

calcularSumaDePares:
    mov eax, [numeroIngresado]
    add [sumaDePares], eax

    jmp sigue
    ret

calcularPromedioDeImpares: ; unicamente se suman los impares
    mov eax, [numeroIngresado]
    add [sumaDePromedioDeImpares], eax

    mov eax, [cantDeNImpares]
    add eax, 1
    mov [cantDeNImpares], eax

    jmp sigue
    ret

terminarDeCalcularPromedioDeImpares: ; aca se saca el promedio, una vez finaliza el ingreso de impares
    mov ecx, [cantDeNImpares]
    cmp ecx, 0
    je noHay

    mov eax, [sumaDePromedioDeImpares]
    mov ecx, [cantDeNImpares]
    mov edx, 0
    div ecx

    mov [promedioDeImpares], eax
    mov [restoPromedioDeImpares], edx

    mov eax, [restoPromedioDeImpares] ; nunca va a haber numeros con decimales, pero es extendible
    mov ecx, 10
    mul ecx
    mov ecx, [cantDeNImpares]
    mov edx, 0
    div ecx

    mov [decimalesPromedioDeImpares], eax
    
    noHay:
    ret

terminar: ; simplemente muestra los mensajes y termina el programa
    call terminarDeCalcularPromedioDeImpares

    call mostrarMnjePromedio
    call mostrarPromedio
    call mostrarPunto
    call mostrarDecimalesPromedioDeImpares

    call mostrarSaltoDeLinea

    call mostrarMnjeSuma
    call mostrarSumaDePares

    call salirDelPrograma
    ret

main:
_start:
    call inicializar
    
    call llevarCuenta