; CoolQ Assembly SDK
; MIT License
; Copyright (c) 2020 frc
; https://github.com/frc123/CoolQ-Assembly-SDK
; Documentation: https://github.com/frc123/CoolQ-Assembly-SDK/wiki

EVENT_IGNORE	equ		0
EVENT_BLOCK		equ		1

REQUEST_ALLOW	equ		1			;用于CQ_setFriendAddRequest/CQ_setGroupAddRequestV2
REQUEST_DENY	equ		2			;用于CQ_setFriendAddRequest/CQ_setGroupAddRequestV2

REQUEST_GROUPADD		equ		1	;用于CQ_setGroupAddRequestV2
REQUEST_GROUPINVITE		equ		2	;用于CQ_setGroupAddRequestV2

CQLOG_DEBUG		equ		0
CQLOG_INFO		equ		10
CQLOG_INFOSUCCESS		equ		11
CQLOG_INFORECV	equ		12
CQLOG_INFOSEND	equ		13
CQLOG_WARNING	equ		20
CQLOG_ERROR		equ		30
CQLOG_FATAL		equ		40


CQ_sendPrivateMsg	proto	:dword,:dword,:dword,:dword
CQ_sendGroupMsg		proto	:dword,:dword,:dword,:dword
CQ_sendDiscussMsg	proto	:dword,:dword,:dword,:dword
CQ_deleteMsg		proto	:dword,:dword,:dword
CQ_sendLikeV2		proto	:dword,:dword,:dword,:dword
CQ_getCookies		proto	:dword							;NIES
;CQ_getCookiesV2		proto	:dword,:dword
CQ_getRecord		proto	:dword,:dword,:dword			;NIES
;CQ_getRecordV2		proto	:dword,:dword,:dword
;CQ_getImage			proto	:dword,:dword				
;CQ_canSendImage		proto	:dword						
;CQ_canSendRecord	proto	:dword							
CQ_getCsrfToken		proto	:dword
CQ_getAppDirectory	proto	:dword
CQ_getLoginQQ		proto	:dword
CQ_getLoginNick		proto	:dword
CQ_setGroupKick		proto	:dword,:dword,:dword,:dword,:dword,:dword
CQ_setGroupBan		proto	:dword,:dword,:dword,:dword,:dword,:dword,:dword
CQ_setGroupAdmin	proto	:dword,:dword,:dword,:dword,:dword,:dword
CQ_setGroupSpecialTitle		proto	:dword,:dword,:dword,:dword,:dword,:dword,:dword,:dword
CQ_setGroupWholeBan			proto	:dword,:dword,:dword,:dword
CQ_setGroupAnonymousBan		proto	:dword,:dword,:dword,:dword,:dword,:dword
CQ_setGroupAnonymous		proto	:dword,:dword,:dword,:dword
CQ_setGroupCard				proto	:dword,:dword,:dword,:dword,:dword,:dword
CQ_setGroupLeave			proto	:dword,:dword,:dword,:dword
CQ_setDiscussLeave			proto	:dword,:dword,:dword
CQ_setFriendAddRequest		proto	:dword,:dword,:dword,:dword
CQ_setGroupAddRequestV2		proto	:dword,:dword,:dword,:dword,:dword
CQ_addLog					proto	:dword,:dword,:dword,:dword
CQ_setFatal					proto	:dword,:dword
CQ_getGroupMemberInfoV2		proto	:dword,:dword,:dword,:dword,:dword,:dword
CQ_getGroupMemberList		proto	:dword,:dword,:dword
CQ_getGroupList				proto	:dword
;CQ_getFriendList			proto	:dword,:dword
CQ_getStrangerInfo			proto	:dword,:dword,:dword,:dword
;CQ_getGroupInfo				proto	:dword,:dword,:dword,:dword

