; Se ingresan 100 caracteres. La computadora los muestra ordenados sin repeticiones.

; "D:\NASM\nasm.exe" -f win32 5alt.asm --PREFIX _

; gcc.exe 5alt.obj -o 5alt.exe

; 5alt.exe

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
    cadena:
        resb 0x0100 ; 256 bytes
    caracter:
        resb 1 ; 1 byte (dato)
        resb 3 ; 3 bytes (relleno)
    indice:
        resd 1
    arrayCaracteres: ; == String
        resb 75 ; 25 dword * 3 bytes (relleno)
    indice2:
        resd 1
    contador:
        resd 1
    matriz:
        resd 100 ; matriz como maximo de 10x10
    n:
        resd 1 ; lado de la matriz (cuadrada)
    f:
        resd 1 ; fila
    c:
        resd 1 ; columna

section .data
    fmtInt:
        db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
    fmtString:
        db "%s", 0 ; FORMATO PARA CADENAS
    fmtChar:
        db "%c", 0 ; FORMATO PARA CARACTERES
    fmtLF:
        db 0xA, 0 ; SALTO DE LINEA (LF)
    nStr:
        db "N: ", 0 ; Cadena "N: "
    filaStr:
        db "Fila:", 0 ; Cadena "Fila:"
    columnaStr:
        db " Columna:", 0 ; Cadena "Columna:"
    pedirDato:
        db " Ingrese un caracter: ", 0
    

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
leerCaracter:
    call leerCadena
    mov ecx, 0
    mov al, byte dword[cadena + 0]
    mov [caracter], al
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
mostrarIndice:
    push dword [indice]
    push fmtInt 
    call printf 
    add esp, 8 
    ret
mostrarIndice2:
    push dword [indice2]
    push fmtInt 
    call printf 
    add esp, 8 
    ret
mostrarArrayCaracteres:
    push arrayCaracteres
    push fmtString
    call printf
    add esp, 8 
    ret

salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
    push 0
    call exit

mostrarPedirDato:
    push pedirDato 
    push fmtString 
    call printf 
    add esp, 8 
    ret

recorridoDeCien:
    mov eax, [indice]
    cmp eax, 5 ; Aca es el limite de numero a ingresar
    jne sigue
    
    call mostrarArrayCaracteres
    call salirDelPrograma

reiniciarIndice2:
    mov eax, 0
    mov [indice2], eax
    ret

recorridoRepetidos:
    mov eax, [indice2]
    mov ebx, [indice]
    cmp eax, ebx
    jg guardar  ; En caso de que el indice 2 sea menor o igual al indice 1, va a guardar el caracter en el string
    
    mov ecx, [indice2]
    mov al, [caracter]
    cmp al, byte [arrayCaracteres + ecx]
    je noGuardar    ; En caso de que encuentre que el caracter esté dentro del string. No va a guardar el caracter ya que se repetiria

    mov eax, [indice2]
    add eax, 1
    mov [indice2], eax
    jmp recorridoRepetidos

sigue:
    call mostrarPedirDato
    call leerCaracter
    call reiniciarIndice2
    jmp recorridoRepetidos

guardar:
    mov al, [caracter]
    mov ecx, [contador]
    mov byte dword[arrayCaracteres + ecx], al   ;Esto es un solo caracter
    mov eax, [contador]
    add eax, 1
    mov [contador], eax

noGuardar:
    mov eax, [indice]
    add eax, 1
    mov [indice], eax
    jmp recorridoDeCien

main:
_start:
    mov eax, 0
    mov [indice], eax
    mov eax, 0
    mov [indice2], eax
    mov eax, 0
    mov [contador], eax
    
    call recorridoDeCien
    