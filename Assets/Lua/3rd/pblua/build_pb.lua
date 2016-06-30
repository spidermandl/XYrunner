-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('build_pb')


local BUILDINFO = protobuf.Descriptor();
local BUILDINFO_ID_FIELD = protobuf.FieldDescriptor();
local BUILDINFO_TID_FIELD = protobuf.FieldDescriptor();
local BUILDINFO_LEVEL_FIELD = protobuf.FieldDescriptor();
local BUILDINFO_STATUS_FIELD = protobuf.FieldDescriptor();
local BUILDINFO_DATA_FIELD = protobuf.FieldDescriptor();
local BUILDLISTREQUEST = protobuf.Descriptor();
local BUILDLISTREQUEST_MSGTYPE = protobuf.EnumDescriptor();
local BUILDLISTREQUEST_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDLISTREQUEST_MEMBERID_FIELD = protobuf.FieldDescriptor();
local BUILDLISTRESPONSE = protobuf.Descriptor();
local BUILDLISTRESPONSE_MSGTYPE = protobuf.EnumDescriptor();
local BUILDLISTRESPONSE_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDLISTRESPONSE_BIN_BUILDS_FIELD = protobuf.FieldDescriptor();
local BUILDLISTRESPONSE_MEMBERID_FIELD = protobuf.FieldDescriptor();
local BUILDUPGRADEREQUEST = protobuf.Descriptor();
local BUILDUPGRADEREQUEST_MSGTYPE = protobuf.EnumDescriptor();
local BUILDUPGRADEREQUEST_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDUPGRADEREQUEST_BUILD_ID_FIELD = protobuf.FieldDescriptor();
local BUILDUPGRADERESPONSE = protobuf.Descriptor();
local BUILDUPGRADERESPONSE_MSGTYPE = protobuf.EnumDescriptor();
local BUILDUPGRADERESPONSE_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDUPGRADERESPONSE_RESULT = protobuf.EnumDescriptor();
local BUILDUPGRADERESPONSE_RESULT_FAILED_ENUM = protobuf.EnumValueDescriptor();
local BUILDUPGRADERESPONSE_RESULT_SUCCESS_ENUM = protobuf.EnumValueDescriptor();
local BUILDUPGRADERESPONSE_RESULT_INVALID_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDUPGRADERESPONSE_RESULT_FIELD = protobuf.FieldDescriptor();
local BUILDUPGRADERESPONSE_BUILD_INFO_FIELD = protobuf.FieldDescriptor();
local BUILDGAINREQUEST = protobuf.Descriptor();
local BUILDGAINREQUEST_MSGTYPE = protobuf.EnumDescriptor();
local BUILDGAINREQUEST_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDGAINREQUEST_BUILD_ID_FIELD = protobuf.FieldDescriptor();
local BUILDGAINRESPONSE = protobuf.Descriptor();
local BUILDGAINRESPONSE_MSGTYPE = protobuf.EnumDescriptor();
local BUILDGAINRESPONSE_MSGTYPE_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDGAINRESPONSE_RESULT = protobuf.EnumDescriptor();
local BUILDGAINRESPONSE_RESULT_FAILED_ENUM = protobuf.EnumValueDescriptor();
local BUILDGAINRESPONSE_RESULT_SUCCESS_ENUM = protobuf.EnumValueDescriptor();
local BUILDGAINRESPONSE_RESULT_INVALID_ID_ENUM = protobuf.EnumValueDescriptor();
local BUILDGAINRESPONSE_RESULT_FIELD = protobuf.FieldDescriptor();
local BUILDGAINRESPONSE_GOLD_FIELD = protobuf.FieldDescriptor();

BUILDINFO_ID_FIELD.name = "id"
BUILDINFO_ID_FIELD.full_name = ".protocols.BuildInfo.id"
BUILDINFO_ID_FIELD.number = 1
BUILDINFO_ID_FIELD.index = 0
BUILDINFO_ID_FIELD.label = 1
BUILDINFO_ID_FIELD.has_default_value = false
BUILDINFO_ID_FIELD.default_value = 0
BUILDINFO_ID_FIELD.type = 5
BUILDINFO_ID_FIELD.cpp_type = 1

