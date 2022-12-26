; CoolQ Assembly SDK
; MIT License
; Copyright (c) 2020 frc
; https://github.com/frc123/CoolQ-Assembly-SDK
; Documentation: https://github.com/frc123/CoolQ-Assembly-SDK/wiki

include		<CQP.inc>
includelib	<CQP.lib>

GROUPSTRUCT 			STRUCT
	dwGroupIDHigh		DWORD		?		;群号高32位
	dwGroupIDLow		DWORD		?		;群号低32位
	lpGroupName			DWORD		?		;指向群名的指针
GROUPSTRUCT 			ENDS

GROUPMEMBERSTRUCT 		STRUCT
	dwGroupIDHigh		DWORD		?		;群号高32位
	dwGroupIDLow		DWORD		?		;群号低32位
	dwQQIDHigh			DWORD		?		;账号（QQ号）高32位
	dwQQIDLow			DWORD		?		;账号（QQ号）低32位
	lpQQName			DWORD		?		;指向昵称的指针
	lpGroupCard			DWORD		?		;指向群名片的指针
	dwGender			DWORD		?		;0/男 1/女
	dwAge				DWORD		?		;年龄
	lpRegion			DWORD		?		;地区
	dwJoinTime			DWORD		?		;入群时间（时间戳）
	dwLastTime			DWORD		?		;最后发言时间（时间戳）
	lpTitle				DWORD		?		;指向头衔_名称的指针
	dwAdmin				DWORD		?		;管理权限：1/群员 2/管理员 3/群主
	dwBadRecord			DWORD		?		;不良记录：1/TRUE
	lpExcluTitle		DWORD		?		;指向专属头衔的指针
	dwExcluTitleExp		DWORD		?		;专属头衔有效期：-1/永久
	dwAllowModCard		DWORD		?		;允许修改群名片：1/TRUE
GROUPMEMBERSTRUCT 		ENDS

_retrieveListMemberCallback		typedef proto	lpListMember:dword
RETRIEVELISTMEMBERCALLBACK		typedef ptr _retrieveListMemberCallback
INTERRUPT_RETRIEVE_LIST			equ		1	;检索列表的回调函数中用于终止检索（打断）

		.data?
szBuffer		db	512 dup (?)				;一个512字节的临时缓存区
hProcessHeap	dd	?						;默认堆的句柄
		.data
dwAuthCode		dd	-1						;AuthCode
		.const
szAppinfo		db	'9,%s',0				;[请不要修改]Appinfo

		.code
include		<init.asm>
include		<tool.asm>
include		<CQ_unpack.asm>

_CQ_getGroupList			proc		uses esi ecx		,lpCallback
		local	@lpszGroupListEncode:dword
		local	@lpGroupListDecode:dword
		local	@stGroupStruct:GROUPSTRUCT
		local	@lpCallback:RETRIEVELISTMEMBERCALLBACK
		push	lpCallback
		pop		@lpCallback
		;Call CQP.dll
		invoke	CQ_getGroupList,dwAuthCode							;Get group list data (packed/base64 encode)
		mov		@lpszGroupListEncode,eax
		;Base64 Decode
		invoke	_base64Decode,@lpszGroupListEncode
		.if		eax
		mov		@lpGroupListDecode,eax
		.else
		ret
		.endif
		;Unpack data
		invoke	_stringToInt32,@lpGroupListDecode					;Get group list sizes
		mov		ecx,eax
		mov		esi,@lpGroupListDecode
		add		esi,4
	@@:	push	ecx
		invoke	_CQ_unpackSingleGroupFromList,esi,addr @stGroupStruct				;Unpack single group data
		add		esi,eax
		invoke	@lpCallback,addr @stGroupStruct						;CallBack
		push	eax
		invoke	_processHeapFree,@stGroupStruct.lpGroupName			;Free @stGroupStruct.lpGroupName
		pop		eax
		pop		ecx
		cmp		eax,INTERRUPT_RETRIEVE_LIST
		je		@F
		loop	@B
	@@:	invoke	_processHeapFree,@lpGroupListDecode					;Free @lpGroupListDecode
		invoke	_processHeapFree,@lpszGroupListEncode				;Free @lpszGroupListEncode
		mov		eax,1
		ret
