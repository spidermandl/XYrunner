-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
local common_pb = require("common_pb")
module('charinfo_pb')


local REGISTERREQUEST = protobuf.Descriptor();
local REGISTERREQUEST_MSGTYPE = protobuf.EnumDescriptor();
local REGISTERREQUEST_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local REGISTERREQUEST_AUTHKEY_FIELD = protobuf.FieldDescriptor();
local REGISTERRESPONSE = protobuf.Descriptor();
local REGISTERRESPONSE_MSGTYPE = protobuf.EnumDescriptor();
local REGISTERRESPONSE_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local REGISTERRESPONSE_RESULT = protobuf.EnumDescriptor();
local REGISTERRESPONSE_RESULT_E_FAILED_ENUM = protobuf.EnumValueDescriptor();
local REGISTERRESPONSE_RESULT_E_SUCCESS_ENUM = protobuf.EnumValueDescriptor();
local REGISTERRESPONSE_RESULT_E_USER_EXIST_ENUM = protobuf.EnumValueDescriptor();
local REGISTERRESPONSE_RESULT_FIELD = protobuf.FieldDescriptor();
local GETCHARINFOREQUEST = protobuf.Descriptor();
local GETCHARINFOREQUEST_MSGTYPE = protobuf.EnumDescriptor();
local GETCHARINFOREQUEST_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local GETCHARINFOREQUEST_AUTHKEY_FIELD = protobuf.FieldDescriptor();
local GETCHARINFORESPONSE = protobuf.Descriptor();
local GETCHARINFORESPONSE_MSGTYPE = protobuf.EnumDescriptor();
local GETCHARINFORESPONSE_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local GETCHARINFORESPONSE_RESULT = protobuf.EnumDescriptor();
local GETCHARINFORESPONSE_RESULT_E_FAILED_ENUM = protobuf.EnumValueDescriptor();
local GETCHARINFORESPONSE_RESULT_E_SUCCESS_ENUM = protobuf.EnumValueDescriptor();
local GETCHARINFORESPONSE_RESULT_E_USER_NOT_EXIST_ENUM = protobuf.EnumValueDescriptor();
local GETCHARINFORESPONSE_CHARINFO_FIELD = protobuf.FieldDescriptor();
local GETCHARINFORESPONSE_RESULT_FIELD = protobuf.FieldDescriptor();

REGISTERREQUEST_MSGTYPE_ID_ENUM.name = "ID"
REGISTERREQUEST_MSGTYPE_ID_ENUM.index = 0
REGISTERREQUEST_MSGTYPE_ID_ENUM.number = 51
REGISTERREQUEST_MSGTYPE.name = "MSGTYPE"
REGISTERREQUEST_MSGTYPE.full_name = ".protocols.RegisterRequest.MSGTYPE"
REGISTERREQUEST_MSGTYPE.values = {REGISTERREQUEST_MSGTYPE_ID_ENUM}
REGISTERREQUEST_AUTHKEY_FIELD.name = "authkey"
REGISTERREQUEST_AUTHKEY_FIELD.full_name = ".protocols.RegisterRequest.authkey"
REGISTERREQUEST_AUTHKEY_FIELD.number = 1
REGISTERREQUEST_AUTHKEY_FIELD.index = 0
REGISTERREQUEST_AUTHKEY_FIELD.label = 1
REGISTERREQUEST_AUTHKEY_FIELD.has_default_value = false
REGISTERREQUEST_AUTHKEY_FIELD.default_value = ""
REGISTERREQUEST_AUTHKEY_FIELD.type = 9
REGISTERREQUEST_AUTHKEY_FIELD.cpp_type = 9