BUILDINFO_TID_FIELD.name = "tid"
BUILDINFO_TID_FIELD.full_name = ".protocols.BuildInfo.tid"
BUILDINFO_TID_FIELD.number = 2
BUILDINFO_TID_FIELD.index = 1
BUILDINFO_TID_FIELD.label = 1
BUILDINFO_TID_FIELD.has_default_value = false
BUILDINFO_TID_FIELD.default_value = 0
BUILDINFO_TID_FIELD.type = 5
BUILDINFO_TID_FIELD.cpp_type = 1

BUILDINFO_LEVEL_FIELD.name = "level"
BUILDINFO_LEVEL_FIELD.full_name = ".protocols.BuildInfo.level"
BUILDINFO_LEVEL_FIELD.number = 3
BUILDINFO_LEVEL_FIELD.index = 2
BUILDINFO_LEVEL_FIELD.label = 1
BUILDINFO_LEVEL_FIELD.has_default_value = false
BUILDINFO_LEVEL_FIELD.default_value = 0
BUILDINFO_LEVEL_FIELD.type = 5
BUILDINFO_LEVEL_FIELD.cpp_type = 1

BUILDINFO_STATUS_FIELD.name = "status"
BUILDINFO_STATUS_FIELD.full_name = ".protocols.BuildInfo.status"
BUILDINFO_STATUS_FIELD.number = 6
BUILDINFO_STATUS_FIELD.index = 3
BUILDINFO_STATUS_FIELD.label = 1
BUILDINFO_STATUS_FIELD.has_default_value = false
BUILDINFO_STATUS_FIELD.default_value = 0
BUILDINFO_STATUS_FIELD.type = 5
BUILDINFO_STATUS_FIELD.cpp_type = 1

BUILDINFO_DATA_FIELD.name = "data"
BUILDINFO_DATA_FIELD.full_name = ".protocols.BuildInfo.data"
BUILDINFO_DATA_FIELD.number = 7
BUILDINFO_DATA_FIELD.index = 4
BUILDINFO_DATA_FIELD.label = 1
BUILDINFO_DATA_FIELD.has_default_value = false
BUILDINFO_DATA_FIELD.default_value = 0
BUILDINFO_DATA_FIELD.type = 5
BUILDINFO_DATA_FIELD.cpp_type = 1

BUILDINFO.name = "BuildInfo"
BUILDINFO.full_name = ".protocols.BuildInfo"
BUILDINFO.nested_types = {}
BUILDINFO.enum_types = {}
BUILDINFO.fields = {BUILDINFO_ID_FIELD, BUILDINFO_TID_FIELD, BUILDINFO_LEVEL_FIELD, BUILDINFO_STATUS_FIELD, BUILDINFO_DATA_FIELD}
BUILDINFO.is_extendable = false
BUILDINFO.extensions = {}
BUILDLISTREQUEST_MSGTYPE_ID_ENUM.name = "ID"
BUILDLISTREQUEST_MSGTYPE_ID_ENUM.index = 0
BUILDLISTREQUEST_MSGTYPE_ID_ENUM.number = 23000
BUILDLISTREQUEST_MSGTYPE.name = "MSGTYPE"
BUILDLISTREQUEST_MSGTYPE.full_name = ".protocols.BuildListRequest.MSGTYPE"
BUILDLISTREQUEST_MSGTYPE.values = {BUILDLISTREQUEST_MSGTYPE_ID_ENUM}
BUILDLISTREQUEST_MEMBERID_FIELD.name = "memberid"
BUILDLISTREQUEST_MEMBERID_FIELD.full_name = ".protocols.BuildListRequest.memberid"
BUILDLISTREQUEST_MEMBERID_FIELD.number = 1
BUILDLISTREQUEST_MEMBERID_FIELD.index = 0
BUILDLISTREQUEST_MEMBERID_FIELD.label = 1
BUILDLISTREQUEST_MEMBERID_FIELD.has_default_value = false
BUILDLISTREQUEST_MEMBERID_FIELD.default_value = 0
BUILDLISTREQUEST_MEMBERID_FIELD.type = 5
BUILDLISTREQUEST_MEMBERID_FIELD.cpp_type = 1

