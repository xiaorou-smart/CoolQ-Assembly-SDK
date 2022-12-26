; CoolQ Assembly SDK
; MIT License
; Copyright (c) 2020 frc
; https://github.com/frc123/CoolQ-Assembly-SDK
; Documentation: https://github.com/frc123/CoolQ-Assembly-SDK/wiki

DllEntry	proc	_hInstance,_dwReason,_dwReserved
		invoke	GetProcessHeap
		mov		hProcessHeap,eax
		mov		eax,TRUE
		ret
DllEntry	Endp

AppInfo		proc
		invoke	wsprintf,addr szBuffer,addr szAppinfo,addr szAppID
		mov		eax,offset szBuffer
		ret
AppInfo		endp

Initialize	proc	,dwParaAuthCode
		push	dwParaAuthCode
		pop		dwAuthCode
		xor		eax,eax
		ret		
Initialize	endp