REGISTERREQUEST.name = "RegisterRequest"
REGISTERREQUEST.full_name = ".protocols.RegisterRequest"
REGISTERREQUEST.nested_types = {}
REGISTERREQUEST.enum_types = {REGISTERREQUEST_MSGTYPE}
REGISTERREQUEST.fields = {REGISTERREQUEST_AUTHKEY_FIELD}
REGISTERREQUEST.is_extendable = false
REGISTERREQUEST.extensions = {}
REGISTERRESPONSE_MSGTYPE_ID_ENUM.name = "ID"
REGISTERRESPONSE_MSGTYPE_ID_ENUM.index = 0
REGISTERRESPONSE_MSGTYPE_ID_ENUM.number = 52
REGISTERRESPONSE_MSGTYPE.name = "MSGTYPE"
REGISTERRESPONSE_MSGTYPE.full_name = ".protocols.RegisterResponse.MSGTYPE"
REGISTERRESPONSE_MSGTYPE.values = {REGISTERRESPONSE_MSGTYPE_ID_ENUM}
REGISTERRESPONSE_RESULT_E_FAILED_ENUM.name = "E_FAILED"
REGISTERRESPONSE_RESULT_E_FAILED_ENUM.index = 0
REGISTERRESPONSE_RESULT_E_FAILED_ENUM.number = 0
REGISTERRESPONSE_RESULT_E_SUCCESS_ENUM.name = "E_SUCCESS"
REGISTERRESPONSE_RESULT_E_SUCCESS_ENUM.index = 1
REGISTERRESPONSE_RESULT_E_SUCCESS_ENUM.number = 1
REGISTERRESPONSE_RESULT_E_USER_EXIST_ENUM.name = "E_USER_EXIST"
REGISTERRESPONSE_RESULT_E_USER_EXIST_ENUM.index = 2
REGISTERRESPONSE_RESULT_E_USER_EXIST_ENUM.number = 2
REGISTERRESPONSE_RESULT.name = "RESULT"
REGISTERRESPONSE_RESULT.full_name = ".protocols.RegisterResponse.RESULT"
REGISTERRESPONSE_RESULT.values = {REGISTERRESPONSE_RESULT_E_FAILED_ENUM,REGISTERRESPONSE_RESULT_E_SUCCESS_ENUM,REGISTERRESPONSE_RESULT_E_USER_EXIST_ENUM}
REGISTERRESPONSE_RESULT_FIELD.name = "result"
REGISTERRESPONSE_RESULT_FIELD.full_name = ".protocols.RegisterResponse.result"
REGISTERRESPONSE_RESULT_FIELD.number = 1
REGISTERRESPONSE_RESULT_FIELD.index = 0
REGISTERRESPONSE_RESULT_FIELD.label = 1
REGISTERRESPONSE_RESULT_FIELD.has_default_value = false
REGISTERRESPONSE_RESULT_FIELD.default_value = nil
REGISTERRESPONSE_RESULT_FIELD.enum_type = REGISTERRESPONSE_RESULT
REGISTERRESPONSE_RESULT_FIELD.type = 14
REGISTERRESPONSE_RESULT_FIELD.cpp_type = 8

REGISTERRESPONSE.name = "RegisterResponse"
REGISTERRESPONSE.full_name = ".protocols.RegisterResponse"
REGISTERRESPONSE.nested_types = {}
REGISTERRESPONSE.enum_types = {REGISTERRESPONSE_MSGTYPE, REGISTERRESPONSE_RESULT}
REGISTERRESPONSE.fields = {REGISTERRESPONSE_RESULT_FIELD}
REGISTERRESPONSE.is_extendable = false
REGISTERRESPONSE.extensions = {}
GETCHARINFOREQUEST_MSGTYPE_ID_ENUM.name = "ID"
GETCHARINFOREQUEST_MSGTYPE_ID_ENUM.index = 0
GETCHARINFOREQUEST_MSGTYPE_ID_ENUM.number = 16000
GETCHARINFOREQUEST_MSGTYPE.name = "MSGTYPE"
GETCHARINFOREQUEST_MSGTYPE.full_name = ".protocols.GetCharInfoRequest.MSGTYPE"
GETCHARINFOREQUEST_MSGTYPE.values = {GETCHARINFOREQUEST_MSGTYPE_ID_ENUM}
GETCHARINFOREQUEST_AUTHKEY_FIELD.name = "authkey"
GETCHARINFOREQUEST_AUTHKEY_FIELD.full_name = ".protocols.GetCharInfoRequest.authkey"
GETCHARINFOREQUEST_AUTHKEY_FIELD.number = 1
GETCHARINFOREQUEST_AUTHKEY_FIELD.index = 0
GETCHARINFOREQUEST_AUTHKEY_FIELD.label = 1
GETCHARINFOREQUEST_AUTHKEY_FIELD.has_default_value = false
GETCHARINFOREQUEST_AUTHKEY_FIELD.default_value = ""
GETCHARINFOREQUEST_AUTHKEY_FIELD.type = 9
GETCHARINFOREQUEST_AUTHKEY_FIELD.cpp_type = 9