BUILDLISTREQUEST.name = "BuildListRequest"
BUILDLISTREQUEST.full_name = ".protocols.BuildListRequest"
BUILDLISTREQUEST.nested_types = {}
BUILDLISTREQUEST.enum_types = {BUILDLISTREQUEST_MSGTYPE}
BUILDLISTREQUEST.fields = {BUILDLISTREQUEST_MEMBERID_FIELD}
BUILDLISTREQUEST.is_extendable = false
BUILDLISTREQUEST.extensions = {}
BUILDLISTRESPONSE_MSGTYPE_ID_ENUM.name = "ID"
BUILDLISTRESPONSE_MSGTYPE_ID_ENUM.index = 0
BUILDLISTRESPONSE_MSGTYPE_ID_ENUM.number = 23001
BUILDLISTRESPONSE_MSGTYPE.name = "MSGTYPE"
BUILDLISTRESPONSE_MSGTYPE.full_name = ".protocols.BuildListResponse.MSGTYPE"
BUILDLISTRESPONSE_MSGTYPE.values = {BUILDLISTRESPONSE_MSGTYPE_ID_ENUM}
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.name = "bin_builds"
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.full_name = ".protocols.BuildListResponse.bin_builds"
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.number = 1
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.index = 0
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.label = 3
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.has_default_value = false
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.default_value = {}
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.message_type = BUILDINFO
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.type = 11
BUILDLISTRESPONSE_BIN_BUILDS_FIELD.cpp_type = 10

BUILDLISTRESPONSE_MEMBERID_FIELD.name = "memberid"
BUILDLISTRESPONSE_MEMBERID_FIELD.full_name = ".protocols.BuildListResponse.memberid"
BUILDLISTRESPONSE_MEMBERID_FIELD.number = 2
BUILDLISTRESPONSE_MEMBERID_FIELD.index = 1
BUILDLISTRESPONSE_MEMBERID_FIELD.label = 1
BUILDLISTRESPONSE_MEMBERID_FIELD.has_default_value = false
BUILDLISTRESPONSE_MEMBERID_FIELD.default_value = 0
BUILDLISTRESPONSE_MEMBERID_FIELD.type = 5
BUILDLISTRESPONSE_MEMBERID_FIELD.cpp_type = 1

BUILDLISTRESPONSE.name = "BuildListResponse"
BUILDLISTRESPONSE.full_name = ".protocols.BuildListResponse"
BUILDLISTRESPONSE.nested_types = {}
BUILDLISTRESPONSE.enum_types = {BUILDLISTRESPONSE_MSGTYPE}
BUILDLISTRESPONSE.fields = {BUILDLISTRESPONSE_BIN_BUILDS_FIELD, BUILDLISTRESPONSE_MEMBERID_FIELD}
BUILDLISTRESPONSE.is_extendable = false
BUILDLISTRESPONSE.extensions = {}
BUILDUPGRADEREQUEST_MSGTYPE_ID_ENUM.name = "ID"
BUILDUPGRADEREQUEST_MSGTYPE_ID_ENUM.index = 0
BUILDUPGRADEREQUEST_MSGTYPE_ID_ENUM.number = 23002
BUILDUPGRADEREQUEST_MSGTYPE.name = "MSGTYPE"
BUILDUPGRADEREQUEST_MSGTYPE.full_name = ".protocols.BuildUpgradeRequest.MSGTYPE"
BUILDUPGRADEREQUEST_MSGTYPE.values = {BUILDUPGRADEREQUEST_MSGTYPE_ID_ENUM}
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.name = "build_id"
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.full_name = ".protocols.BuildUpgradeRequest.build_id"
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.number = 1
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.index = 0
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.label = 1
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.has_default_value = false
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.default_value = 0
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.type = 5
BUILDUPGRADEREQUEST_BUILD_ID_FIELD.cpp_type = 1

