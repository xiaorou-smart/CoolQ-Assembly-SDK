; CoolQ Assembly SDK
; MIT License
; Copyright (c) 2020 frc
; https://github.com/frc123/CoolQ-Assembly-SDK
; Documentation: https://github.com/frc123/CoolQ-Assembly-SDK/wiki

;ebx/指向输入数据	esi/指向输出数据
_CQ_unpack_getInt			proc
		invoke		_stringToInt32,ebx
		mov			[esi],eax
		add			ebx,4
		add			esi,4
		ret
_CQ_unpack_getInt			endp

;ebx/指向输入数据	esi/指向输出数据
_CQ_unpack_getLenStr		proc
		invoke		_stringToInt16,ebx			;文本-长度
		add			ebx,2
		push		eax
		invoke		_storeStrInNewMem,ebx,eax	;文本
		mov			[esi],eax
		pop			eax
		add			ebx,eax
		add			esi,4
		ret
_CQ_unpack_getLenStr		endp

_CQ_unpackGroupInfo			proc	uses ebx esi	,lpGroupInfo,lpGroupStruct
		mov			ebx,lpGroupInfo
		mov			esi,lpGroupStruct
		invoke		_CQ_unpack_getInt			;群号高32位
		invoke		_CQ_unpack_getInt			;群号低32位
		invoke		_CQ_unpack_getLenStr		;群名
		ret
_CQ_unpackGroupInfo			endp

_CQ_unpackSingleGroupFromList		proc	uses ebx	,lpSingleGroupFromList,lpGroupStruct
		mov			ebx,lpSingleGroupFromList	;指向groupInfo长度
		invoke		_stringToInt16,ebx
		push		eax							;暂存数据长度
		add			ebx,2						;指向groupInfo
		invoke		_CQ_unpackGroupInfo,ebx,lpGroupStruct
		pop			eax
		add			eax,2
		ret
_CQ_unpackSingleGroupFromList		endp

_CQ_unpackGroupMemberInfo	proc	uses ebx esi	,lpGroupMemberInfo,lpGroupMemberStruct
		mov			ebx,lpGroupMemberInfo
		mov			esi,lpGroupMemberStruct
		invoke		_CQ_unpack_getInt			;群号高32位
		invoke		_CQ_unpack_getInt			;群号低32位
		invoke		_CQ_unpack_getInt			;qq号高32位
		invoke		_CQ_unpack_getInt			;qq号低32位
		invoke		_CQ_unpack_getLenStr		;昵称
		invoke		_CQ_unpack_getLenStr		;名片
		invoke		_CQ_unpack_getInt			;性别
		invoke		_CQ_unpack_getInt			;年龄
		invoke		_CQ_unpack_getLenStr			;地区
		invoke		_CQ_unpack_getInt			;加群时间
		invoke		_CQ_unpack_getInt			;最后发言
		invoke		_CQ_unpack_getLenStr		;等级_名称
		invoke		_CQ_unpack_getInt			;管理权限
		invoke		_CQ_unpack_getInt			;不良记录成员
		invoke		_CQ_unpack_getLenStr		;专属头衔
		invoke		_CQ_unpack_getInt			;专属头衔过期时间
		invoke		_CQ_unpack_getInt			;允许修改名片
		ret
_CQ_unpackGroupMemberInfo	endp

_CQ_unpackSingleGroupMemberFromList	proc	uses ebx	,lpSingleGroupMemberFromList,lpGroupMemberStruct
		mov			ebx,lpSingleGroupMemberFromList		;指向groupMemberInfo长度
		invoke		_stringToInt16,ebx
		push		eax									;暂存数据长度
		add			ebx,2								;指向groupMemberInfo
		invoke		_CQ_unpackGroupMemberInfo,ebx,lpGroupMemberStruct
		pop			eax
		add			eax,2
		ret
_CQ_unpackSingleGroupMemberFromList	endp