GETCHARINFOREQUEST.name = "GetCharInfoRequest"
GETCHARINFOREQUEST.full_name = ".protocols.GetCharInfoRequest"
GETCHARINFOREQUEST.nested_types = {}
GETCHARINFOREQUEST.enum_types = {GETCHARINFOREQUEST_MSGTYPE}
GETCHARINFOREQUEST.fields = {GETCHARINFOREQUEST_AUTHKEY_FIELD}
GETCHARINFOREQUEST.is_extendable = false
GETCHARINFOREQUEST.extensions = {}
GETCHARINFORESPONSE_MSGTYPE_ID_ENUM.name = "ID"
GETCHARINFORESPONSE_MSGTYPE_ID_ENUM.index = 0
GETCHARINFORESPONSE_MSGTYPE_ID_ENUM.number = 16001
GETCHARINFORESPONSE_MSGTYPE.name = "MSGTYPE"
GETCHARINFORESPONSE_MSGTYPE.full_name = ".protocols.GetCharInfoResponse.MSGTYPE"
GETCHARINFORESPONSE_MSGTYPE.values = {GETCHARINFORESPONSE_MSGTYPE_ID_ENUM}
GETCHARINFORESPONSE_RESULT_E_FAILED_ENUM.name = "E_FAILED"
GETCHARINFORESPONSE_RESULT_E_FAILED_ENUM.index = 0
GETCHARINFORESPONSE_RESULT_E_FAILED_ENUM.number = 0
GETCHARINFORESPONSE_RESULT_E_SUCCESS_ENUM.name = "E_SUCCESS"
GETCHARINFORESPONSE_RESULT_E_SUCCESS_ENUM.index = 1
GETCHARINFORESPONSE_RESULT_E_SUCCESS_ENUM.number = 1
GETCHARINFORESPONSE_RESULT_E_USER_NOT_EXIST_ENUM.name = "E_USER_NOT_EXIST"
GETCHARINFORESPONSE_RESULT_E_USER_NOT_EXIST_ENUM.index = 2
GETCHARINFORESPONSE_RESULT_E_USER_NOT_EXIST_ENUM.number = 2
GETCHARINFORESPONSE_RESULT.name = "RESULT"
GETCHARINFORESPONSE_RESULT.full_name = ".protocols.GetCharInfoResponse.RESULT"
GETCHARINFORESPONSE_RESULT.values = {GETCHARINFORESPONSE_RESULT_E_FAILED_ENUM,GETCHARINFORESPONSE_RESULT_E_SUCCESS_ENUM,GETCHARINFORESPONSE_RESULT_E_USER_NOT_EXIST_ENUM}
GETCHARINFORESPONSE_CHARINFO_FIELD.name = "charinfo"
GETCHARINFORESPONSE_CHARINFO_FIELD.full_name = ".protocols.GetCharInfoResponse.charinfo"
GETCHARINFORESPONSE_CHARINFO_FIELD.number = 1
GETCHARINFORESPONSE_CHARINFO_FIELD.index = 0
GETCHARINFORESPONSE_CHARINFO_FIELD.label = 1
GETCHARINFORESPONSE_CHARINFO_FIELD.has_default_value = false
GETCHARINFORESPONSE_CHARINFO_FIELD.default_value = nil
GETCHARINFORESPONSE_CHARINFO_FIELD.message_type = COMMON_PB_CHARINFO
GETCHARINFORESPONSE_CHARINFO_FIELD.type = 11
GETCHARINFORESPONSE_CHARINFO_FIELD.cpp_type = 10

GETCHARINFORESPONSE_RESULT_FIELD.name = "result"
GETCHARINFORESPONSE_RESULT_FIELD.full_name = ".protocols.GetCharInfoResponse.result"
GETCHARINFORESPONSE_RESULT_FIELD.number = 2
GETCHARINFORESPONSE_RESULT_FIELD.index = 1
GETCHARINFORESPONSE_RESULT_FIELD.label = 1
GETCHARINFORESPONSE_RESULT_FIELD.has_default_value = false
GETCHARINFORESPONSE_RESULT_FIELD.default_value = nil
GETCHARINFORESPONSE_RESULT_FIELD.enum_type = GETCHARINFORESPONSE_RESULT
GETCHARINFORESPONSE_RESULT_FIELD.type = 14
GETCHARINFORESPONSE_RESULT_FIELD.cpp_type = 8

GETCHARINFORESPONSE.name = "GetCharInfoResponse"
GETCHARINFORESPONSE.full_name = ".protocols.GetCharInfoResponse"
GETCHARINFORESPONSE.nested_types = {}
GETCHARINFORESPONSE.enum_types = {GETCHARINFORESPONSE_MSGTYPE, GETCHARINFORESPONSE_RESULT}
GETCHARINFORESPONSE.fields = {GETCHARINFORESPONSE_CHARINFO_FIELD, GETCHARINFORESPONSE_RESULT_FIELD}
GETCHARINFORESPONSE.is_extendable = false
GETCHARINFORESPONSE.extensions = {}

GetCharInfoRequest = protobuf.Message(GETCHARINFOREQUEST)
GetCharInfoResponse = protobuf.Message(GETCHARINFORESPONSE)
RegisterRequest = protobuf.Message(REGISTERREQUEST)
RegisterResponse = protobuf.Message(REGISTERRESPONSE)