BUILDUPGRADEREQUEST.name = "BuildUpgradeRequest"
BUILDUPGRADEREQUEST.full_name = ".protocols.BuildUpgradeRequest"
BUILDUPGRADEREQUEST.nested_types = {}
BUILDUPGRADEREQUEST.enum_types = {BUILDUPGRADEREQUEST_MSGTYPE}
BUILDUPGRADEREQUEST.fields = {BUILDUPGRADEREQUEST_BUILD_ID_FIELD}
BUILDUPGRADEREQUEST.is_extendable = false
BUILDUPGRADEREQUEST.extensions = {}
BUILDUPGRADERESPONSE_MSGTYPE_ID_ENUM.name = "ID"
BUILDUPGRADERESPONSE_MSGTYPE_ID_ENUM.index = 0
BUILDUPGRADERESPONSE_MSGTYPE_ID_ENUM.number = 23003
BUILDUPGRADERESPONSE_MSGTYPE.name = "MSGTYPE"
BUILDUPGRADERESPONSE_MSGTYPE.full_name = ".protocols.BuildUpgradeResponse.MSGTYPE"
BUILDUPGRADERESPONSE_MSGTYPE.values = {BUILDUPGRADERESPONSE_MSGTYPE_ID_ENUM}
BUILDUPGRADERESPONSE_RESULT_FAILED_ENUM.name = "FAILED"
BUILDUPGRADERESPONSE_RESULT_FAILED_ENUM.index = 0
BUILDUPGRADERESPONSE_RESULT_FAILED_ENUM.number = 0
BUILDUPGRADERESPONSE_RESULT_SUCCESS_ENUM.name = "SUCCESS"
BUILDUPGRADERESPONSE_RESULT_SUCCESS_ENUM.index = 1
BUILDUPGRADERESPONSE_RESULT_SUCCESS_ENUM.number = 1
BUILDUPGRADERESPONSE_RESULT_INVALID_ID_ENUM.name = "INVALID_ID"
BUILDUPGRADERESPONSE_RESULT_INVALID_ID_ENUM.index = 2
BUILDUPGRADERESPONSE_RESULT_INVALID_ID_ENUM.number = 2
BUILDUPGRADERESPONSE_RESULT.name = "RESULT"
BUILDUPGRADERESPONSE_RESULT.full_name = ".protocols.BuildUpgradeResponse.RESULT"
BUILDUPGRADERESPONSE_RESULT.values = {BUILDUPGRADERESPONSE_RESULT_FAILED_ENUM,BUILDUPGRADERESPONSE_RESULT_SUCCESS_ENUM,BUILDUPGRADERESPONSE_RESULT_INVALID_ID_ENUM}
BUILDUPGRADERESPONSE_RESULT_FIELD.name = "result"
BUILDUPGRADERESPONSE_RESULT_FIELD.full_name = ".protocols.BuildUpgradeResponse.result"
BUILDUPGRADERESPONSE_RESULT_FIELD.number = 1
BUILDUPGRADERESPONSE_RESULT_FIELD.index = 0
BUILDUPGRADERESPONSE_RESULT_FIELD.label = 1
BUILDUPGRADERESPONSE_RESULT_FIELD.has_default_value = false
BUILDUPGRADERESPONSE_RESULT_FIELD.default_value = nil
BUILDUPGRADERESPONSE_RESULT_FIELD.enum_type = BUILDUPGRADERESPONSE_RESULT
BUILDUPGRADERESPONSE_RESULT_FIELD.type = 14
BUILDUPGRADERESPONSE_RESULT_FIELD.cpp_type = 8

BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.name = "build_info"
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.full_name = ".protocols.BuildUpgradeResponse.build_info"
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.number = 2
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.index = 1
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.label = 1
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.has_default_value = false
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.default_value = nil
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.message_type = BUILDINFO
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.type = 11
BUILDUPGRADERESPONSE_BUILD_INFO_FIELD.cpp_type = 10

BUILDUPGRADERESPONSE.name = "BuildUpgradeResponse"
BUILDUPGRADERESPONSE.full_name = ".protocols.BuildUpgradeResponse"
BUILDUPGRADERESPONSE.nested_types = {}
BUILDUPGRADERESPONSE.enum_types = {BUILDUPGRADERESPONSE_MSGTYPE, BUILDUPGRADERESPONSE_RESULT}
BUILDUPGRADERESPONSE.fields = {BUILDUPGRADERESPONSE_RESULT_FIELD, BUILDUPGRADERESPONSE_BUILD_INFO_FIELD}
BUILDUPGRADERESPONSE.is_extendable = false
BUILDUPGRADERESPONSE.extensions = {}
BUILDGAINREQUEST_MSGTYPE_ID_ENUM.name = "ID"
BUILDGAINREQUEST_MSGTYPE_ID_ENUM.index = 0
BUILDGAINREQUEST_MSGTYPE_ID_ENUM.number = 23004
BUILDGAINREQUEST_MSGTYPE.name = "MSGTYPE"
BUILDGAINREQUEST_MSGTYPE.full_name = ".protocols.BuildGainRequest.MSGTYPE"
BUILDGAINREQUEST_MSGTYPE.values = {BUILDGAINREQUEST_MSGTYPE_ID_ENUM}
BUILDGAINREQUEST_BUILD_ID_FIELD.name = "build_id"
BUILDGAINREQUEST_BUILD_ID_FIELD.full_name = ".protocols.BuildGainRequest.build_id"
BUILDGAINREQUEST_BUILD_ID_FIELD.number = 1
BUILDGAINREQUEST_BUILD_ID_FIELD.index = 0
BUILDGAINREQUEST_BUILD_ID_FIELD.label = 1
BUILDGAINREQUEST_BUILD_ID_FIELD.has_default_value = false
BUILDGAINREQUEST_BUILD_ID_FIELD.default_value = 0
BUILDGAINREQUEST_BUILD_ID_FIELD.type = 5
BUILDGAINREQUEST_BUILD_ID_FIELD.cpp_type = 1

