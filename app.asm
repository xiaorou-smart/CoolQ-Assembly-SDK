; CoolQ Assembly SDK
; MIT License
; Copyright (c) 2020 frc
; https://github.com/frc123/CoolQ-Assembly-SDK
; Documentation: https://github.com/frc123/CoolQ-Assembly-SDK/wiki

		.386
		.model flat, stdcall
		option casemap :none

include		<stdafx.inc>
		.data?
lpszAppDirectory	dd	?
		.const
szAppID 		db	'com.example.demo',0	;[请修改]应用的Appid
szMenuAMsgBox	db	'这里是menuA，在这里载入窗口，或者进行其他工作。',0
szMenuBMsgBox	db	'这里是menuB，在这里载入窗口，或者进行其他工作。',0
szCaption		db	'CoolQ Assembly SDK by 疯如初',0
szOutputGroupList			db	'GroupID:%u(low 32-bit)(Do not worry about high 32-bit unless ID which is bigger than 4294967295?? appear)',0ah,0dh
							db	'GroupName:%s',0
szOutputGroupSingleMember1	db	'GroupID:%u(low 32-bit)(Do not worry about high 32-bit unless ID which is bigger than 4294967295 appear)',0ah,0dh
							db	'QQID:%u(low 32-bit)(Do not worry about high 32-bit unless ID which is bigger than 4294967295 appear)',0ah,0dh
							db	'QQName:%s',0ah,0dh
							db	'GroupCard:%s',0ah,0dh
							db	'Gender:%d(0/Male 1/Female)',0ah,0dh
							db	'Age:%d',0ah,0dh
							db	'Region:%s',0ah,0dh
							db	'JoinTime:%d',0ah,0dh
							db	'LastTime:%d',0ah,0dh
							db	'Title:%s',0ah,0dh
							db	'Admin:%d(1/Member 2/Admin 3/Master)',0ah,0dh
							db	'BadRecord:%d(1/TRUE)',0ah,0dh
							db	'ExcluTitle:%s',0ah,0dh
							db	'ExcluTitleExp:%d(-1/Permanent)',0
szOutputGroupSingleMember2	db	'AllowModCard:%d(1/TRUE)',0

include		<sdk.asm>

		.code

_eventStartup	proc
		invoke	CQ_getAppDirectory,dwAuthCode
		mov		lpszAppDirectory,eax
		xor		eax,eax
		ret	
_eventStartup	endp

_eventExit	proc
		xor		eax,eax
		ret
_eventExit	endp

_eventEnable	proc
		xor		eax,eax
		ret	
_eventEnable	endp

_eventDisable	proc
		xor		eax,eax
		ret
_eventDisable	endp

_eventPrivateMsg	proc	,dwSubType,dwMsgId,dwFromQQLow,dwFromQQHigh,lpszMsg,dwFont
		invoke	CQ_sendPrivateMsg,dwAuthCode,dwFromQQLow,dwFromQQHigh,lpszMsg			
		mov		eax,EVENT_IGNORE
		ret
_eventPrivateMsg	endp

_eventGroupMsg		proc	,dwSubType,dwMsgId,dwFromGroupLow,dwFromGroupHigh,dwFromQQLow,dwFromQQHigh,lpszFromAnonymous,lpszMsg,dwFont
		invoke	CQ_sendGroupMsg,dwAuthCode,dwFromGroupLow,dwFromGroupHigh,lpszMsg
		mov		eax,EVENT_IGNORE
		ret
_eventGroupMsg		endp

_eventDiscussMsg	proc	,dwSubType,dwMsgId,dwFromDiscussLow,dwFromDiscussHigh,dwFromQQLow,dwFromQQHigh,lpszMsg,dwFont
		mov		eax,EVENT_IGNORE
		ret
_eventDiscussMsg	endp


_eventGroupUpload	proc	,dwSubType,dwSendTime,dwFromGroupLow,dwFromGroupHigh,dwFromAccountLow,dwFromAccountHigh,lpFile
		mov		eax,EVENT_IGNORE
		ret
_eventGroupUpload	endp

_eventSystem_GroupAdmin		proc	,dwSubType,dwSendTime,dwFromGroupLow,dwFromGroupHigh,dwBeingOperateAccountLow,dwBeingOperateAccountHigh
		mov		eax,EVENT_IGNORE
		ret
_eventSystem_GroupAdmin		endp

_eventSystem_GroupMemberDecrease	proc	,dwSubType,dwSendTime,dwFromGroupLow,dwFromGroupHigh,dwFromAccountLow,dwFromAccountHigh,dwBeingOperateAccountLow,dwBeingOperateAccountHigh
		mov		eax,EVENT_IGNORE
		ret
_eventSystem_GroupMemberDecrease	endp

_eventSystem_GroupMemberIncrease	proc	,dwSubType,dwSendTime,dwFromGroupLow,dwFromGroupHigh,dwFromAccountLow,dwFromAccountHigh,dwBeingOperateAccountLow,dwBeingOperateAccountHigh
		mov		eax,EVENT_IGNORE
		ret
_eventSystem_GroupMemberIncrease	endp

_eventSystem_GroupBan		proc	,dwSubType,dwSendTime,dwFromGroupLow,dwFromGroupHigh,dwFromAccountLow,dwFromAccountHigh,dwBeingOperateAccountLow,dwBeingOperateAccountHigh,dwDurationLow,dwDurationHigh
		mov		eax,EVENT_IGNORE
		ret
_eventSystem_GroupBan		endp

_eventFriend_Add			proc	,dwSubType,dwSendTime,dwFromAccountLow,dwFromAccountHigh
		mov		eax,EVENT_IGNORE
		ret
_eventFriend_Add			endp

