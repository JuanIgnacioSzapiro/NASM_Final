; Se ingresan 100 caracteres. La computadora los muestra ordenados sin repeticiones.

; "D:\NASM\nasm.exe" -f win32 5.asm --PREFIX _

; gcc.exe 5.obj -o 5.exe

; 5.exe


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

contadorCantCaract:
    resd 1 ; 1 dword (4 bytes)

contadorRecorrer:
    resd 1 ; 1 dword (4 bytes)

caracter:
    resb 1 ; 1 byte (dato)
    resb 3 ; 3 bytes (relleno)

arrayCaracteres: ; == String
    resb 75 ; 25 dword * 3 bytes (relleno)

cadena:
    resb 0x0100 ; 256 bytes

section .data
fmtInt:
    db "%d", 0 ; FORMATO PARA NUMEROS ENTEROS
fmtString:
    db "%s", 0 ; FORMATO PARA CADENAS
fmtChar:
    db "%c", 0 ; FORMATO PARA CARACTERES
fmtLF:
    db 0xA, 0 ; SALTO DE LINEA (LF)
pedirCaracter:
    db "Ingrese el caracter [", 0
terminarPedirCaracter:
    db "]: ", 0

section .text
leerCadena: ; RUTINA PARA LEER UNA CADENA USANDO GETS
    push cadena 
    call gets 
    add esp, 4 
    ret 

mostrarSaltoDeLinea: ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
    push fmtLF 
    call printf
    add esp, 4 
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
mostrarCadena: ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
    push cadena 
    push fmtString 
    call printf 
    add esp, 8 
    ret
salirDelPrograma: ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
    push 0
    call exit

mostrarPedirCaracter:
    push pedirCaracter ; print ( "Ingrese el caracter [" )
    push fmtString
    call printf
    add esp, 8 
    ret 

mostrarTerminarPedirCaracter:
    push terminarPedirCaracter ; print ( "]: " )
    push fmtString 
    call printf
    add esp, 8 
    ret 

mostrarContadorCantCaract:
    push dword [contadorCantCaract]
    push fmtInt 
    call printf
    add esp, 8
    ret


mostrarContadorRecorrer:
    push dword [contadorRecorrer]
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

mostrarMnsj:
    call mostrarPedirCaracter
    call mostrarContadorCantCaract
    call mostrarTerminarPedirCaracter
    call mostrarSaltoDeLinea
    ret

llevarCuenta:
    mov eax, 5 ; if ( contadorCantCaract > 100 )
    cmp [contadorCantCaract], eax
    jg terminar

    call siguienteIteracion

    call incrementarContadorCantCaract
    ret

incrementarContadorCantCaract:
    mov ecx, 0 ; contadorRecorrer = 0
    mov [contadorRecorrer], ecx

    mov ecx, [contadorCantCaract] ; contadorCantCaract++
    add ecx, 1
    mov [contadorCantCaract], ecx

    jmp llevarCuenta
    ret


siguienteIteracion:
    call mostrarMnsj
    call leerCadena
    call armarArrayCaracteres
    ret

armarArrayCaracteres:
    mov al, byte dword[cadena + 0]
    cmp al, 0
    je siguienteIteracion

    mov ecx, 0
    mov al, byte [cadena + ecx] ; se lo saca de cadena porque solo quiero el primer caracter y si la entrada aceptaba un solo char corria riesgo de crasheo

    mov [caracter], al
    
    cmp eax, 0
    je incrementarContadorCantCaract

    call corroborarInexistencia

    ret

corroborarInexistencia:
    mov ecx, [contadorRecorrer]
    mov eax, dword[arrayCaracteres + ecx]
    cmp eax, 0
    je noExiste

    mov ecx, [contadorRecorrer]
    mov al, [caracter]
    cmp al, byte [arrayCaracteres + ecx] ; para comparar los bytes
    je yaExiste

    jmp incrementarContadorRecorrer
    ret

noExiste:
    mov ecx, 0 ; contadorRecorrer = 0
    mov [contadorRecorrer], ecx

    call encontrarPosicionCorrespondiente

    jmp incrementarContadorCantCaract

    ret

yaExiste:
    jmp incrementarContadorCantCaract

    ret

incrementarContadorRecorrer:
    mov ecx, [contadorRecorrer]
    add ecx, 1
    mov [contadorRecorrer], ecx

    jmp corroborarInexistencia
    ret

encontrarPosicionCorrespondiente:
    mov ecx, [contadorRecorrer] ; if ( byte [arrayCaracteres + ecx] == null )
    mov al, byte dword[arrayCaracteres + ecx]
    cmp al, 0
    je ubicar

    mov ecx, [contadorRecorrer] ; if ( caracter < byte [arrayCaracteres + ecx])
    mov al, [caracter]
    cmp al, byte dword [arrayCaracteres + ecx]
    jb empujar

    mov ecx, [contadorRecorrer]
    add ecx, 1
    mov [contadorRecorrer], ecx

    call encontrarPosicionCorrespondiente

    ret

empujar:
    mov ecx, [contadorRecorrer]
    buscarUltimo:        
        add ecx, 1
        mov al, byte dword[arrayCaracteres + ecx]
        cmp al, 0
        jne buscarUltimo

    mov [numero], ecx ; para saber cuando parar
    mov edx, [numero]
    add edx, 1

    guardarEnPila:
        cmp ecx, [contadorRecorrer]
        je preUbicar

        sub ecx, 1

        mov eax, dword[arrayCaracteres + ecx]
        push eax

        jmp guardarEnPila

    preUbicar:
        mov ecx, [contadorRecorrer]
        
        mov al, [caracter]
        mov byte dword[arrayCaracteres + ecx], al

        add ecx, 1

    ubicarTodo:
        mov edx, [numero]
        add edx, 1
        cmp ecx, edx
        je incrementarContadorCantCaract

        pop eax
        mov byte dword[arrayCaracteres + ecx], al

        add ecx, 1
        jmp ubicarTodo
    ret
    
ubicar:
    mov ecx, [contadorRecorrer]
    mov eax, [caracter]
    mov [arrayCaracteres + ecx], eax
    jmp incrementarContadorCantCaract
    ret

inicializar:
    mov eax, 1
    mov [contadorCantCaract], eax
    mov eax, 0
    mov [contadorRecorrer], eax
    ret

terminar:
    call mostrarArrayCaracteres
    call salirDelPrograma
    ret

main:
_start:
    call inicializar
    call llevarCuenta