BUILDGAINREQUEST.name = "BuildGainRequest"
BUILDGAINREQUEST.full_name = ".protocols.BuildGainRequest"
BUILDGAINREQUEST.nested_types = {}
BUILDGAINREQUEST.enum_types = {BUILDGAINREQUEST_MSGTYPE}
BUILDGAINREQUEST.fields = {BUILDGAINREQUEST_BUILD_ID_FIELD}
BUILDGAINREQUEST.is_extendable = false
BUILDGAINREQUEST.extensions = {}
BUILDGAINRESPONSE_MSGTYPE_ID_ENUM.name = "ID"
BUILDGAINRESPONSE_MSGTYPE_ID_ENUM.index = 0
BUILDGAINRESPONSE_MSGTYPE_ID_ENUM.number = 23005
BUILDGAINRESPONSE_MSGTYPE.name = "MSGTYPE"
BUILDGAINRESPONSE_MSGTYPE.full_name = ".protocols.BuildGainResponse.MSGTYPE"
BUILDGAINRESPONSE_MSGTYPE.values = {BUILDGAINRESPONSE_MSGTYPE_ID_ENUM}
BUILDGAINRESPONSE_RESULT_FAILED_ENUM.name = "FAILED"
BUILDGAINRESPONSE_RESULT_FAILED_ENUM.index = 0
BUILDGAINRESPONSE_RESULT_FAILED_ENUM.number = 0
BUILDGAINRESPONSE_RESULT_SUCCESS_ENUM.name = "SUCCESS"
BUILDGAINRESPONSE_RESULT_SUCCESS_ENUM.index = 1
BUILDGAINRESPONSE_RESULT_SUCCESS_ENUM.number = 1
BUILDGAINRESPONSE_RESULT_INVALID_ID_ENUM.name = "INVALID_ID"
BUILDGAINRESPONSE_RESULT_INVALID_ID_ENUM.index = 2
BUILDGAINRESPONSE_RESULT_INVALID_ID_ENUM.number = 2
BUILDGAINRESPONSE_RESULT.name = "RESULT"
BUILDGAINRESPONSE_RESULT.full_name = ".protocols.BuildGainResponse.RESULT"
BUILDGAINRESPONSE_RESULT.values = {BUILDGAINRESPONSE_RESULT_FAILED_ENUM,BUILDGAINRESPONSE_RESULT_SUCCESS_ENUM,BUILDGAINRESPONSE_RESULT_INVALID_ID_ENUM}
BUILDGAINRESPONSE_RESULT_FIELD.name = "result"
BUILDGAINRESPONSE_RESULT_FIELD.full_name = ".protocols.BuildGainResponse.result"
BUILDGAINRESPONSE_RESULT_FIELD.number = 1
BUILDGAINRESPONSE_RESULT_FIELD.index = 0
BUILDGAINRESPONSE_RESULT_FIELD.label = 1
BUILDGAINRESPONSE_RESULT_FIELD.has_default_value = false
BUILDGAINRESPONSE_RESULT_FIELD.default_value = nil
BUILDGAINRESPONSE_RESULT_FIELD.enum_type = BUILDGAINRESPONSE_RESULT
BUILDGAINRESPONSE_RESULT_FIELD.type = 14
BUILDGAINRESPONSE_RESULT_FIELD.cpp_type = 8

BUILDGAINRESPONSE_GOLD_FIELD.name = "gold"
BUILDGAINRESPONSE_GOLD_FIELD.full_name = ".protocols.BuildGainResponse.gold"
BUILDGAINRESPONSE_GOLD_FIELD.number = 2
BUILDGAINRESPONSE_GOLD_FIELD.index = 1
BUILDGAINRESPONSE_GOLD_FIELD.label = 1
BUILDGAINRESPONSE_GOLD_FIELD.has_default_value = false
BUILDGAINRESPONSE_GOLD_FIELD.default_value = 0
BUILDGAINRESPONSE_GOLD_FIELD.type = 5
BUILDGAINRESPONSE_GOLD_FIELD.cpp_type = 1

BUILDGAINRESPONSE.name = "BuildGainResponse"
BUILDGAINRESPONSE.full_name = ".protocols.BuildGainResponse"
BUILDGAINRESPONSE.nested_types = {}
BUILDGAINRESPONSE.enum_types = {BUILDGAINRESPONSE_MSGTYPE, BUILDGAINRESPONSE_RESULT}
BUILDGAINRESPONSE.fields = {BUILDGAINRESPONSE_RESULT_FIELD, BUILDGAINRESPONSE_GOLD_FIELD}
BUILDGAINRESPONSE.is_extendable = false
BUILDGAINRESPONSE.extensions = {}

BuildGainRequest = protobuf.Message(BUILDGAINREQUEST)
BuildGainResponse = protobuf.Message(BUILDGAINRESPONSE)
BuildInfo = protobuf.Message(BUILDINFO)
BuildListRequest = protobuf.Message(BUILDLISTREQUEST)
BuildListResponse = protobuf.Message(BUILDLISTRESPONSE)
BuildUpgradeRequest = protobuf.Message(BUILDUPGRADEREQUEST)
BuildUpgradeResponse = protobuf.Message(BUILDUPGRADERESPONSE)

