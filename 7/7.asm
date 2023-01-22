; Se ingresa una matriz de NxM componentes. La computadora la muestra girada 90° en sentido antihorario.

;test rapido

; "D:\NASM\nasm.exe" -f win32 7.asm --PREFIX _
; gcc.exe 7.obj -o 7.exe
; 7.exe
; 3
; 3
; 1
; 2
; 3
; 4
; 5
; 6
; 7
; 8
; 9


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
    cantidadFilas:
        resd 1 ; 1 dword (4 bytes)
    cantidadColumnas:
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
    pedirCantFilas:
        db "Ingresar la cantidad de filas: ", 0
    pedirCantColumnas:
        db "Ingresar la cantidad de columnas: ", 0
    fila:
        db "fila: ", 0
    columna:
        db " y la columna: ", 0
    pedirValorIngresado:
        db "Ingresar valor para la ", 0
    igualEspacio:
        db " = ", 0
    espacio:
        db " ", 0
section .text
    leerCantFilas: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push cantidadFilas
        push fmtInt 
        call scanf 
        add esp, 8 
        ret
    leerCantColumnas: ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push cantidadColumnas
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
    mostrarPedirCantFilas: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push pedirCantFilas 
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarPedirCantColumnas: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push pedirCantColumnas
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarPedirValorIngresado: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push pedirValorIngresado
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarColumna:
        push columna
        push fmtString 
        call printf 
        add esp, 8 
        ret
    mostrarFila:
        push fila
        push fmtString 
        call printf 
        add esp, 8 
        ret

    mostrarCantidadFilas:
        push dword [cantidadFilas]
        push fmtInt 
        call printf 
        add esp, 8 
        ret
    mostrarCantidadColumnas:
        push dword [cantidadColumnas]
        push fmtInt 
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
    mostrarPedirValorIngresadoCompleto:
        call mostrarPedirValorIngresado
        call mostrarFila
        call mostrarContadorFilas
        call mostrarColumna
        call mostrarContadorColumnas
        call mostrarIgualEspacio
        ret
    
    mostrarParteMatriz: ; para testeo en 'empieza'
        mov eax, [contadorFilas] ; posicion = contadorFilas * cantidadColumnas
        mov ecx, [cantidadColumnas]
        mov edx, 0
        mul ecx
        mov [posicion], eax

        mov eax, [contadorColumnas] ; posicion += contadorColumnas
        add [posicion], eax

        mov esi, [posicion]
        mov al, byte dword[esi + matriz]

        mov [valorIngresado], al

        push dword[valorIngresado] ; NO HACER: push dword[esi + matriz]
        push fmtInt 
        call printf 
        add esp, 8 
        ret
        ; /*
        ; 1 2 3   3 6 9
        ; 4 5 6   2 5 8
        ; 7 8 9   1 4 7
        ; */

    salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit

    inicializarFilas:
        mov ecx, 0
        mov [contadorFilas], ecx
        ret

    inicializarColumnas:
        mov ecx, 0
        mov [contadorColumnas], ecx
        ret
main:
_start:
    call inicializarFilas
    call inicializarColumnas

    corroborarFilas:
        call mostrarPedirCantFilas
        call leerCantFilas
        
        mov eax, 1 ; if ( cantidadFilas < eax )
        cmp [cantidadFilas], eax
        jle corroborarFilas

        mov eax, 10 ; if ( cantidadFilas > 10 )
        cmp [cantidadFilas], eax
        jg corroborarFilas

    corroborarColumnas:
        call mostrarPedirCantColumnas
        call leerCantColumnas

        mov eax, 1 ; if ( cantidadColumnas < eax )
        cmp [cantidadColumnas], eax
        jle corroborarColumnas
        call inicializarColumnas

        mov eax, 10 ; if ( cantidadColumnas > 10 )
        cmp [cantidadColumnas], eax
        jg corroborarFilas

    empieza:
        mov ecx, [contadorFilas] ; if ( contadorFilas > cantidadFilas )
        mov eax, [cantidadFilas]
        sub eax, 1
        cmp ecx, eax
        jg mostrarMatriz

        call mostrarPedirValorIngresadoCompleto
        call leerValorIngresado

        mov eax, [contadorFilas] ; posicion = contadorFilas * cantidadColumnas
        mov ecx, [cantidadColumnas]
        mov edx, 0
        mul ecx
        mov [posicion], eax

        mov eax, [contadorColumnas] ; posicion += contadorColumnas
        add [posicion], eax

        mov esi, [posicion]
        mov al, byte dword[valorIngresado]
        mov [esi + matriz], al

        mov ecx, [contadorColumnas] ; contadorColumnas++
        add ecx, 1
        mov [contadorColumnas], ecx

        mov eax, [cantidadColumnas]
        sub eax, 1
        cmp ecx, eax ; if ( contadorColumnas <= cantidadColumnas )
        jle empieza

        call inicializarColumnas ; contadorColumnas = 0

        mov ecx, [contadorFilas] ; contadorColumnas++
        add ecx, 1
        mov [contadorFilas], ecx

        jmp empieza

    mostrarMatriz:
        call inicializarFilas ; contadorFilas = 0
        mov eax, [cantidadColumnas]
        sub eax, 1
        mov [contadorColumnas], eax

        empiezaMuestra:
            mov ecx, [contadorColumnas] ; if ( contadorColumnas < 0 )
            cmp ecx, 0
            jl salirDelPrograma

            call mostrarParteMatriz
            call mostrarEspacio

            mov ecx, [contadorFilas] ; contadorFilas++
            add ecx, 1
            mov [contadorFilas], ecx

            mov ecx, [contadorFilas]
            mov eax, [cantidadFilas]
            sub eax, 1
            cmp ecx, eax ; if ( contadorFilas <= cantidadFilas )
            jle empiezaMuestra

            call mostrarSaltoDeLinea

            call inicializarFilas ; contadorFilas = 0

            mov ecx, [contadorColumnas] ; contadorColumnas++
            sub ecx, 1
            mov [contadorColumnas], ecx

            jmp empiezaMuestra