_eventRequest_AddFriend		proc	,dwSubType,dwSendTime,dwFromAccountLow,dwFromAccountHigh,lpMsg,lpResponseFlag
		mov		eax,EVENT_IGNORE
		ret
_eventRequest_AddFriend		endp

_eventRequest_AddGroup		proc	,dwSubType,dwSendTime,dwFromGroupLow,dwFromGroupHigh,dwFromAccountLow,dwFromAccountHigh,lpMsg,lpResponseFlag
		mov		eax,EVENT_IGNORE
		ret
_eventRequest_AddGroup		endp

_menuA						proc
		invoke	MessageBox,NULL,addr szMenuAMsgBox,addr szCaption,MB_OK
		xor		eax,eax
		ret
_menuA						endp

_menuB						proc
		invoke	MessageBox,NULL,addr szMenuBMsgBox,addr szCaption,MB_OK
		xor		eax,eax
		ret
_menuB						endp

;Demo1:_retrieveGroupList
_CQ_getGroupListCallback	proc	,lpstrGroupInfo					;取群列表-回调函数
		local	@stGroupStruct:GROUPSTRUCT
		invoke	_copyData,lpstrGroupInfo,12,addr @stGroupStruct
		invoke	wsprintf,addr szBuffer,addr szOutputGroupList,@stGroupStruct.dwGroupIDLow,@stGroupStruct.lpGroupName
		invoke	CQ_addLog,dwAuthCode,10,addr szCaption,addr szBuffer
		xor		eax,eax
		; mov		eax,INTERRUPT_RETRIEVE_LIST			;interrupt _CQ_getGroupList
		ret
_CQ_getGroupListCallback	endp

_retrieveGroupList			proc		uses esi ecx				;取群列表
		invoke	_CQ_getGroupList,addr _CQ_getGroupListCallback
		xor		eax,eax
		ret
_retrieveGroupList			endp

;Demo2:_retrieveGroupSingleMember
_retrieveGroupSingleMember	proc									;取群成员信息
		local	@stGroupMemberStruct:GROUPMEMBERSTRUCT
		invoke	_CQ_getGroupMemberInfo,885904258,0,2093003592,0,addr @stGroupMemberStruct,FALSE
		invoke	wsprintf,addr szBuffer,addr szOutputGroupSingleMember1,@stGroupMemberStruct.dwGroupIDLow,@stGroupMemberStruct.dwQQIDLow,@stGroupMemberStruct.lpQQName,@stGroupMemberStruct.lpGroupCard,@stGroupMemberStruct.dwGender,@stGroupMemberStruct.dwAge,@stGroupMemberStruct.lpRegion,@stGroupMemberStruct.dwJoinTime,@stGroupMemberStruct.dwLastTime,@stGroupMemberStruct.lpTitle,@stGroupMemberStruct.dwAdmin,@stGroupMemberStruct.dwBadRecord,@stGroupMemberStruct.lpExcluTitle,@stGroupMemberStruct.dwExcluTitleExp
		invoke	CQ_addLog,dwAuthCode,10,addr szCaption,addr szBuffer
		invoke	wsprintf,addr szBuffer,addr szOutputGroupSingleMember2,@stGroupMemberStruct.dwAllowModCard
		invoke	CQ_addLog,dwAuthCode,10,addr szCaption,addr szBuffer		
		invoke	_processHeapFree,@stGroupMemberStruct.lpQQName			;Free @stGroupMemberStruct.*
		invoke	_processHeapFree,@stGroupMemberStruct.lpGroupCard
		invoke	_processHeapFree,@stGroupMemberStruct.lpRegion
		invoke	_processHeapFree,@stGroupMemberStruct.lpTitle
		invoke	_processHeapFree,@stGroupMemberStruct.lpExcluTitle
		xor		eax,eax
		ret
_retrieveGroupSingleMember	endp

;Demo3:_retrieveGroupMemberList
_CQ_getGroupMemberListCallback	proc	,lpstrGroupInfo				;取群成员列表-回调函数
		local	@stGroupMemberStruct:GROUPMEMBERSTRUCT
		invoke	_copyData,lpstrGroupInfo,68,addr @stGroupMemberStruct
		invoke	wsprintf,addr szBuffer,addr szOutputGroupSingleMember1,@stGroupMemberStruct.dwGroupIDLow,@stGroupMemberStruct.dwQQIDLow,@stGroupMemberStruct.lpQQName,@stGroupMemberStruct.lpGroupCard,@stGroupMemberStruct.dwGender,@stGroupMemberStruct.dwAge,@stGroupMemberStruct.lpRegion,@stGroupMemberStruct.dwJoinTime,@stGroupMemberStruct.dwLastTime,@stGroupMemberStruct.lpTitle,@stGroupMemberStruct.dwAdmin,@stGroupMemberStruct.dwBadRecord,@stGroupMemberStruct.lpExcluTitle,@stGroupMemberStruct.dwExcluTitleExp
		invoke	CQ_addLog,dwAuthCode,10,addr szCaption,addr szBuffer
		invoke	wsprintf,addr szBuffer,addr szOutputGroupSingleMember2,@stGroupMemberStruct.dwAllowModCard
		invoke	CQ_addLog,dwAuthCode,10,addr szCaption,addr szBuffer
		xor		eax,eax
		; mov		eax,INTERRUPT_RETRIEVE_LIST			;interrupt _CQ_getGroupMemberList
		ret
_CQ_getGroupMemberListCallback	endp

_retrieveGroupMemberList	proc									;取群成员列表
		invoke	_CQ_getGroupMemberList,885904258,0,addr _CQ_getGroupMemberListCallback
		xor		eax,eax
		ret
_retrieveGroupMemberList	endp
	
		End	DllEntry