_CQ_getGroupList			endp

_CQ_getGroupMemberInfo		proc		,dwGroupIDLow,dwGroupIDHigh,dwQQIDLow,dwQQIDHigh,lpstGroupMemberStruct,dwDoNotUseBuffer
		local	@lpszMemberInfoEncode:dword
		local	@lpMemberInfoDecode:dword
		;Call CQP.dll
		invoke	CQ_getGroupMemberInfoV2,dwAuthCode,885904258,0,2093003592,0,dwDoNotUseBuffer		;Get group list data (packed/base64 encode)
		mov		@lpszMemberInfoEncode,eax
		;Base64 Decode
		invoke	_base64Decode,@lpszMemberInfoEncode
		.if		eax
		mov		@lpMemberInfoDecode,eax
		.else
		ret
		.endif
		;Unpack data
		invoke	_CQ_unpackGroupMemberInfo,@lpMemberInfoDecode,lpstGroupMemberStruct
		invoke	_processHeapFree,@lpMemberInfoDecode										;Free @lpMemberInfoDecode
		invoke	_processHeapFree,@lpszMemberInfoEncode										;Free @lpszMemberInfoEncode		
		mov		eax,1
		ret
_CQ_getGroupMemberInfo		endp

_CQ_getGroupMemberList		proc		uses esi ecx		,dwGroupIDLow,dwGroupIDHigh,lpCallback
		local	@lpszGroupMemberListEncode:dword
		local	@lpGroupMemberListDecode:dword
		local	@stGroupMemberStruct:GROUPMEMBERSTRUCT
		local	@lpCallback:RETRIEVELISTMEMBERCALLBACK
		push	lpCallback
		pop		@lpCallback
		;Call CQP.dll
		invoke	CQ_getGroupMemberList,dwAuthCode,dwGroupIDLow,dwGroupIDHigh							;Get group member list data (packed/base64 encode)
		mov		@lpszGroupMemberListEncode,eax
		;Base64 Decode
		invoke	_base64Decode,@lpszGroupMemberListEncode
		.if		eax
		mov		@lpGroupMemberListDecode,eax
		.else
		ret
		.endif
		;Unpack data
		invoke	_stringToInt32,@lpGroupMemberListDecode					;Get group member list sizes
		mov		ecx,eax
		mov		esi,@lpGroupMemberListDecode
		add		esi,4
	@@:	push	ecx
		invoke	_CQ_unpackSingleGroupMemberFromList,esi,addr @stGroupMemberStruct		;Unpack single group data
		add		esi,eax
		invoke	@lpCallback,addr @stGroupMemberStruct						;CallBack
		push	eax
		invoke	_processHeapFree,@stGroupMemberStruct.lpQQName			;Free @stGroupMemberStruct.*
		invoke	_processHeapFree,@stGroupMemberStruct.lpGroupCard
		invoke	_processHeapFree,@stGroupMemberStruct.lpRegion
		invoke	_processHeapFree,@stGroupMemberStruct.lpTitle
		invoke	_processHeapFree,@stGroupMemberStruct.lpExcluTitle
		pop		eax
		pop		ecx
		cmp		eax,INTERRUPT_RETRIEVE_LIST
		je		@F
		loop	@B
	@@:	invoke	_processHeapFree,@lpGroupMemberListDecode			;Free @lpGroupMemberListDecode
		invoke	_processHeapFree,@lpszGroupMemberListEncode				;Free @lpszGroupMemberListEncode
		mov		eax,1
		ret
_CQ_getGroupMemberList		endp
