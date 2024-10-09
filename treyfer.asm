section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_crypt

	mov ecx, dword [num_rounds]		; pun nr de runde
    xor ebx, ebx					; il fac 0
    
encrypt_round:
	mov ebx, 0  ; tine loc de indexul 'i'
	mov edx, 0  ; e 0 daca nu am terminat cuvantul(1 cand l-am term)

round_loop:
	mov al, byte [esi + ebx]	; pun in 'al' primul byte
	add al, byte [edi + ebx] 	; adun byte-ul corespuznator cheii
	movzx eax, al
	mov al, byte [sbox + eax]	; fac substitutia cu sbox
	add ebx, 1         			; cresc indexul
	cmp ebx, 8          		; daca a terminat cuv, face edx 1
	je word_finished      
	jmp update_block    		; sar peste word_finished

word_finished:
	mov ebx, 0              	; fac mod 8
	mov edx, 1					; a terminat cuvantul, deci devine 1

update_block:
	add al, byte [esi + ebx]	; adun urm byte din bloc
	rol al, 1          			; rotesc stanga
	mov byte [esi + ebx], al 	; actualizez byte de pe pozitia i (ebx)
	cmp edx, 1					; daca a term cuvantul termina pasul
	jne round_loop      		; daca n-a term cuv

	; trec la urmatorul pas
	dec ecx             ; micsorez numarul rundelor ramase
	jnz encrypt_round   ; daca nu a ajuns la 0, continui

    ;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt
	mov esi, [ebp + 8]	 ; text criptat
	mov edi, [ebp + 12]	 ; cheie

	mov ecx, dword[num_rounds]  ; nr de runde

    xor ebx, ebx			 	; fac ebx 0
    
decrypt_round:
	mov ebx, 7          ; tine loc de index (incep de la ultima pos)
	mov edx, 0

reverse_round_loop:
	mov al, byte [esi + ebx] 	; pun in 'al' byte-ul de pe pos ebx
	add al, byte [edi + ebx] 	; adun cu byte-ul corespondent cheii
	movzx eax, al
	mov al, [sbox + eax]		; aplic sbox

	mov ah, al          ; pastrez 'al' in 'ah' (ah = top)
	mov edx, ebx		; pun in edx urm pozitie pt a calcula bottom
	inc edx				; merg la urm pos
	cmp edx, 8			; daca ebx era ultima pos, edx devine prima
	je make_mode_8
	jmp calculate_diff

make_mode_8:
	mov edx, 0
	jmp calculate_diff

calculate_diff:
	ror byte [esi + edx], 1 	; rotesc la dreapta byte-ul urmator
	mov al, byte [esi + edx] 	; pun bottom in 'al'
	sub al, ah          		; fac diferenta
	mov byte [esi + edx], al	; pun rezultatul pe poz corespunzatoare

	dec ebx			; scad pozitia (indexul)
	cmp ebx, -1		; daca idexul devine -1, s-a term cuv si nu mai face loop-ul
	jne reverse_round_loop

	; trec la urmatorul pas
	dec ecx
	jne decrypt_round

	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

