; CoolQ Assembly SDK
; MIT License
; Copyright (c) 2020 frc
; https://github.com/frc123/CoolQ-Assembly-SDK
; Documentation: https://github.com/frc123/CoolQ-Assembly-SDK/wiki

;取字符串长度，不包括终止符0
_getStringLength	proc	uses edx ebx esi	,lpszData
		mov		ebx,lpszData
		xor		esi,esi
	@@:	mov		edx,[ebx+esi]
		and		edx,0ffh
		cmp		edx,0
		je		@F
		inc		esi
		jmp		@B
	@@:	mov		eax,esi
		ret			
_getStringLength	endp

_copyData		proc	uses ecx esi edi	,lpData,dwLength,lpRes		
		mov		ecx,dwLength
		mov		esi,lpData
		mov		edi,lpRes
		cld
		rep 	movsb
		ret
_copyData		endp

_stringToInt32		proc	uses edx ebx		,lpString
		mov		ebx,lpString
		mov		dl,[ebx+1]
		mov		dh,[ebx]
		shl		edx,16
		mov		dl,[ebx+3]
		mov		dh,[ebx+2]
		mov		eax,edx
		ret
_stringToInt32		endp

_stringToInt16		proc	uses edx ebx		,lpString
		mov		ebx,lpString
		mov		dl,[ebx+1]
		mov		dh,[ebx]
		and		edx,0ffffh
		mov		eax,edx
		ret
_stringToInt16		endp

_base64Decode		proc	,lpszEncodeData
		local	@dwDecodeLength:dword
		local	@lpDecodeData:dword
		invoke	CryptStringToBinaryA,lpszEncodeData,0,CRYPT_STRING_BASE64,NULL,addr @dwDecodeLength,NULL,NULL	;Get length of base64 decoded data
		invoke	HeapAlloc,hProcessHeap,HEAP_ZERO_MEMORY,@dwDecodeLength		;Allocate new memory for base64 decoded data
																			;注意：调用这个函数的主函数别忘记释放申请的内存
		.if			eax && (eax < 0c0000000h)								;Allocate successed
					mov			@lpDecodeData,eax
		.else
					xor			eax,eax										;Allocate failed
					ret
		.endif
		invoke	CryptStringToBinaryA,lpszEncodeData,0,CRYPT_STRING_BASE64,@lpDecodeData,addr @dwDecodeLength,NULL,NULL	;Get base64 decoded data
		.if			eax
		mov			eax,@lpDecodeData										;Decode successed
		.endif
		ret
_base64Decode		endp

_processHeapFree	proc	,lpMemory
		invoke	HeapFree,hProcessHeap,HEAP_NO_SERIALIZE,lpMemory
		ret
_processHeapFree	endp

;返回的是带终止符0的
_storeStrInNewMem	proc	uses edx		,lpStr,dwStrLength
		local		@lpHeap
		mov			edx,dwStrLength		;edx中放长度，不包括终止符0
		push		edx					;暂时保存edx
		add			edx,1				;edx中放长度，包括终止符0
		invoke		HeapAlloc,hProcessHeap,HEAP_ZERO_MEMORY,edx
		;注意：调用这个函数的主函数别忘记释放申请的内存
		.if			eax && (eax < 0c0000000h)
					mov			@lpHeap,eax
		.else
					xor			eax,eax
					ret
		.endif
		pop			edx					;edx中放长度，不包括终止符0
		invoke		_copyData,lpStr,edx,@lpHeap						;理论上，由于HEAP_ZERO_MEMORY，最后一个字符会自动为终止符0
		mov			eax,@lpHeap
		ret
_storeStrInNewMem	endp

_debugLoopShowByte	proc	uses ebx edx	,lpByte
		local	bOutput:byte
		local	dwShow:dword
		push	'p%'
		pop		dwShow
		mov		ebx,lpByte
	@@:	invoke	_copyData,ebx,1,addr bOutput
		mov		dl,bOutput
		and		edx,0ffh
		invoke	wsprintf,addr szBuffer,addr dwShow,edx
		invoke	MessageBox,NULL,addr szBuffer,addr szCaption,MB_OK
		inc		ebx
		jmp		@B
		ret
_debugLoopShowByte	endp
