; Programa plantilla.

	.data 
; VARIABLES DE ENTRADA: NO MODIFICAR ORDEN (Se puedenmodificar los valores)
a1: .float 1.1
a2: .float 2.2 
a3: .float 3.3
a4: .float 4.4

;;;;; VARIABLES DE SALIDA: NO MODIFICAR ORDEN
; m11, m12, m13, m14
; m21, m22, m23, m24
; m31, m32, m33, m34
; m41, m42, m43, m44
M:  .float 0.0, 0.0, 0.0, 0.0
	.float 0.0, 0.0, 0.0, 0.0
	.float 0.0, 0.0, 0.0, 0.0
	.float 0.0, 0.0, 0.0, 0.0

; hm1, hm2, hm3, hm4
HM: .float 0.0, 0.0, 0.0, 0.0
; vm1, vm2, vm3, vm4
VM: .float 0.0, 0.0, 0.0, 0.0
check: .float 0.0
;;;;; FIN NO MODIFICAR ORDEN
;;;;; MATRIZ TEMPORALES


	.text
; Espacio de codigo
		.global main

main: 
	lf f2, a2	; Guardamos a2 en F2
	lf f3, a3	; Guardamos a3 en F3
	

	; Vamos a hallar MF (a2,a3) los registros (f2, f3, f5, f6)
	EQF f3, f0
	BFPT fin
	; TENEMOS A2 EN F2 [0][0]
	divf f5, f2, f3 	; [0][1]
	lf f1, a1	; Guardamos a1 en F1
	multf f6, f2, f3 	; [1][1]
	lf f4, a4 	; Guardamos a4 en F4
	addf f14, f1, f4 	; Se guarda el a1 + a4.	
	multf f12, f1, f3 ; [0][0] 	; Kronecker

	EQF f2, f0
	BFPT fin
	; TENEMOS A3 EN F3 [1][0]
	

	; Vamos a hallar MF (a1, a2) los registros (f1, f2, f7, f8)

	; TENEMOS A1 EN F1 [0][0]
	
	divf f7, f1, f2 ; [0][1]
	; TENEMOS A2 EN F2 [1][0]
	multf f8, f1, f2 ; [1][1]
	multf f10, f3, f4 ; [1][1] ; MF(a3,a4)
	multf f29, f2, f6 ; Se multiplica el [0][0]*[1][1]
	; Vamos a hallar MF (a3, a4) los registros (f3, f4, f9, f10)

	; TENEMOS A3 EN F3 [0][0]
	EQF f4, f0
	BFPT fin
	divf f9, f3, f4 ; [0][1]
	; TENEMOS A4 EN F4 [1][0]
	

	; Vamos a hallar el determinante de MF (a2, a3) REGISTRO (F11)

	multf f30, f5, f3 ; Se multiplica el [0][1] * [1][0]
	multf f21, f2, f3 ; [2][0]
	subf f11, f29, f30 ; Se resta.
	multf f23, f8, f3 ; [2][2]
	EQF f11, f0
	BFPT fin

	; Vamos a hacer kronecker de MF (a1, a2) * MF (a3, a4) REGISTROS (F12 - F28)
	multf f13, f1, f9 ; [0][1]
	divf f29, f14, f11 ; Resultado.
	multf f15, f7, f3 ; [0][2]
	addi r1, r0, #4
	multf f16, f7, f9 ; [0][3]

	multf f17, f1, f4 ; [1][0]
	addi r2, r0, #4
	multf f18, f1, f10 ; [1][1]
	multf f19, f7, f4 ; [1][2]
	multf f20, f7, f10; [1][3]

	
	multf f22, f2, f9 ; [2][1]
	
	multf f24, f8, f9 ; [2][3]

	multf f25, f2, f4 ; [3][0]
	multf f26, f2, f10 ; [3][1]
	multf f27, f8, f4 ; [3][2]
	multf f28, f8, f10; [3][3] 

	;  Vamos a calcular (a1 + a4 / |MF (a2, a3)|)
	; Tenemos a1 + a4 en el registro f14
	; Tenemos |MF (a2, a3)| en el registro f11

	

	; Vamos a hallar la matriz M (Falta guardarla)
	multf f12, f12, f29 ; M[0][0]
	multf f13, f13, f29 ; M[0][1]
	sf M(r0), f12

	multf f15, f15, f29 ; M[0][2]
	sf M(r1), f13
	addi r1, r1, #4

	multf f16, F16, f29 ; M[0][3]
	sf M(r1), f15
	addi r1, r1, #4

	multf f17, f17, f29 ; M[1][0]
	sf M(r1), f16
	addi r1, r1, #4
	multf f18, f18, f29 ; M[1][1]
	sf M(r1), f17
	addi r1, r1, #4
	multf f19, f19, f29 ; M[1][2]
	sf M(r1), f18
	addi r1, r1, #4
	multf f20, f20, f29; M[1][3]
	sf M(r1), f19
	addi r1, r1, #4
	multf f21, f21, f29 ; M[2][0]
	sf M(r1), f20
	addi r1, r1, #4
	multf f22, f22, f29 ; M[2][1]
	sf M(r1), f21
	addi r1, r1, #4
	multf f23, f23, f29 ; M[2][2]
	sf M(r1), f22
	addi r1, r1, #4

	multf f24, f24, f29 ; M[2][3]
	sf M(r1), f23
	addi r1, r1, #4
	multf f25, f25, f29 ; M[3][0]
	sf M(r1), f24
	addi r1, r1, #4
	multf f26, f26, f29 ; M[3][1]
	sf M(r1), f25
	addi r1, r1, #4
	multf f27, f27, f29 ; M[3][2]
	sf M(r1), f26
	addi r1, r1, #4
	multf f28, f28, f29; M[3][3] 
	sf M(r1), f27
	addi r1, r1, #4
	; Vamos a guardarla en la variable M


	;;;; VAMOS A HALLAR VM

	multf f5, f12, f17 ; [0][0]
	addf f29, f0, f0
	sf M(r1), f28
	multf f6, f13, f18 ; [0][1]
	addf f29, f29, f5
	sf VM(r0), f5
	multf f7, f15, f19 ; [0][2]
	addf f29, f29, f6
	sf VM(r2), f6
	addi r2, r2, #4
	multf f8, f16, f20 ; [0][3]
	addf f29, f29, f7
	sf VM(r2), f7
	addi r2, r2, #4
	;;; Guardamos VM
	
	

	

	

	

	;;;;; Vamos a hallar HM
	multf f9, f21, f25 ; [0][0]
	addf f29, f29, f8
	sf VM(r2), f8
	addi r2, r2, #4
	multf f10, f22, f26; [0][1]
	addf f29, f29, f9
	sf HM(r0), f9
	addi r3, r0, #4
	multf f11, f23, f27; [0][2]
	addf f29, f29, f10
	sf VM(r3), f10
	addi r3, r3, #4
	multf f14, f24, f28; [0][3]
	addf f29, f29, f11
	sf VM(r3), f11
	addi r3, r3, #4

	;;;; Guardamos HM 

	addf f29, f29, f14
	sf VM(r3), f14
	

	

	sf check , f29
	; Finaliza la ejecucion

	fin: 
		trap 0