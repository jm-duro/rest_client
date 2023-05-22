--  Project
------- _   _ ____  _
----___| | | |  _ \| |
---/ __| | | | |_) | |
--| (__| |_| |  _ <| |
---\___|\___/|_| \_\_____|
--
-- Copyright (C) 1998 - 2016, Daniel Stenberg, <daniel@haxx.se>, et al.
--
-- This software is licensed as described in the file COPYING, which
-- you should have received as part of this distribution. The terms
-- are also available at https://curl.haxx.se/docs/copyright.html.
--
-- You may opt to use, copy, modify, merge, publish, distribute and/or sell
-- copies of the Software, and permit persons to whom the Software is
-- furnished to do so, under the terms of the COPYING file.
--
-- This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
-- KIND, either express or implied.
--
--------------------------------------------------------------------------------
--
-- some routines are borrowed from Raymond Smith's eulibcurl2
--
--------------------------------------------------------------------------------
--
-- If you have libcurl problems, all docs and details are found here:
--   https://curl.haxx.se/libcurl/
--
-- curl-library mailing list subscription and unsubscription web interface:
--   https://cool.haxx.se/mailman/listinfo/curl-library/

include std/dll.e
include std/machine.e
include std/text.e
include std/search.e
include std/sequence.e
include std/convert.e
include std/eumem.e
include std/math.e

include common.e

public constant
  CURL_HTTPPOST_FILENAME    =   1,
  CURL_HTTPPOST_READFILE    =   2,
  CURL_HTTPPOST_PTRNAME     =   4,
  CURL_HTTPPOST_PTRCONTENTS =   8,
  CURL_HTTPPOST_BUFFER      =  16,  --
  CURL_HTTPPOST_PTRBUFFER   =  32,  --
  CURL_HTTPPOST_CALLBACK    =  64,
  CURL_HTTPPOST_LARGE       = 128

--------------------------------------------------------------------------------

public constant CURL_MAX_WRITE_SIZE = 16384
public constant CURL_MAX_HTTP_HEADER = (100*1024)
public constant CURL_WRITEFUNC_PAUSE = #10000001

--------------------------------------------------------------------------------

-- enumeration of file types
public constant
  CURLFILETYPE_FILE         = 0,
  CURLFILETYPE_DIRECTORY    = 1,
  CURLFILETYPE_SYMLINK      = 2,
  CURLFILETYPE_DEVICE_BLOCK = 3,
  CURLFILETYPE_DEVICE_CHAR  = 4,
  CURLFILETYPE_NAMEDPIPE    = 5,
  CURLFILETYPE_SOCKET       = 6,
  CURLFILETYPE_DOOR         = 7,
  CURLFILETYPE_UNKNOWN      = 8

public type curlfiletype(integer n)
  return ((n >= CURLFILETYPE_FILE) and (n <= CURLFILETYPE_UNKNOWN))
end type

--------------------------------------------------------------------------------

public constant
  CURLFINFOFLAG_KNOWN_FILENAME   =   1,
  CURLFINFOFLAG_KNOWN_FILETYPE   =   2,
  CURLFINFOFLAG_KNOWN_TIME       =   4,
  CURLFINFOFLAG_KNOWN_PERM       =   8,
  CURLFINFOFLAG_KNOWN_UID        =  16,
  CURLFINFOFLAG_KNOWN_GID        =  32,
  CURLFINFOFLAG_KNOWN_SIZE       =  64,
  CURLFINFOFLAG_KNOWN_HLINKCOUNT = 128

--------------------------------------------------------------------------------

-- return codes for CURLOPT_CHUNK_BGN_FUNCTION
public constant
  CURL_CHUNK_BGN_FUNC_OK   = 0,
  CURL_CHUNK_BGN_FUNC_FAIL = 1,
  CURL_CHUNK_BGN_FUNC_SKIP = 2

--------------------------------------------------------------------------------

-- return codes for CURLOPT_CHUNK_END_FUNCTION
public constant
  CURL_CHUNK_END_FUNC_OK   = 0,
  CURL_CHUNK_END_FUNC_FAIL = 1

--------------------------------------------------------------------------------

-- return codes for FNMATCHFUNCTION
public constant
  CURL_FNMATCHFUNC_MATCH   = 0,
  CURL_FNMATCHFUNC_NOMATCH = 1,
  CURL_FNMATCHFUNC_FAIL    = 2

--------------------------------------------------------------------------------

-- These are the return codes for the seek callbacks
public constant
  CURL_SEEKFUNC_OK       = 0,
  CURL_SEEKFUNC_FAIL     = 1,
  CURL_SEEKFUNC_CANTSEEK = 2

--------------------------------------------------------------------------------

public constant CURL_READFUNC_ABORT = #10000000
public constant CURL_READFUNC_PAUSE = #10000001

--------------------------------------------------------------------------------

public constant
  CURLSOCKTYPE_IPCXN  = 0,
  CURLSOCKTYPE_ACCEPT = 1,
  CURLSOCKTYPE_LAST   = 2

public type curlsocktype(integer n)
  return ((n >= CURLSOCKTYPE_IPCXN) and (n <= CURLSOCKTYPE_LAST))
end type

--------------------------------------------------------------------------------

-- The return code from the sockopt_callback can signal information back
--    to libcurl:
public constant
  CURL_SOCKOPT_OK                = 0,
  CURL_SOCKOPT_ERROR             = 1,
  CURL_SOCKOPT_ALREADY_CONNECTED = 2

--------------------------------------------------------------------------------

public constant
  CURLIOE_OK          = 0,
  CURLIOE_UNKNOWNCMD  = 1,
  CURLIOE_FAILRESTART = 2,
  CURLIOE_LAST        = 3

public type curlioerr(integer n)
  return ((n >= CURLIOE_OK) and (n <= CURLIOE_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURLIOCMD_NOP         = 0,
  CURLIOCMD_RESTARTREAD = 1,
  CURLIOCMD_LAST        = 2

public type curliocmd(integer n)
  return ((n >= CURLIOCMD_NOP) and (n <= CURLIOCMD_LAST))
end type

--------------------------------------------------------------------------------

-- the kind of data that is passed to information_callback*/
public constant
  CURLINFO_TEXT         = 0,
  CURLINFO_HEADER_IN    = 1,
  CURLINFO_HEADER_OUT   = 2,
  CURLINFO_DATA_IN      = 3,
  CURLINFO_DATA_OUT     = 4,
  CURLINFO_SSL_DATA_IN  = 5,
  CURLINFO_SSL_DATA_OUT = 6,
  CURLINFO_END          = 7

public type curl_infotype(integer n)
  return ((n >= CURLINFO_TEXT) and (n <= CURLINFO_END))
end type

--------------------------------------------------------------------------------

-- All possible error codes from all sorts of curl functions. Future versions
--    may return other values, stay prepared.

--    Always add new return codes last. Never *EVER* remove any. The return
--    codes must remain the same!

public constant
  CURLE_OK                       =  0,
  CURLE_UNSUPPORTED_PROTOCOL     =  1,
  CURLE_FAILED_INIT              =  2,
  CURLE_URL_MALFORMAT            =  3,
  CURLE_NOT_BUILT_IN             =  4,
  CURLE_COULDNT_RESOLVE_PROXY    =  5,
  CURLE_COULDNT_RESOLVE_HOST     =  6,
  CURLE_COULDNT_CONNECT          =  7,
  CURLE_FTP_WEIRD_SERVER_REPLY   =  8,
  CURLE_REMOTE_ACCESS_DENIED     =  9,
  CURLE_FTP_ACCEPT_FAILED        = 10,
  CURLE_FTP_WEIRD_PASS_REPLY     = 11,
  CURLE_FTP_ACCEPT_TIMEOUT       = 12,
  CURLE_FTP_WEIRD_PASV_REPLY     = 13,
  CURLE_FTP_WEIRD_227_FORMAT     = 14,
  CURLE_FTP_CANT_GET_HOST        = 15,
  CURLE_HTTP2                    = 16,
  CURLE_FTP_COULDNT_SET_TYPE     = 17,
  CURLE_PARTIAL_FILE             = 18,
  CURLE_FTP_COULDNT_RETR_FILE    = 19,
  CURLE_OBSOLETE20               = 20,
  CURLE_QUOTE_ERROR              = 21,
  CURLE_HTTP_RETURNED_ERROR      = 22,
  CURLE_WRITE_ERROR              = 23,
  CURLE_OBSOLETE24               = 24,
  CURLE_UPLOAD_FAILED            = 25,
  CURLE_READ_ERROR               = 26,
  CURLE_OUT_OF_MEMORY            = 27,
  CURLE_OPERATION_TIMEDOUT       = 28,
  CURLE_OBSOLETE29               = 29,
  CURLE_FTP_PORT_FAILED          = 30,
  CURLE_FTP_COULDNT_USE_REST     = 31,
  CURLE_OBSOLETE32               = 32,
  CURLE_RANGE_ERROR              = 33,
  CURLE_HTTP_POST_ERROR          = 34,
  CURLE_SSL_CONNECT_ERROR        = 35,
  CURLE_BAD_DOWNLOAD_RESUME      = 36,
  CURLE_FILE_COULDNT_READ_FILE   = 37,
  CURLE_LDAP_CANNOT_BIND         = 38,
  CURLE_LDAP_SEARCH_FAILED       = 39,
  CURLE_OBSOLETE40               = 40,
  CURLE_FUNCTION_NOT_FOUND       = 41,
  CURLE_ABORTED_BY_CALLBACK      = 42,
  CURLE_BAD_FUNCTION_ARGUMENT    = 43,
  CURLE_OBSOLETE44               = 44,
  CURLE_INTERFACE_FAILED         = 45,
  CURLE_OBSOLETE46               = 46,
  CURLE_TOO_MANY_REDIRECTS       = 47,
  CURLE_UNKNOWN_OPTION           = 48,
  CURLE_TELNET_OPTION_SYNTAX     = 49,
  CURLE_OBSOLETE50               = 50,
  CURLE_PEER_FAILED_VERIFICATION = 51,
  CURLE_GOT_NOTHING              = 52,
  CURLE_SSL_ENGINE_NOTFOUND      = 53,
  CURLE_SSL_ENGINE_SETFAILED     = 54,
  CURLE_SEND_ERROR               = 55,
  CURLE_RECV_ERROR               = 56,
  CURLE_OBSOLETE57               = 57,
  CURLE_SSL_CERTPROBLEM          = 58,
  CURLE_SSL_CIPHER               = 59,
  CURLE_SSL_CACERT               = 60,
  CURLE_BAD_CONTENT_ENCODING     = 61,
  CURLE_LDAP_INVALID_URL         = 62,
  CURLE_FILESIZE_EXCEEDED        = 63,
  CURLE_USE_SSL_FAILED           = 64,
  CURLE_SEND_FAIL_REWIND         = 65,
  CURLE_SSL_ENGINE_INITFAILED    = 66,
  CURLE_LOGIN_DENIED             = 67,
  CURLE_TFTP_NOTFOUND            = 68,
  CURLE_TFTP_PERM                = 69,
  CURLE_REMOTE_DISK_FULL         = 70,
  CURLE_TFTP_ILLEGAL             = 71,
  CURLE_TFTP_UNKNOWNID           = 72,
  CURLE_REMOTE_FILE_EXISTS       = 73,
  CURLE_TFTP_NOSUCHUSER          = 74,
  CURLE_CONV_FAILED              = 75,
  CURLE_CONV_REQD                = 76,
  CURLE_SSL_CACERT_BADFILE       = 77,
  CURLE_REMOTE_FILE_NOT_FOUND    = 78,
  CURLE_SSH                      = 79,
  CURLE_SSL_SHUTDOWN_FAILED      = 80,
  CURLE_AGAIN                    = 81,
  CURLE_SSL_CRL_BADFILE          = 82,
  CURLE_SSL_ISSUER_ERROR         = 83,
  CURLE_FTP_PRET_FAILED          = 84,
  CURLE_RTSP_CSEQ_ERROR          = 85,
  CURLE_RTSP_SESSION_ERROR       = 86,
  CURLE_FTP_BAD_FILE_LIST        = 87,
  CURLE_CHUNK_FAILED             = 88,
  CURLE_NO_CONNECTION_AVAILABLE  = 89,
  CURLE_SSL_PINNEDPUBKEYNOTMATCH = 90,
  CURLE_SSL_INVALIDCERTSTATUS    = 91,
  CURLE_HTTP2_STREAM             = 92,
  CURL_LAST                      = 93

public type CURLcode(integer n)
  return ((n >= CURLE_OK) and (n <= CURL_LAST))
end type

--------------------------------------------------------------------------------

public constant
  -- Previously obsolete error code re-used in 7.38.0
  CURLE_OBSOLETE16 = CURLE_HTTP2,

  -- Previously obsolete error codes re-used in 7.24.0
  CURLE_OBSOLETE10 = CURLE_FTP_ACCEPT_FAILED,
  CURLE_OBSOLETE12 = CURLE_FTP_ACCEPT_TIMEOUT,

  --  compatibility with older names
--  CURLOPT_ENCODING = CURLOPT_ACCEPT_ENCODING,

  -- The following were added in 7.21.5, April 2011
  CURLE_UNKNOWN_TELNET_OPTION = CURLE_UNKNOWN_OPTION,

  -- The following were added in 7.17.1
  -- These are scheduled to disappear by 2009
  CURLE_SSL_PEER_CERTIFICATE = CURLE_PEER_FAILED_VERIFICATION,

  -- The following were added in 7.17.0
  -- These are scheduled to disappear by 2009
  CURLE_OBSOLETE                    = CURLE_OBSOLETE50,  -- no one should be using this!
  CURLE_BAD_PASSWORD_ENTERED        = CURLE_OBSOLETE46,
  CURLE_BAD_CALLING_ORDER           = CURLE_OBSOLETE44,
  CURLE_FTP_USER_PASSWORD_INCORRECT = CURLE_OBSOLETE10,
  CURLE_FTP_CANT_RECONNECT          = CURLE_OBSOLETE16,
  CURLE_FTP_COULDNT_GET_SIZE        = CURLE_OBSOLETE32,
  CURLE_FTP_COULDNT_SET_ASCII       = CURLE_OBSOLETE29,
  CURLE_FTP_WEIRD_USER_REPLY        = CURLE_OBSOLETE12,
  CURLE_FTP_WRITE_ERROR             = CURLE_OBSOLETE20,
  CURLE_LIBRARY_NOT_FOUND           = CURLE_OBSOLETE40,
  CURLE_MALFORMAT_USER              = CURLE_OBSOLETE24,
  CURLE_SHARE_IN_USE                = CURLE_OBSOLETE57,
  CURLE_URL_MALFORMAT_USER          = CURLE_NOT_BUILT_IN,

  CURLE_FTP_ACCESS_DENIED      = CURLE_REMOTE_ACCESS_DENIED,
  CURLE_FTP_COULDNT_SET_BINARY = CURLE_FTP_COULDNT_SET_TYPE,
  CURLE_FTP_QUOTE_ERROR        = CURLE_QUOTE_ERROR,
  CURLE_TFTP_DISKFULL          = CURLE_REMOTE_DISK_FULL,
  CURLE_TFTP_EXISTS            = CURLE_REMOTE_FILE_EXISTS,
  CURLE_HTTP_RANGE_ERROR       = CURLE_RANGE_ERROR,
  CURLE_FTP_SSL_FAILED         = CURLE_USE_SSL_FAILED,

--------------------------------------------------------------------------------

  -- The following were added earlier

  CURLE_OPERATION_TIMEOUTED     = CURLE_OPERATION_TIMEDOUT,

  CURLE_HTTP_NOT_FOUND          = CURLE_HTTP_RETURNED_ERROR,
  CURLE_HTTP_PORT_FAILED        = CURLE_INTERFACE_FAILED,
  CURLE_FTP_COULDNT_STOR_FILE   = CURLE_UPLOAD_FAILED,

  CURLE_FTP_PARTIAL_FILE        = CURLE_PARTIAL_FILE,
  CURLE_FTP_BAD_DOWNLOAD_RESUME = CURLE_BAD_DOWNLOAD_RESUME,

  -- This was the error code 50 in 7.7.3 and a few earlier versions, this
  --   is no longer used by libcurl but is instead constantd here only to not
  --   make programs break
  CURLE_ALREADY_COMPLETE = 99999,

--------------------------------------------------------------------------------

  -- Provide defines for really old option names
  CURLOPT_FILE        = 10001,  -- name changed in 7.9.7
  CURLOPT_INFILE      = 10009,  -- name changed in 7.9.7
  CURLOPT_WRITEHEADER = 10029,

  -- Since long deprecated options with no code in the lib that does anything
  -- with them.
  CURLOPT_WRITEINFO   = 10040,
  CURLOPT_CLOSEPOLICY = 72

--------------------------------------------------------------------------------

public constant  -- this public enum was added in 7.10
  CURLPROXY_HTTP            = 0,
  CURLPROXY_HTTP_1_0        = 1,
  CURLPROXY_SOCKS4          = 4,
  CURLPROXY_SOCKS5          = 5,
  CURLPROXY_SOCKS4A         = 6,
  CURLPROXY_SOCKS5_HOSTNAME = 7

public type curl_proxytype(integer n)
  return find(n, {CURLPROXY_HTTP, CURLPROXY_HTTP_1_0, CURLPROXY_SOCKS4,
                   CURLPROXY_SOCKS5, CURLPROXY_SOCKS4A, CURLPROXY_SOCKS5_HOSTNAME})
end type

--------------------------------------------------------------------------------

-- Bitmasks for CURLOPT_HTTPAUTH and CURLOPT_PROXYAUTH options:

public constant CURLAUTH_NONE         = #00000000
public constant CURLAUTH_BASIC        = #00000001
public constant CURLAUTH_DIGEST       = #00000002
public constant CURLAUTH_NEGOTIATE    = #00000004
-- Deprecated since the advent of CURLAUTH_NEGOTIATE
public constant CURLAUTH_GSSNEGOTIATE = CURLAUTH_NEGOTIATE
public constant CURLAUTH_NTLM         = #00000008
public constant CURLAUTH_DIGEST_IE    = #00000010
public constant CURLAUTH_NTLM_WB      = #00000020
public constant CURLAUTH_ONLY         = #80000000
public constant CURLAUTH_ANY          = not CURLAUTH_DIGEST_IE
public constant CURLAUTH_ANYSAFE      = not or_bits(CURLAUTH_BASIC, CURLAUTH_DIGEST_IE)

--------------------------------------------------------------------------------

public constant CURLSSH_AUTH_ANY       = not 0
public constant CURLSSH_AUTH_NONE      = 0
public constant CURLSSH_AUTH_PUBLICKEY = 1
public constant CURLSSH_AUTH_PASSWORD  = 2
public constant CURLSSH_AUTH_HOST      = 4
public constant CURLSSH_AUTH_KEYBOARD  = 8
public constant CURLSSH_AUTH_AGENT     = 16
public constant CURLSSH_AUTH_DEFAULT   = CURLSSH_AUTH_ANY

--------------------------------------------------------------------------------

public constant CURLGSSAPI_DELEGATION_NONE        = 0
public constant CURLGSSAPI_DELEGATION_POLICY_FLAG = 1
public constant CURLGSSAPI_DELEGATION_FLAG        = 2

--------------------------------------------------------------------------------

public constant CURL_ERROR_SIZE = 256

--------------------------------------------------------------------------------

public constant
  CURLKHTYPE_UNKNOWN = 0,
  CURLKHTYPE_RSA1    = 1,
  CURLKHTYPE_RSA     = 2,
  CURLKHTYPE_DSS     = 3

type curl_khtype(integer x)
  return (x >= CURLKHTYPE_UNKNOWN) and (x <= CURLKHTYPE_DSS)
end type

--------------------------------------------------------------------------------

-- this is the set of return values expected from the curl_sshkeycallback
--    callback
public constant
  CURLKHSTAT_FINE_ADD_TO_FILE = 0,
  CURLKHSTAT_FINE   = 1,
  CURLKHSTAT_REJECT = 2,
  CURLKHSTAT_DEFER  = 3,
  CURLKHSTAT_LAST   = 4

type curl_khstat(integer x)
  return (x >= CURLKHSTAT_FINE_ADD_TO_FILE) and (x <= CURLKHSTAT_LAST)
end type

--------------------------------------------------------------------------------

-- this is the set of status codes pass in to the callback
public constant
  CURLKHMATCH_OK       = 0,
  CURLKHMATCH_MISMATCH = 1,
  CURLKHMATCH_MISSING  = 2,
  CURLKHMATCH_LAST     = 3

type curl_khmatch(integer x)
  return (x >= CURLKHMATCH_OK) and (x <= CURLKHMATCH_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_USE_SSL option
public constant
  CURLUSESSL_NONE    = 0,
  CURLUSESSL_TRY     = 1,
  CURLUSESSL_CONTROL = 2,
  CURLUSESSL_ALL     = 3,
  CURLUSESSL_LAST    = 4

public type curl_usessl(integer x)
  return (x >= CURLUSESSL_NONE) and (x <= CURLUSESSL_LAST)
end type

--------------------------------------------------------------------------------

-- Definition of bits for the CURLOPT_SSL_OPTIONS argument:

-- - ALLOW_BEAST tells libcurl to allow the BEAST SSL vulnerability in the
--    name of improving interoperability with older servers. Some SSL libraries
--    have introduced work-arounds for this flaw but those work-arounds sometimes
--    make the SSL communication fail. To regain functionality with those broken
--    servers, a user can this way allow the vulnerability back.
public constant CURLSSLOPT_ALLOW_BEAST = 1

-- - NO_REVOKE tells libcurl to disable certificate revocation checks for those
--    SSL backends where such behavior is present.
public constant CURLSSLOPT_NO_REVOKE   = 2

--------------------------------------------------------------------------------

-- Backwards compatibility with older names
-- These are scheduled to disappear by 2009

public constant CURLFTPSSL_NONE    = CURLUSESSL_NONE
public constant CURLFTPSSL_TRY     = CURLUSESSL_TRY
public constant CURLFTPSSL_CONTROL = CURLUSESSL_CONTROL
public constant CURLFTPSSL_ALL     = CURLUSESSL_ALL
public constant CURLFTPSSL_LAST    = CURLUSESSL_LAST
-- curl_ftpssl = curl_usessl

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTP_SSL_CCC option
public constant
  CURLFTPSSL_CCC_NONE    = 0,
  CURLFTPSSL_CCC_PASSIVE = 1,
  CURLFTPSSL_CCC_ACTIVE  = 2,
  CURLFTPSSL_CCC_LAST    = 3

public type curl_ftpccc(integer x)
  return (x >= CURLFTPSSL_CCC_NONE) and (x <= CURLFTPSSL_CCC_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTPSSLAUTH option
public constant
  CURLFTPAUTH_DEFAULT = 0,
  CURLFTPAUTH_SSL     = 1,
  CURLFTPAUTH_TLS     = 2,
  CURLFTPAUTH_LAST    = 3

public type curl_ftpauth(integer x)
--<type>


--</type>
  return (x >= CURLFTPAUTH_DEFAULT) and (x <= CURLFTPAUTH_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTP_CREATE_MISSING_DIRS option
public constant
  CURLFTP_CREATE_DIR_NONE  = 0,
  CURLFTP_CREATE_DIR       = 1,
  CURLFTP_CREATE_DIR_RETRY = 2,
  CURLFTP_CREATE_DIR_LAST  = 3

public type curl_ftpcreatedir(integer x)
  return (x >= CURLFTP_CREATE_DIR_NONE) and (x <= CURLFTP_CREATE_DIR_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTP_FILEMETHOD option
public constant
  CURLFTPMETHOD_DEFAULT   = 0,
  CURLFTPMETHOD_MULTICWD  = 1,
  CURLFTPMETHOD_NOCWD     = 2,
  CURLFTPMETHOD_SINGLECWD = 3,
  CURLFTPMETHOD_LAST      = 4

public type curl_ftpmethod(integer x)
  return (x >= CURLFTPMETHOD_DEFAULT) and (x <= CURLFTPMETHOD_LAST)
end type

--------------------------------------------------------------------------------

-- bitmask defines for CURLOPT_HEADEROPT
public constant CURLHEADER_UNIFIED  = 0
public constant CURLHEADER_SEPARATE = 1

--------------------------------------------------------------------------------

-- CURLPROTO_ defines are for the CURLOPT_*PROTOCOLS options
public constant
  CURLPROTO_HTTP   = #0000001,
  CURLPROTO_HTTPS  = #0000002,
  CURLPROTO_FTP    = #0000004,
  CURLPROTO_FTPS   = #0000008,
  CURLPROTO_SCP    = #0000010,
  CURLPROTO_SFTP   = #0000020,
  CURLPROTO_TELNET = #0000040,
  CURLPROTO_LDAP   = #0000080,
  CURLPROTO_LDAPS  = #0000100,
  CURLPROTO_DICT   = #0000200,
  CURLPROTO_FILE   = #0000400,
  CURLPROTO_TFTP   = #0000800,
  CURLPROTO_IMAP   = #0001000,
  CURLPROTO_IMAPS  = #0002000,
  CURLPROTO_POP3   = #0004000,
  CURLPROTO_POP3S  = #0008000,
  CURLPROTO_SMTP   = #0010000,
  CURLPROTO_SMTPS  = #0020000,
  CURLPROTO_RTSP   = #0040000,
  CURLPROTO_RTMP   = #0080000,
  CURLPROTO_RTMPT  = #0100000,
  CURLPROTO_RTMPE  = #0200000,
  CURLPROTO_RTMPTE = #0400000,
  CURLPROTO_RTMPS  = #0800000,
  CURLPROTO_RTMPTS = #1000000,
  CURLPROTO_GOPHER = #2000000,
  CURLPROTO_SMB    = #4000000,
  CURLPROTO_SMBS   = #8000000,
  CURLPROTO_ALL    = not 0

--------------------------------------------------------------------------------

-- options to be used with curl_easy_setopt().

public constant
  CURLOPT_WRITEDATA       = 10001,
  CURLOPT_URL             = 10002,
  CURLOPT_PORT            =     3,
  CURLOPT_PROXY           = 10004,
  CURLOPT_USERPWD         = 10005,
  CURLOPT_PROXYUSERPWD    = 10006,
  CURLOPT_RANGE           = 10007,
  CURLOPT_READDATA        = 10009,
  CURLOPT_ERRORBUFFER     = 10010,
  CURLOPT_WRITEFUNCTION   = 20011,
  CURLOPT_READFUNCTION    = 20012,
  CURLOPT_TIMEOUT         =    13,
  CURLOPT_INFILESIZE      =    14,
  CURLOPT_POSTFIELDS      = 10015,
  CURLOPT_REFERER         = 10016,
  CURLOPT_FTPPORT         = 10017,
  CURLOPT_USERAGENT       = 10018,
  CURLOPT_LOW_SPEED_LIMIT =    19,
  CURLOPT_LOW_SPEED_TIME  =    20,
  CURLOPT_RESUME_FROM     =    21,
  CURLOPT_COOKIE          = 10022,
  CURLOPT_HTTPHEADER      = 10023,
  CURLOPT_HTTPPOST        = 10024,
  CURLOPT_SSLCERT         = 10025,
  CURLOPT_KEYPASSWD       = 10026,
  CURLOPT_CRLF            =    27,
  CURLOPT_QUOTE           = 10028,
  CURLOPT_HEADERDATA      = 10029,
  CURLOPT_COOKIEFILE      = 10031,
  CURLOPT_SSLVERSION      =    32,
  CURLOPT_TIMECONDITION   =    33,
  CURLOPT_TIMEVALUE       =    34,
  -- 35 = OBSOLETE
  CURLOPT_CUSTOMREQUEST   = 10036,
  CURLOPT_STDERR          = 10037,
  -- 38 is not used
  CURLOPT_POSTQUOTE       = 10039,
  CURLOPT_OBSOLETE40      = 10040,
  CURLOPT_VERBOSE         =    41,
  CURLOPT_HEADER          =    42,
  CURLOPT_NOPROGRESS      =    43,
  CURLOPT_NOBODY          =    44,
  CURLOPT_FAILONERROR     =    45,
  CURLOPT_UPLOAD          =    46,
  CURLOPT_POST            =    47,
  CURLOPT_DIRLISTONLY     =    48,
  CURLOPT_APPEND          =    50,
  CURLOPT_NETRC           =    51,
  CURLOPT_FOLLOWLOCATION  =    52,
  CURLOPT_TRANSFERTEXT    =    53,
  CURLOPT_PUT             =    54,
  -- 55 = OBSOLETE
  CURLOPT_PROGRESSFUNCTION = 20056,
  CURLOPT_PROGRESSDATA    = 10057,
  CURLOPT_AUTOREFERER     =    58,
  CURLOPT_PROXYPORT       =    59,
  CURLOPT_POSTFIELDSIZE   =    60,
  CURLOPT_HTTPPROXYTUNNEL =    61,
  CURLOPT_INTERFACE       = 10062,
  CURLOPT_KRBLEVEL        = 10063,
  CURLOPT_SSL_VERIFYPEER  =    64,
  CURLOPT_CAINFO          = 10065,
  -- 66 = OBSOLETE
  -- 67 = OBSOLETE
  CURLOPT_MAXREDIRS       =    68,
  CURLOPT_FILETIME        =    69,
  CURLOPT_TELNETOPTIONS   = 10070,
  CURLOPT_MAXCONNECTS     =    71,
  CURLOPT_OBSOLETE72      =    72,
  -- 73 = OBSOLETE
  CURLOPT_FRESH_CONNECT   =    74,
  CURLOPT_FORBID_REUSE    =    75,
  CURLOPT_RANDOM_FILE     = 10076,
  CURLOPT_EGDSOCKET       = 10077,
  CURLOPT_CONNECTTIMEOUT  =    78,
  CURLOPT_HEADERFUNCTION  = 20079,
  CURLOPT_HTTPGET         =    80,
  CURLOPT_SSL_VERIFYHOST  =    81,
  CURLOPT_COOKIEJAR       = 10082,
  CURLOPT_SSL_CIPHER_LIST = 10083,  --
  CURLOPT_HTTP_VERSION    =    84,
  CURLOPT_FTP_USE_EPSV    =    85,
  CURLOPT_SSLCERTTYPE     = 10086,
  CURLOPT_SSLKEY          = 10087,
  CURLOPT_SSLKEYTYPE      = 10088,
  CURLOPT_SSLENGINE       = 10089,
  CURLOPT_SSLENGINE_DEFAULT =  90,
  CURLOPT_DNS_USE_GLOBAL_CACHE = 91,
  CURLOPT_DNS_CACHE_TIMEOUT =  92,
  CURLOPT_PREQUOTE        = 10093,
  CURLOPT_DEBUGFUNCTION   = 20094,
  CURLOPT_DEBUGDATA       = 10095,
  CURLOPT_COOKIESESSION   =    96,
  CURLOPT_CAPATH          = 10097,
  CURLOPT_BUFFERSIZE      =    98,
  CURLOPT_NOSIGNAL        =    99,
  CURLOPT_SHARE           = 10100,
  CURLOPT_PROXYTYPE       =   101,
  CURLOPT_ACCEPT_ENCODING = 10102,  -- Before 7.21.6, this was known as CURLOPT_ENCODING
  CURLOPT_PRIVATE         = 10103,
  CURLOPT_HTTP200ALIASES  = 10104,
  CURLOPT_UNRESTRICTED_AUTH = 105,
  CURLOPT_FTP_USE_EPRT    =   106,
  CURLOPT_HTTPAUTH        =   107,
  CURLOPT_SSL_CTX_FUNCTION = 20108,
  CURLOPT_SSL_CTX_DATA    = 10109,
  CURLOPT_FTP_CREATE_MISSING_DIRS = 110,
  CURLOPT_PROXYAUTH       =   111,
  CURLOPT_FTP_RESPONSE_TIMEOUT = 112,
  CURLOPT_IPRESOLVE       =   113,
  CURLOPT_MAXFILESIZE     =   114,
  CURLOPT_INFILESIZE_LARGE = 30115,
  CURLOPT_RESUME_FROM_LARGE = 30116,
  CURLOPT_MAXFILESIZE_LARGE = 30117,
  CURLOPT_NETRC_FILE      = 10118,
  CURLOPT_USE_SSL         =   119,
  CURLOPT_POSTFIELDSIZE_LARGE = 30120,
  CURLOPT_TCP_NODELAY     =   121,
  -- 122 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 123 OBSOLETE. Gone in 7.16.0
  -- 124 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 125 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 126 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 127 OBSOLETE. Gone in 7.16.0
  -- 128 OBSOLETE. Gone in 7.16.0
  CURLOPT_FTPSSLAUTH      =   129,
  CURLOPT_IOCTLFUNCTION   = 20130,
  CURLOPT_IOCTLDATA       = 10131,
  -- 132 OBSOLETE. Gone in 7.16.0
  -- 133 OBSOLETE. Gone in 7.16.0
  CURLOPT_FTP_ACCOUNT     = 10134,
  CURLOPT_COOKIELIST      = 10135,
  CURLOPT_IGNORE_CONTENT_LENGTH = 136,
  CURLOPT_FTP_SKIP_PASV_IP =  137,
  CURLOPT_FTP_FILEMETHOD  =   138,
  CURLOPT_LOCALPORT       =   139,
  CURLOPT_LOCALPORTRANGE  =   140,
  CURLOPT_CONNECT_ONLY    =   141,
  CURLOPT_CONV_FROM_NETWORK_FUNCTION = 20142,
  CURLOPT_CONV_TO_NETWORK_FUNCTION = 20143,
  CURLOPT_CONV_FROM_UTF8_FUNCTION = 20144,
  CURLOPT_MAX_SEND_SPEED_LARGE = 30145,
  CURLOPT_MAX_RECV_SPEED_LARGE = 30146,
  CURLOPT_FTP_ALTERNATIVE_TO_USER = 10147,
  CURLOPT_SOCKOPTFUNCTION = 20148,
  CURLOPT_SOCKOPTDATA     = 10149,
  CURLOPT_SSL_SESSIONID_CACHE = 150,
  CURLOPT_SSH_AUTH_TYPES  =   151,
  CURLOPT_SSH_PUBLIC_KEYFILE = 10152,
  CURLOPT_SSH_PRIVATE_KEYFILE = 10153,
  CURLOPT_FTP_SSL_CCC     =   154,
  CURLOPT_TIMEOUT_MS      =   155,
  CURLOPT_CONNECTTIMEOUT_MS = 156,
  CURLOPT_HTTP_TRANSFER_DECODING = 157,
  CURLOPT_HTTP_CONTENT_DECODING = 158,
  CURLOPT_NEW_FILE_PERMS  =   159,
  CURLOPT_NEW_DIRECTORY_PERMS = 160,
  CURLOPT_POSTREDIR       =   161,
  CURLOPT_SSH_HOST_PUBLIC_KEY_MD5 = 10162,
  CURLOPT_OPENSOCKETFUNCTION = 20163,
  CURLOPT_OPENSOCKETDATA  = 10164,
  CURLOPT_COPYPOSTFIELDS  = 10165,
  CURLOPT_PROXY_TRANSFER_MODE = 166,
  CURLOPT_SEEKFUNCTION    = 20167,
  CURLOPT_SEEKDATA        = 10168,
  CURLOPT_CRLFILE         = 10169,
  CURLOPT_ISSUERCERT      = 10170,
  CURLOPT_ADDRESS_SCOPE   =   171,
  CURLOPT_CERTINFO        =   172,
  CURLOPT_USERNAME        = 10173,
  CURLOPT_PASSWORD        = 10174,
  CURLOPT_PROXYUSERNAME   = 10175,
  CURLOPT_PROXYPASSWORD   = 10176,
  CURLOPT_NOPROXY         = 10177,
  CURLOPT_TFTP_BLKSIZE    =   178,
  CURLOPT_SOCKS5_GSSAPI_SERVICE = 10179,
  CURLOPT_SOCKS5_GSSAPI_NEC =   180,
  CURLOPT_PROTOCOLS       =   181,
  CURLOPT_REDIR_PROTOCOLS =   182,
  CURLOPT_SSH_KNOWNHOSTS  = 10183,
  CURLOPT_SSH_KEYFUNCTION = 20184,
  CURLOPT_SSH_KEYDATA     = 10185,
  CURLOPT_MAIL_FROM       = 10186,
  CURLOPT_MAIL_RCPT       = 10187,
  CURLOPT_FTP_USE_PRET    =   188,
  CURLOPT_RTSP_REQUEST    =   189,
  CURLOPT_RTSP_SESSION_ID = 10190,
  CURLOPT_RTSP_STREAM_URI = 10191,
  CURLOPT_RTSP_TRANSPORT  = 10192,
  CURLOPT_RTSP_CLIENT_CSEQ =  193,
  CURLOPT_RTSP_SERVER_CSEQ =  194,
  CURLOPT_INTERLEAVEDATA  = 10195,
  CURLOPT_INTERLEAVEFUNCTION = 20196,
  CURLOPT_WILDCARDMATCH      = 197,
  CURLOPT_CHUNK_BGN_FUNCTION = 20198,
  CURLOPT_CHUNK_END_FUNCTION = 20199,
  CURLOPT_FNMATCH_FUNCTION = 20200,
  CURLOPT_CHUNK_DATA      = 10201,
  CURLOPT_FNMATCH_DATA    = 10202,
  CURLOPT_RESOLVE         = 10203,
  CURLOPT_TLSAUTH_USERNAME = 10204,
  CURLOPT_TLSAUTH_PASSWORD = 10205,
  CURLOPT_TLSAUTH_TYPE    = 10206,
  CURLOPT_TRANSFER_ENCODING = 207,
  CURLOPT_CLOSESOCKETFUNCTION = 20208,
  CURLOPT_CLOSESOCKETDATA = 10209,
  CURLOPT_GSSAPI_DELEGATION = 210,
  CURLOPT_DNS_SERVERS     = 10211,
  CURLOPT_ACCEPTTIMEOUT_MS =  212,
  CURLOPT_TCP_KEEPALIVE   =   213,
  CURLOPT_TCP_KEEPIDLE    =   214,
  CURLOPT_TCP_KEEPINTVL   =   215,
  CURLOPT_SSL_OPTIONS     =   216,
  CURLOPT_MAIL_AUTH       = 10217,
  CURLOPT_SASL_IR         =   218,
  CURLOPT_XFERINFOFUNCTION = 20219,
  CURLOPT_XOAUTH2_BEARER  = 10220,
  CURLOPT_DNS_INTERFACE   = 10221,
  CURLOPT_DNS_LOCAL_IP4   = 10222,
  CURLOPT_DNS_LOCAL_IP6   = 10223,
  CURLOPT_LOGIN_OPTIONS   = 10224,
  CURLOPT_SSL_ENABLE_NPN  =   225,
  CURLOPT_SSL_ENABLE_ALPN =   226,
  CURLOPT_EXPECT_100_TIMEOUT_MS = 227,
  CURLOPT_PROXYHEADER     = 10228,
  CURLOPT_HEADEROPT       =   229,
  CURLOPT_PINNEDPUBLICKEY = 10230,
  CURLOPT_UNIX_SOCKET_PATH = 10231,
  CURLOPT_SSL_VERIFYSTATUS =  232,
  CURLOPT_SSL_FALSESTART  =   233,
  CURLOPT_PATH_AS_IS      =   234,
  CURLOPT_PROXY_SERVICE_NAME = 10235,
  CURLOPT_SERVICE_NAME    = 10236,
  CURLOPT_PIPEWAIT        =    237,
  CURLOPT_DEFAULT_PROTOCOL = 10238,
  CURLOPT_STREAM_WEIGHT   =   239,
  CURLOPT_STREAM_DEPENDS  = 10240,
  CURLOPT_STREAM_DEPENDS_E = 10241,
  CURLOPT_TFTP_NO_OPTIONS =   242,
  CURLOPT_CONNECT_TO      = 10243,
  CURLOPT_TCP_FASTOPEN    =   244,
  CURLOPT_LASTENTRY       =   245

public type CURLoption(integer n)
  integer rem = remainder(n, 1000)
  return ((rem >= 1) and (rem <= 245))
end type

--------------------------------------------------------------------------------

public constant CURLOPT_XFERINFODATA            = CURLOPT_PROGRESSDATA
public constant CURLOPT_SERVER_RESPONSE_TIMEOUT = CURLOPT_FTP_RESPONSE_TIMEOUT

--------------------------------------------------------------------------------

-- Backwards compatibility with older names
-- These are scheduled to disappear by 2011

-- This was added in version 7.19.1
public constant CURLOPT_POST301 = CURLOPT_POSTREDIR

-- These are scheduled to disappear by 2009

-- The following were added in 7.17.0
public constant CURLOPT_SSLKEYPASSWD = CURLOPT_KEYPASSWD
public constant CURLOPT_FTPAPPEND = CURLOPT_APPEND
public constant CURLOPT_FTPLISTONLY = CURLOPT_DIRLISTONLY
public constant CURLOPT_FTP_SSL = CURLOPT_USE_SSL

-- The following were added earlier

public constant CURLOPT_SSLCERTPASSWD = CURLOPT_KEYPASSWD
public constant CURLOPT_KRB4LEVEL = CURLOPT_KRBLEVEL


--------------------------------------------------------------------------------

  -- Below here follows defines for the CURLOPT_IPRESOLVE option. If a host
  --   name resolves addresses using more than one IP protocol version, this
  --   option might be handy to force libcurl to use a specific IP version.
public constant CURL_IPRESOLVE_WHATEVER = 0
public constant CURL_IPRESOLVE_V4       = 1
public constant CURL_IPRESOLVE_V6       = 2

--------------------------------------------------------------------------------

  -- convenient "aliases" that follow the name scheme better
public constant CURLOPT_RTSPHEADER = CURLOPT_HTTPHEADER

--------------------------------------------------------------------------------

  -- These enums are for use with the CURLOPT_HTTP_VERSION option.
public constant
  CURL_HTTP_VERSION_NONE = 0,
  CURL_HTTP_VERSION_1_0  = 1,
  CURL_HTTP_VERSION_1_1  = 2,
  CURL_HTTP_VERSION_2_0  = 3,
  CURL_HTTP_VERSION_2TLS = 4,
  CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE = 5,
  CURL_HTTP_VERSION_LAST = 6

-- Convenience definition simple because the name of the version is HTTP/2 and
--   not 2.0. The 2_0 version of the public enum name was set while the version was
--   still planned to be 2.0 and we stick to it for compatibility.
public constant CURL_HTTP_VERSION_2 = CURL_HTTP_VERSION_2_0

--------------------------------------------------------------------------------

-- Public API enums for RTSP requests

public constant
  CURL_RTSPREQ_NONE          =  0,
  CURL_RTSPREQ_OPTIONS       =  1,
  CURL_RTSPREQ_DESCRIBE      =  2,
  CURL_RTSPREQ_ANNOUNCE      =  3,
  CURL_RTSPREQ_SETUP         =  4,
  CURL_RTSPREQ_PLAY          =  5,
  CURL_RTSPREQ_PAUSE         =  6,
  CURL_RTSPREQ_TEARDOWN      =  7,
  CURL_RTSPREQ_GET_PARAMETER =  8,
  CURL_RTSPREQ_SET_PARAMETER =  9,
  CURL_RTSPREQ_RECORD        = 10,
  CURL_RTSPREQ_RECEIVE       = 11,
  CURL_RTSPREQ_LAST          = 12

--------------------------------------------------------------------------------

  -- These enums are for use with the CURLOPT_NETRC option.
public constant
  CURL_NETRC_IGNORED  = 0,
  CURL_NETRC_OPTIONAL = 1,
  CURL_NETRC_REQUIRED = 2,
  CURL_NETRC_LAST     = 3

public type CURL_NETRC_OPTION(integer n)
--<type>


--</type>
  return ((n >= CURL_NETRC_IGNORED) and (n <= CURL_NETRC_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURL_SSLVERSION_DEFAULT = 0,
  CURL_SSLVERSION_TLSv1   = 1,
  CURL_SSLVERSION_SSLv2   = 2,
  CURL_SSLVERSION_SSLv3   = 3,
  CURL_SSLVERSION_TLSv1_0 = 4,
  CURL_SSLVERSION_TLSv1_1 = 5,
  CURL_SSLVERSION_TLSv1_2 = 6,
  CURL_SSLVERSION_LAST    = 7

--------------------------------------------------------------------------------

public constant
  CURL_TLSAUTH_NONE = 0,
  CURL_TLSAUTH_SRP  = 1,
  CURL_TLSAUTH_LAST = 2

public type CURL_TLSAUTH(integer n)
  return ((n >= CURL_TLSAUTH_NONE) and (n <= CURL_TLSAUTH_LAST))
end type

--------------------------------------------------------------------------------

-- symbols to use with CURLOPT_POSTREDIR.
--   CURL_REDIR_POST_301, CURL_REDIR_POST_302 and CURL_REDIR_POST_303
--   can be bitwise ORed so that CURL_REDIR_POST_301 | CURL_REDIR_POST_302
--   | CURL_REDIR_POST_303 == CURL_REDIR_POST_ALL

public constant
  CURL_REDIR_GET_ALL  = 0,
  CURL_REDIR_POST_301 = 1,
  CURL_REDIR_POST_302 = 2,
  CURL_REDIR_POST_303 = 4,
  CURL_REDIR_POST_ALL = or_all({CURL_REDIR_POST_301, CURL_REDIR_POST_302, CURL_REDIR_POST_303})

--------------------------------------------------------------------------------

public constant
  CURL_TIMECOND_NONE         = 0,
  CURL_TIMECOND_IFMODSINCE   = 1,
  CURL_TIMECOND_IFUNMODSINCE = 2,
  CURL_TIMECOND_LASTMOD      = 3,
  CURL_TIMECOND_LAST         = 4

public type curl_TimeCond(integer n)
  return ((n >= CURL_TIMECOND_NONE) and (n <= CURL_TIMECOND_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURLFORM_NOTHING        =  0,
  CURLFORM_COPYNAME       =  1,
  CURLFORM_PTRNAME        =  2,
  CURLFORM_NAMELENGTH     =  3,
  CURLFORM_COPYCONTENTS   =  4,
  CURLFORM_PTRCONTENTS    =  5,
  CURLFORM_CONTENTSLENGTH =  6,
  CURLFORM_FILECONTENT    =  7,
  CURLFORM_ARRAY          =  8,
  CURLFORM_OBSOLETE       =  9,
  CURLFORM_FILE           = 10,
  CURLFORM_BUFFER         = 11,
  CURLFORM_BUFFERPTR      = 12,
  CURLFORM_BUFFERLENGTH   = 13,
  CURLFORM_CONTENTTYPE    = 14,
  CURLFORM_CONTENTHEADER  = 15,
  CURLFORM_FILENAME       = 16,
  CURLFORM_END            = 17,
  CURLFORM_OBSOLETE2      = 18,
  CURLFORM_STREAM         = 19,
  CURLFORM_CONTENTLEN     = 20,
  CURLFORM_LASTENTRY      = 21

public type CURLformoption(integer n)
  return ((n >= CURLFORM_NOTHING) and (n <= CURLFORM_LASTENTRY))
end type

--------------------------------------------------------------------------------

public constant
  CURL_FORMADD_OK             = 0,
  CURL_FORMADD_MEMORY         = 1,
  CURL_FORMADD_OPTION_TWICE   = 2,
  CURL_FORMADD_NULL           = 3,
  CURL_FORMADD_UNKNOWN_OPTION = 4,
  CURL_FORMADD_INCOMPLETE     = 5,
  CURL_FORMADD_ILLEGAL_ARRAY  = 6,
  CURL_FORMADD_DISABLED       = 7,
  CURL_FORMADD_LAST           = 8

public type CURLFORMcode(integer n)
  return ((n >= CURL_FORMADD_OK) and (n <= CURL_FORMADD_LAST))
end type

--------------------------------------------------------------------------------

-- use this for multipart formpost building
-- Returns code for curl_formadd()
--
-- Returns:
-- CURL_FORMADD_OK             on success
-- CURL_FORMADD_MEMORY         if the FormInfo allocation fails
-- CURL_FORMADD_OPTION_TWICE   if one option is given twice for one Form
-- CURL_FORMADD_NULL           if a null pointer was given for a char
-- CURL_FORMADD_MEMORY         if the allocation of a FormInfo struct failed
-- CURL_FORMADD_UNKNOWN_OPTION if an unknown option was used
-- CURL_FORMADD_INCOMPLETE     if the some FormInfo is not complete (or error)
-- CURL_FORMADD_MEMORY         if a curl_httppost struct cannot be allocated
-- CURL_FORMADD_MEMORY         if some allocation for string copying failed.
-- CURL_FORMADD_ILLEGAL_ARRAY  if an illegal option is used in an array
--

--------------------------------------------------------------------------------

-- public enum for the different supported SSL backends
public constant
  CURLSSLBACKEND_NONE      =  0,
  CURLSSLBACKEND_OPENSSL   =  1,
  CURLSSLBACKEND_GNUTLS    =  2,
  CURLSSLBACKEND_NSS       =  3,
  CURLSSLBACKEND_OBSOLETE4 =  4,
  CURLSSLBACKEND_GSKIT     =  5,
  CURLSSLBACKEND_POLARSSL  =  6,
  CURLSSLBACKEND_CYASSL    =  7,
  CURLSSLBACKEND_SCHANNEL  =  8,
  CURLSSLBACKEND_DARWINSSL =  9,
  CURLSSLBACKEND_AXTLS     = 10,
  CURLSSLBACKEND_MBEDTLS   = 11

public type curl_sslbackend(integer n)
  return ((n >= CURLSSLBACKEND_NONE) and (n <= CURLSSLBACKEND_MBEDTLS))
end type

-- aliases for library clones and renames
public constant
  CURLSSLBACKEND_LIBRESSL  = 1,
  CURLSSLBACKEND_BORINGSSL = 1,
  CURLSSLBACKEND_WOLFSSL   = 6

--------------------------------------------------------------------------------

public constant
  CURLINFO_STRING   = #100000,
  CURLINFO_LONG     = #200000,
  CURLINFO_DOUBLE   = #300000,
  CURLINFO_SLIST    = #400000,
  CURLINFO_SOCKET   = #500000,
  CURLINFO_MASK     = #0FFFFF,
  CURLINFO_TYPEMASK = #F00000

public constant
  CURLINFO_NONE             = 0,
  CURLINFO_EFFECTIVE_URL    = CURLINFO_STRING + 1,
  CURLINFO_RESPONSE_CODE    = CURLINFO_LONG   + 2,
  CURLINFO_TOTAL_TIME       = CURLINFO_DOUBLE + 3,
  CURLINFO_NAMELOOKUP_TIME  = CURLINFO_DOUBLE + 4,
  CURLINFO_CONNECT_TIME     = CURLINFO_DOUBLE + 5,
  CURLINFO_PRETRANSFER_TIME = CURLINFO_DOUBLE + 6,
  CURLINFO_SIZE_UPLOAD      = CURLINFO_DOUBLE + 7,
  CURLINFO_SIZE_DOWNLOAD    = CURLINFO_DOUBLE + 8,
  CURLINFO_SPEED_DOWNLOAD   = CURLINFO_DOUBLE + 9,
  CURLINFO_SPEED_UPLOAD     = CURLINFO_DOUBLE + 10,
  CURLINFO_HEADER_SIZE      = CURLINFO_LONG   + 11,
  CURLINFO_REQUEST_SIZE     = CURLINFO_LONG   + 12,
  CURLINFO_SSL_VERIFYRESULT = CURLINFO_LONG   + 13,
  CURLINFO_FILETIME         = CURLINFO_LONG   + 14,
  CURLINFO_CONTENT_LENGTH_DOWNLOAD   = CURLINFO_DOUBLE + 15,
  CURLINFO_CONTENT_LENGTH_UPLOAD     = CURLINFO_DOUBLE + 16,
  CURLINFO_STARTTRANSFER_TIME = CURLINFO_DOUBLE + 17,
  CURLINFO_CONTENT_TYPE     = CURLINFO_STRING + 18,
  CURLINFO_REDIRECT_TIME    = CURLINFO_DOUBLE + 19,
  CURLINFO_REDIRECT_COUNT   = CURLINFO_LONG   + 20,
  CURLINFO_PRIVATE          = CURLINFO_STRING + 21,
  CURLINFO_HTTP_CONNECTCODE = CURLINFO_LONG   + 22,
  CURLINFO_HTTPAUTH_AVAIL   = CURLINFO_LONG   + 23,
  CURLINFO_PROXYAUTH_AVAIL  = CURLINFO_LONG   + 24,
  CURLINFO_OS_ERRNO         = CURLINFO_LONG   + 25,
  CURLINFO_NUM_CONNECTS     = CURLINFO_LONG   + 26,
  CURLINFO_SSL_ENGINES      = CURLINFO_SLIST  + 27,
  CURLINFO_COOKIELIST       = CURLINFO_SLIST  + 28,
  CURLINFO_LASTSOCKET       = CURLINFO_LONG   + 29,
  CURLINFO_FTP_ENTRY_PATH   = CURLINFO_STRING + 30,
  CURLINFO_REDIRECT_URL     = CURLINFO_STRING + 31,
  CURLINFO_PRIMARY_IP       = CURLINFO_STRING + 32,
  CURLINFO_APPCONNECT_TIME  = CURLINFO_DOUBLE + 33,
  CURLINFO_CERTINFO         = CURLINFO_SLIST  + 34,
  CURLINFO_CONDITION_UNMET  = CURLINFO_LONG   + 35,
  CURLINFO_RTSP_SESSION_ID  = CURLINFO_STRING + 36,
  CURLINFO_RTSP_CLIENT_CSEQ = CURLINFO_LONG   + 37,
  CURLINFO_RTSP_SERVER_CSEQ = CURLINFO_LONG   + 38,
  CURLINFO_RTSP_CSEQ_RECV   = CURLINFO_LONG   + 39,
  CURLINFO_PRIMARY_PORT     = CURLINFO_LONG   + 40,
  CURLINFO_LOCAL_IP         = CURLINFO_STRING + 41,
  CURLINFO_LOCAL_PORT       = CURLINFO_LONG   + 42,
  CURLINFO_TLS_SESSION      = CURLINFO_SLIST  + 43,
  CURLINFO_ACTIVESOCKET     = CURLINFO_SOCKET + 44,
  CURLINFO_TLS_SSL_PTR      = CURLINFO_SLIST  + 45,
  CURLINFO_HTTP_VERSION     = CURLINFO_LONG   + 46,
  -- Fill in new entries below here!

  CURLINFO_LASTONE          = 46

public type CURLINFO(integer n)
  integer rem = and_bits(n, #0000FF)
  return ((rem >= #0) and (rem <= #2F))
end type

-- CURLINFO_RESPONSE_CODE is the new name for the option previously known as
--   CURLINFO_HTTP_CODE
public constant CURLINFO_HTTP_CODE = CURLINFO_RESPONSE_CODE

--------------------------------------------------------------------------------

public constant
  CURLCLOSEPOLICY_NONE                = 0,
  CURLCLOSEPOLICY_OLDEST              = 1,
  CURLCLOSEPOLICY_LEAST_RECENTLY_USED = 2,
  CURLCLOSEPOLICY_LEAST_TRAFFIC       = 3,
  CURLCLOSEPOLICY_SLOWEST             = 4,
  CURLCLOSEPOLICY_CALLBACK            = 5,
  CURLCLOSEPOLICY_LAST                = 6

public type curl_closepolicy(integer n)
  return ((n >= CURLCLOSEPOLICY_NONE) and (n <= CURLCLOSEPOLICY_LAST))
end type

--------------------------------------------------------------------------------

public constant CURL_GLOBAL_SSL       = 1
public constant CURL_GLOBAL_WIN32     = 2
public constant CURL_GLOBAL_ALL       = or_bits(CURL_GLOBAL_SSL, CURL_GLOBAL_WIN32)
public constant CURL_GLOBAL_NOTHING   = 0
public constant CURL_GLOBAL_DEFAULT   = CURL_GLOBAL_ALL
public constant CURL_GLOBAL_ACK_EINTR = 4

--------------------------------------------------------------------------------
-- Setup defines, protos etc for the sharing stuff.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

-- Different data locks for a single share
public constant
  CURL_LOCK_DATA_NONE        = 0,
  CURL_LOCK_DATA_SHARE       = 1,
  CURL_LOCK_DATA_COOKIE      = 2,
  CURL_LOCK_DATA_DNS         = 3,
  CURL_LOCK_DATA_SSL_SESSION = 4,
  CURL_LOCK_DATA_CONNECT     = 5,
  CURL_LOCK_DATA_LAST        = 6

public type curl_lock_data(integer n)
  return ((n >= CURL_LOCK_DATA_NONE) and (n <= CURL_LOCK_DATA_LAST))
end type

--------------------------------------------------------------------------------

-- Different lock access types
public constant
  CURL_LOCK_ACCESS_NONE   = 0,
  CURL_LOCK_ACCESS_SHARED = 1,
  CURL_LOCK_ACCESS_SINGLE = 2,
  CURL_LOCK_ACCESS_LAST   = 4

public type curl_lock_access(integer n)
  return ((n >= CURL_LOCK_ACCESS_NONE) and (n <= CURL_LOCK_ACCESS_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURLVERSION_FIRST  = 0,
  CURLVERSION_SECOND = 1,
  CURLVERSION_THIRD  = 2,
  CURLVERSION_FOURTH = 3,
  CURLVERSION_LAST   = 4

public type CURLversion(integer n)
  return ((n >= CURLVERSION_FIRST) and (n <= CURLVERSION_LAST))
end type

public constant CURLVERSION_NOW = CURLVERSION_FOURTH

public constant
  CURL_VERSION_IPV6         =       1,
  CURL_VERSION_KERBEROS4    =       2,
  CURL_VERSION_SSL          =       4,
  CURL_VERSION_LIBZ         =       8,
  CURL_VERSION_NTLM         =      16,
  CURL_VERSION_GSSNEGOTIATE =      32,
  CURL_VERSION_DEBUG        =      64,
  CURL_VERSION_ASYNCHDNS    =     128,
  CURL_VERSION_SPNEGO       =     256,
  CURL_VERSION_LARGEFILE    =     512,
  CURL_VERSION_IDN          =   1024,
  CURL_VERSION_SSPI         =    2048,
  CURL_VERSION_CONV         =    4096,
  CURL_VERSION_CURLDEBUG    =    8192,
  CURL_VERSION_TLSAUTH_SRP  =   16384,
  CURL_VERSION_NTLM_WB      =   32768,
  CURL_VERSION_HTTP2        =   65536,
  CURL_VERSION_GSSAPI       =  131072,
  CURL_VERSION_KERBEROS5    =  262144,
  CURL_VERSION_UNIX_SOCKETS =  524288,
  CURL_VERSION_PSL          = 1048576

--------------------------------------------------------------------------------

public constant CURLPAUSE_RECV      = 1
public constant CURLPAUSE_RECV_CONT = 0
public constant CURLPAUSE_SEND      = 4
public constant CURLPAUSE_SEND_CONT = 0

public constant CURLPAUSE_ALL  = or_bits(CURLPAUSE_RECV, CURLPAUSE_SEND)
public constant CURLPAUSE_CONT = or_bits(CURLPAUSE_RECV_CONT, CURLPAUSE_SEND_CONT)

public constant
  HTTP_STATUS=1, HTTP_URL=2, HTTP_HEADERS=3, HTTP_BODY=4

atom dll = open_dll({
  "libcurl.dll",                             -- WIN_32
  "/usr/lib/x86_64-linux-gnu/libcurl.so.4",  -- LNX_64
  "/usr/lib/i386-linux-gnu/libcurl.so.4"     -- LNX_32
}) 

constant
  xcurl_strequal        = define_c_func(dll, "+curl_strequal",        {C_POINTER, C_POINTER}, C_INT),
  xcurl_strnequal       = define_c_func(dll, "+curl_strnequal",       {C_POINTER, C_POINTER, C_SIZE_T}, C_INT),
  xcurl_formadd         = define_c_func(dll, "+curl_formadd",         {C_POINTER, C_POINTER, C_POINTER}, C_INT),
  xcurl_formget         = define_c_func(dll, "+curl_formget",         {C_POINTER, C_POINTER, C_POINTER}, C_INT),
  xcurl_formfree        = define_c_proc(dll, "+curl_formfree",        {C_POINTER} ),
  xcurl_getenv          = define_c_func(dll, "+curl_getenv",          {C_POINTER}, C_POINTER),
  xcurl_version         = define_c_func(dll, "+curl_version",         {}, C_POINTER),
  xcurl_easy_escape     = define_c_func(dll, "+curl_easy_escape",     {C_POINTER, C_POINTER, C_INT}, C_POINTER),
  xcurl_escape          = define_c_func(dll, "+curl_escape",          {C_POINTER, C_INT}, C_POINTER),
  xcurl_easy_unescape   = define_c_func(dll, "+curl_easy_unescape",   {C_POINTER, C_POINTER, C_INT, C_POINTER}, C_POINTER),
  xcurl_unescape        = define_c_func(dll, "+curl_unescape",        {C_POINTER, C_INT}, C_POINTER),
  xcurl_free            = define_c_proc(dll, "+curl_free",            {C_POINTER} ),
  xcurl_global_init     = define_c_func(dll, "+curl_global_init",     {C_LONG}, C_INT),
  xcurl_global_init_mem = define_c_func(dll, "+curl_global_init_mem", {C_LONG, C_POINTER, C_POINTER, C_POINTER, C_POINTER,
                                                                       C_POINTER}, C_INT),
  xcurl_global_cleanup  = define_c_proc(dll, "+curl_global_cleanup",  {} ),
  xcurl_slist_append    = define_c_func(dll, "+curl_slist_append",    {C_POINTER, C_POINTER}, C_POINTER),
  xcurl_slist_free_all  = define_c_proc(dll, "+curl_slist_free_all",  {C_POINTER} ),
  xcurl_getdate         = define_c_func(dll, "+curl_getdate",         {C_POINTER, C_POINTER}, C_POINTER),
  xcurl_version_info    = define_c_func(dll, "+curl_version_info",    {C_POINTER}, C_POINTER),
  xcurl_easy_strerror   = define_c_func(dll, "+curl_easy_strerror",   {C_INT}, C_POINTER),
  xcurl_easy_pause      = define_c_func(dll, "+curl_easy_pause",      {C_POINTER, C_INT}, C_INT),
  xcurl_easy_init       = define_c_func(dll, "+curl_easy_init",       {}, C_POINTER),
  xcurl_easy_setopt     = define_c_func(dll, "+curl_easy_setopt",     {C_POINTER, C_INT, C_POINTER}, C_INT),
  xcurl_easy_perform    = define_c_func(dll, "+curl_easy_perform",    {C_POINTER}, C_INT),
  xcurl_easy_cleanup    = define_c_proc(dll, "+curl_easy_cleanup",    {C_POINTER} ),
  xcurl_easy_getinfo    = define_c_func(dll, "+curl_easy_getinfo",    {C_POINTER, C_INT, C_POINTER}, C_INT),
  xcurl_easy_duphandle  = define_c_func(dll, "+curl_easy_duphandle",  {C_POINTER}, C_POINTER),
  xcurl_easy_reset      = define_c_proc(dll, "+curl_easy_reset",      {C_POINTER} ),
  xcurl_easy_recv       = define_c_func(dll, "+curl_easy_recv",       {C_POINTER, C_POINTER, C_SIZE_T, C_POINTER}, C_INT),
  xcurl_easy_send       = define_c_func(dll, "+curl_easy_send",       {C_POINTER, C_POINTER, C_SIZE_T, C_POINTER}, C_INT)


-- public atom curl_options_list
-- curl_options_list = NULL

--------------------------------------------------------------------------------

constant SETOPT_OPTIONS = {
  {CURLOPT_ACCEPTTIMEOUT_MS,            "CURLOPT_ACCEPTTIMEOUT_MS"},
  {CURLOPT_ACCEPT_ENCODING,             "CURLOPT_ACCEPT_ENCODING"},
  {CURLOPT_ADDRESS_SCOPE,               "CURLOPT_ADDRESS_SCOPE"},
  {CURLOPT_APPEND,                      "CURLOPT_APPEND"},
  {CURLOPT_AUTOREFERER,                 "CURLOPT_AUTOREFERER"},
  {CURLOPT_BUFFERSIZE,                  "CURLOPT_BUFFERSIZE"},
  {CURLOPT_CAINFO,                      "CURLOPT_CAINFO"},
  {CURLOPT_CAPATH,                      "CURLOPT_CAPATH"},
  {CURLOPT_CERTINFO,                    "CURLOPT_CERTINFO"},
  {CURLOPT_CHUNK_BGN_FUNCTION,          "CURLOPT_CHUNK_BGN_FUNCTION"},
  {CURLOPT_CHUNK_DATA,                  "CURLOPT_CHUNK_DATA"},
  {CURLOPT_CHUNK_END_FUNCTION,          "CURLOPT_CHUNK_END_FUNCTION"},
  {CURLOPT_CLOSESOCKETDATA,             "CURLOPT_CLOSESOCKETDATA"},
  {CURLOPT_CLOSESOCKETFUNCTION,         "CURLOPT_CLOSESOCKETFUNCTION"},
  {CURLOPT_CONNECTTIMEOUT,              "CURLOPT_CONNECTTIMEOUT"},
  {CURLOPT_CONNECTTIMEOUT_MS,           "CURLOPT_CONNECTTIMEOUT_MS"},
  {CURLOPT_CONNECT_ONLY,                "CURLOPT_CONNECT_ONLY"},
  {CURLOPT_CONNECT_TO,                  "CURLOPT_CONNECT_TO"},
  {CURLOPT_CONV_FROM_NETWORK_FUNCTION,  "CURLOPT_CONV_FROM_NETWORK_FUNCTION"},
  {CURLOPT_CONV_FROM_UTF8_FUNCTION,     "CURLOPT_CONV_FROM_UTF8_FUNCTION"},
  {CURLOPT_CONV_TO_NETWORK_FUNCTION,    "CURLOPT_CONV_TO_NETWORK_FUNCTION"},
  {CURLOPT_COOKIE,                      "CURLOPT_COOKIE"},
  {CURLOPT_COOKIEFILE,                  "CURLOPT_COOKIEFILE"},
  {CURLOPT_COOKIEJAR,                   "CURLOPT_COOKIEJAR"},
  {CURLOPT_COOKIELIST,                  "CURLOPT_COOKIELIST"},
  {CURLOPT_COOKIESESSION,               "CURLOPT_COOKIESESSION"},
  {CURLOPT_COPYPOSTFIELDS,              "CURLOPT_COPYPOSTFIELDS"},
  {CURLOPT_CRLF,                        "CURLOPT_CRLF"},
  {CURLOPT_CRLFILE,                     "CURLOPT_CRLFILE"},
  {CURLOPT_CUSTOMREQUEST,               "CURLOPT_CUSTOMREQUEST"},
  {CURLOPT_DEBUGDATA,                   "CURLOPT_DEBUGDATA"},
  {CURLOPT_DEBUGFUNCTION,               "CURLOPT_DEBUGFUNCTION"},
  {CURLOPT_DEFAULT_PROTOCOL,            "CURLOPT_DEFAULT_PROTOCOL"},
  {CURLOPT_DIRLISTONLY,                 "CURLOPT_DIRLISTONLY"},
  {CURLOPT_DNS_CACHE_TIMEOUT,           "CURLOPT_DNS_CACHE_TIMEOUT"},
  {CURLOPT_DNS_INTERFACE,               "CURLOPT_DNS_INTERFACE"},
  {CURLOPT_DNS_LOCAL_IP4,               "CURLOPT_DNS_LOCAL_IP4"},
  {CURLOPT_DNS_LOCAL_IP6,               "CURLOPT_DNS_LOCAL_IP6"},
  {CURLOPT_DNS_SERVERS,                 "CURLOPT_DNS_SERVERS"},
  {CURLOPT_DNS_USE_GLOBAL_CACHE,        "CURLOPT_DNS_USE_GLOBAL_CACHE"},
  {CURLOPT_EGDSOCKET,                   "CURLOPT_EGDSOCKET"},
  {CURLOPT_ERRORBUFFER,                 "CURLOPT_ERRORBUFFER"},
  {CURLOPT_EXPECT_100_TIMEOUT_MS,       "CURLOPT_EXPECT_100_TIMEOUT_MS"},
  {CURLOPT_FAILONERROR,                 "CURLOPT_FAILONERROR"},
  {CURLOPT_FILETIME,                    "CURLOPT_FILETIME"},
  {CURLOPT_FNMATCH_DATA,                "CURLOPT_FNMATCH_DATA"},
  {CURLOPT_FNMATCH_FUNCTION,            "CURLOPT_FNMATCH_FUNCTION"},
  {CURLOPT_FOLLOWLOCATION,              "CURLOPT_FOLLOWLOCATION"},
  {CURLOPT_FORBID_REUSE,                "CURLOPT_FORBID_REUSE"},
  {CURLOPT_FRESH_CONNECT,               "CURLOPT_FRESH_CONNECT"},
  {CURLOPT_FTPPORT,                     "CURLOPT_FTPPORT"},
  {CURLOPT_FTPSSLAUTH,                  "CURLOPT_FTPSSLAUTH"},
  {CURLOPT_FTP_ACCOUNT,                 "CURLOPT_FTP_ACCOUNT"},
  {CURLOPT_FTP_ALTERNATIVE_TO_USER,     "CURLOPT_FTP_ALTERNATIVE_TO_USER"},
  {CURLOPT_FTP_CREATE_MISSING_DIRS,     "CURLOPT_FTP_CREATE_MISSING_DIRS"},
  {CURLOPT_FTP_FILEMETHOD,              "CURLOPT_FTP_FILEMETHOD"},
  {CURLOPT_FTP_RESPONSE_TIMEOUT,        "CURLOPT_FTP_RESPONSE_TIMEOUT"},
  {CURLOPT_FTP_SKIP_PASV_IP,            "CURLOPT_FTP_SKIP_PASV_IP"},
  {CURLOPT_FTP_SSL_CCC,                 "CURLOPT_FTP_SSL_CCC"},
  {CURLOPT_FTP_USE_EPRT,                "CURLOPT_FTP_USE_EPRT"},
  {CURLOPT_FTP_USE_EPSV,                "CURLOPT_FTP_USE_EPSV"},
  {CURLOPT_FTP_USE_PRET,                "CURLOPT_FTP_USE_PRET"},
  {CURLOPT_GSSAPI_DELEGATION,           "CURLOPT_GSSAPI_DELEGATION"},
  {CURLOPT_HEADER,                      "CURLOPT_HEADER"},
  {CURLOPT_HEADERDATA,                  "CURLOPT_HEADERDATA"},
  {CURLOPT_HEADERFUNCTION,              "CURLOPT_HEADERFUNCTION"},
  {CURLOPT_HEADEROPT,                   "CURLOPT_HEADEROPT"},
  {CURLOPT_HTTP200ALIASES,              "CURLOPT_HTTP200ALIASES"},
  {CURLOPT_HTTPAUTH,                    "CURLOPT_HTTPAUTH"},
  {CURLOPT_HTTPGET,                     "CURLOPT_HTTPGET"},
  {CURLOPT_HTTPHEADER,                  "CURLOPT_HTTPHEADER"},
  {CURLOPT_HTTPPOST,                    "CURLOPT_HTTPPOST"},
  {CURLOPT_HTTPPROXYTUNNEL,             "CURLOPT_HTTPPROXYTUNNEL"},
  {CURLOPT_HTTP_CONTENT_DECODING,       "CURLOPT_HTTP_CONTENT_DECODING"},
  {CURLOPT_HTTP_TRANSFER_DECODING,      "CURLOPT_HTTP_TRANSFER_DECODING"},
  {CURLOPT_HTTP_VERSION,                "CURLOPT_HTTP_VERSION"},
  {CURLOPT_IGNORE_CONTENT_LENGTH,       "CURLOPT_IGNORE_CONTENT_LENGTH"},
  {CURLOPT_INFILESIZE,                  "CURLOPT_INFILESIZE"},
  {CURLOPT_INFILESIZE_LARGE,            "CURLOPT_INFILESIZE_LARGE"},
  {CURLOPT_INTERFACE,                   "CURLOPT_INTERFACE"},
  {CURLOPT_INTERLEAVEDATA,              "CURLOPT_INTERLEAVEDATA"},
  {CURLOPT_INTERLEAVEFUNCTION,          "CURLOPT_INTERLEAVEFUNCTION"},
  {CURLOPT_IOCTLDATA,                   "CURLOPT_IOCTLDATA"},
  {CURLOPT_IOCTLFUNCTION,               "CURLOPT_IOCTLFUNCTION"},
  {CURLOPT_IPRESOLVE,                   "CURLOPT_IPRESOLVE"},
  {CURLOPT_ISSUERCERT,                  "CURLOPT_ISSUERCERT"},
  {CURLOPT_KEYPASSWD,                   "CURLOPT_KEYPASSWD"},
  {CURLOPT_KRBLEVEL,                    "CURLOPT_KRBLEVEL"},
  {CURLOPT_LOCALPORT,                   "CURLOPT_LOCALPORT"},
  {CURLOPT_LOCALPORTRANGE,              "CURLOPT_LOCALPORTRANGE"},
  {CURLOPT_LOGIN_OPTIONS,               "CURLOPT_LOGIN_OPTIONS"},
  {CURLOPT_LOW_SPEED_LIMIT,             "CURLOPT_LOW_SPEED_LIMIT"},
  {CURLOPT_LOW_SPEED_TIME,              "CURLOPT_LOW_SPEED_TIME"},
  {CURLOPT_MAIL_AUTH,                   "CURLOPT_MAIL_AUTH"},
  {CURLOPT_MAIL_FROM,                   "CURLOPT_MAIL_FROM"},
  {CURLOPT_MAIL_RCPT,                   "CURLOPT_MAIL_RCPT"},
  {CURLOPT_MAXCONNECTS,                 "CURLOPT_MAXCONNECTS"},
  {CURLOPT_MAXFILESIZE,                 "CURLOPT_MAXFILESIZE"},
  {CURLOPT_MAXFILESIZE_LARGE,           "CURLOPT_MAXFILESIZE_LARGE"},
  {CURLOPT_MAXREDIRS,                   "CURLOPT_MAXREDIRS"},
  {CURLOPT_MAX_RECV_SPEED_LARGE,        "CURLOPT_MAX_RECV_SPEED_LARGE"},
  {CURLOPT_MAX_SEND_SPEED_LARGE,        "CURLOPT_MAX_SEND_SPEED_LARGE"},
  {CURLOPT_NETRC,                       "CURLOPT_NETRC"},
  {CURLOPT_NETRC_FILE,                  "CURLOPT_NETRC_FILE"},
  {CURLOPT_NEW_DIRECTORY_PERMS,         "CURLOPT_NEW_DIRECTORY_PERMS"},
  {CURLOPT_NEW_FILE_PERMS,              "CURLOPT_NEW_FILE_PERMS"},
  {CURLOPT_NOBODY,                      "CURLOPT_NOBODY"},
  {CURLOPT_NOPROGRESS,                  "CURLOPT_NOPROGRESS"},
  {CURLOPT_NOPROXY,                     "CURLOPT_NOPROXY"},
  {CURLOPT_NOSIGNAL,                    "CURLOPT_NOSIGNAL"},
  {CURLOPT_OPENSOCKETDATA,              "CURLOPT_OPENSOCKETDATA"},
  {CURLOPT_OPENSOCKETFUNCTION,          "CURLOPT_OPENSOCKETFUNCTION"},
  {CURLOPT_PASSWORD,                    "CURLOPT_PASSWORD"},
  {CURLOPT_PATH_AS_IS,                  "CURLOPT_PATH_AS_IS"},
  {CURLOPT_PINNEDPUBLICKEY,             "CURLOPT_PINNEDPUBLICKEY"},
  {CURLOPT_PIPEWAIT,                    "CURLOPT_PIPEWAIT"},
  {CURLOPT_PORT,                        "CURLOPT_PORT"},
  {CURLOPT_POST,                        "CURLOPT_POST"},
  {CURLOPT_POSTFIELDS,                  "CURLOPT_POSTFIELDS"},
  {CURLOPT_POSTFIELDSIZE,               "CURLOPT_POSTFIELDSIZE"},
  {CURLOPT_POSTFIELDSIZE_LARGE,         "CURLOPT_POSTFIELDSIZE_LARGE"},
  {CURLOPT_POSTQUOTE,                   "CURLOPT_POSTQUOTE"},
  {CURLOPT_POSTREDIR,                   "CURLOPT_POSTREDIR"},
  {CURLOPT_PREQUOTE,                    "CURLOPT_PREQUOTE"},
  {CURLOPT_PRIVATE,                     "CURLOPT_PRIVATE"},
  {CURLOPT_PROGRESSDATA,                "CURLOPT_PROGRESSDATA"},
  {CURLOPT_PROGRESSFUNCTION,            "CURLOPT_PROGRESSFUNCTION"},
  {CURLOPT_PROTOCOLS,                   "CURLOPT_PROTOCOLS"},
  {CURLOPT_PROXY,                       "CURLOPT_PROXY"},
  {CURLOPT_PROXYAUTH,                   "CURLOPT_PROXYAUTH"},
  {CURLOPT_PROXYHEADER,                 "CURLOPT_PROXYHEADER"},
  {CURLOPT_PROXYPASSWORD,               "CURLOPT_PROXYPASSWORD"},
  {CURLOPT_PROXYPORT,                   "CURLOPT_PROXYPORT"},
  {CURLOPT_PROXYTYPE,                   "CURLOPT_PROXYTYPE"},
  {CURLOPT_PROXYUSERNAME,               "CURLOPT_PROXYUSERNAME"},
  {CURLOPT_PROXYUSERPWD,                "CURLOPT_PROXYUSERPWD"},
  {CURLOPT_PROXY_SERVICE_NAME,          "CURLOPT_PROXY_SERVICE_NAME"},
  {CURLOPT_PROXY_TRANSFER_MODE,         "CURLOPT_PROXY_TRANSFER_MODE"},
  {CURLOPT_PUT,                         "CURLOPT_PUT"},
  {CURLOPT_QUOTE,                       "CURLOPT_QUOTE"},
  {CURLOPT_RANDOM_FILE,                 "CURLOPT_RANDOM_FILE"},
  {CURLOPT_RANGE,                       "CURLOPT_RANGE"},
  {CURLOPT_READDATA,                    "CURLOPT_READDATA"},
  {CURLOPT_READFUNCTION,                "CURLOPT_READFUNCTION"},
  {CURLOPT_REDIR_PROTOCOLS,             "CURLOPT_REDIR_PROTOCOLS"},
  {CURLOPT_REFERER,                     "CURLOPT_REFERER"},
  {CURLOPT_RESOLVE,                     "CURLOPT_RESOLVE"},
  {CURLOPT_RESUME_FROM,                 "CURLOPT_RESUME_FROM"},
  {CURLOPT_RESUME_FROM_LARGE,           "CURLOPT_RESUME_FROM_LARGE"},
  {CURLOPT_RTSP_CLIENT_CSEQ,            "CURLOPT_RTSP_CLIENT_CSEQ"},
  {CURLOPT_RTSP_REQUEST,                "CURLOPT_RTSP_REQUEST"},
  {CURLOPT_RTSP_SERVER_CSEQ,            "CURLOPT_RTSP_SERVER_CSEQ"},
  {CURLOPT_RTSP_SESSION_ID,             "CURLOPT_RTSP_SESSION_ID"},
  {CURLOPT_RTSP_STREAM_URI,             "CURLOPT_RTSP_STREAM_URI"},
  {CURLOPT_RTSP_TRANSPORT,              "CURLOPT_RTSP_TRANSPORT"},
  {CURLOPT_SASL_IR,                     "CURLOPT_SASL_IR"},
  {CURLOPT_SEEKDATA,                    "CURLOPT_SEEKDATA"},
  {CURLOPT_SEEKFUNCTION,                "CURLOPT_SEEKFUNCTION"},
  {CURLOPT_SERVICE_NAME,                "CURLOPT_SERVICE_NAME"},
  {CURLOPT_SHARE,                       "CURLOPT_SHARE"},
  {CURLOPT_SOCKOPTDATA,                 "CURLOPT_SOCKOPTDATA"},
  {CURLOPT_SOCKOPTFUNCTION,             "CURLOPT_SOCKOPTFUNCTION"},
  {CURLOPT_SOCKS5_GSSAPI_NEC,           "CURLOPT_SOCKS5_GSSAPI_NEC"},
  {CURLOPT_SOCKS5_GSSAPI_SERVICE,       "CURLOPT_SOCKS5_GSSAPI_SERVICE"},
  {CURLOPT_SSH_AUTH_TYPES,              "CURLOPT_SSH_AUTH_TYPES"},
  {CURLOPT_SSH_HOST_PUBLIC_KEY_MD5,     "CURLOPT_SSH_HOST_PUBLIC_KEY_MD5"},
  {CURLOPT_SSH_KEYDATA,                 "CURLOPT_SSH_KEYDATA"},
  {CURLOPT_SSH_KEYFUNCTION,             "CURLOPT_SSH_KEYFUNCTION"},
  {CURLOPT_SSH_KNOWNHOSTS,              "CURLOPT_SSH_KNOWNHOSTS"},
  {CURLOPT_SSH_PRIVATE_KEYFILE,         "CURLOPT_SSH_PRIVATE_KEYFILE"},
  {CURLOPT_SSH_PUBLIC_KEYFILE,          "CURLOPT_SSH_PUBLIC_KEYFILE"},
  {CURLOPT_SSLCERT,                     "CURLOPT_SSLCERT"},
  {CURLOPT_SSLCERTTYPE,                 "CURLOPT_SSLCERTTYPE"},
  {CURLOPT_SSLENGINE,                   "CURLOPT_SSLENGINE"},
  {CURLOPT_SSLENGINE_DEFAULT,           "CURLOPT_SSLENGINE_DEFAULT"},
  {CURLOPT_SSLKEY,                      "CURLOPT_SSLKEY"},
  {CURLOPT_SSLKEYTYPE,                  "CURLOPT_SSLKEYTYPE"},
  {CURLOPT_SSLVERSION,                  "CURLOPT_SSLVERSION"},
  {CURLOPT_SSL_CIPHER_LIST,             "CURLOPT_SSL_CIPHER_LIST"},
  {CURLOPT_SSL_CTX_DATA,                "CURLOPT_SSL_CTX_DATA"},
  {CURLOPT_SSL_CTX_FUNCTION,            "CURLOPT_SSL_CTX_FUNCTION"},
  {CURLOPT_SSL_ENABLE_ALPN,             "CURLOPT_SSL_ENABLE_ALPN"},
  {CURLOPT_SSL_ENABLE_NPN,              "CURLOPT_SSL_ENABLE_NPN"},
  {CURLOPT_SSL_FALSESTART,              "CURLOPT_SSL_FALSESTART"},
  {CURLOPT_SSL_OPTIONS,                 "CURLOPT_SSL_OPTIONS"},
  {CURLOPT_SSL_SESSIONID_CACHE,         "CURLOPT_SSL_SESSIONID_CACHE"},
  {CURLOPT_SSL_VERIFYHOST,              "CURLOPT_SSL_VERIFYHOST"},
  {CURLOPT_SSL_VERIFYPEER,              "CURLOPT_SSL_VERIFYPEER"},
  {CURLOPT_SSL_VERIFYSTATUS,            "CURLOPT_SSL_VERIFYSTATUS"},
  {CURLOPT_STDERR,                      "CURLOPT_STDERR"},
  {CURLOPT_STREAM_DEPENDS,              "CURLOPT_STREAM_DEPENDS"},
  {CURLOPT_STREAM_DEPENDS_E,            "CURLOPT_STREAM_DEPENDS_E"},
  {CURLOPT_STREAM_WEIGHT,               "CURLOPT_STREAM_WEIGHT"},
  {CURLOPT_TCP_FASTOPEN,                "CURLOPT_TCP_FASTOPEN"},
  {CURLOPT_TCP_KEEPALIVE,               "CURLOPT_TCP_KEEPALIVE"},
  {CURLOPT_TCP_KEEPIDLE,                "CURLOPT_TCP_KEEPIDLE"},
  {CURLOPT_TCP_KEEPINTVL,               "CURLOPT_TCP_KEEPINTVL"},
  {CURLOPT_TCP_NODELAY,                 "CURLOPT_TCP_NODELAY"},
  {CURLOPT_TELNETOPTIONS,               "CURLOPT_TELNETOPTIONS"},
  {CURLOPT_TFTP_BLKSIZE,                "CURLOPT_TFTP_BLKSIZE"},
  {CURLOPT_TFTP_NO_OPTIONS,             "CURLOPT_TFTP_NO_OPTIONS"},
  {CURLOPT_TIMECONDITION,               "CURLOPT_TIMECONDITION"},
  {CURLOPT_TIMEOUT,                     "CURLOPT_TIMEOUT"},
  {CURLOPT_TIMEOUT_MS,                  "CURLOPT_TIMEOUT_MS"},
  {CURLOPT_TIMEVALUE,                   "CURLOPT_TIMEVALUE"},
  {CURLOPT_TLSAUTH_PASSWORD,            "CURLOPT_TLSAUTH_PASSWORD"},
  {CURLOPT_TLSAUTH_TYPE,                "CURLOPT_TLSAUTH_TYPE"},
  {CURLOPT_TLSAUTH_USERNAME,            "CURLOPT_TLSAUTH_USERNAME"},
  {CURLOPT_TRANSFERTEXT,                "CURLOPT_TRANSFERTEXT"},
  {CURLOPT_TRANSFER_ENCODING,           "CURLOPT_TRANSFER_ENCODING"},
  {CURLOPT_UNIX_SOCKET_PATH,            "CURLOPT_UNIX_SOCKET_PATH"},
  {CURLOPT_UNRESTRICTED_AUTH,           "CURLOPT_UNRESTRICTED_AUTH"},
  {CURLOPT_UPLOAD,                      "CURLOPT_UPLOAD"},
  {CURLOPT_URL,                         "CURLOPT_URL"},
  {CURLOPT_USERAGENT,                   "CURLOPT_USERAGENT"},
  {CURLOPT_USERNAME,                    "CURLOPT_USERNAME"},
  {CURLOPT_USERPWD,                     "CURLOPT_USERPWD"},
  {CURLOPT_USE_SSL,                     "CURLOPT_USE_SSL"},
  {CURLOPT_VERBOSE,                     "CURLOPT_VERBOSE"},
  {CURLOPT_WILDCARDMATCH,               "CURLOPT_WILDCARDMATCH"},
  {CURLOPT_WRITEDATA,                   "CURLOPT_WRITEDATA"},
  {CURLOPT_WRITEFUNCTION,               "CURLOPT_WRITEFUNCTION"},
  {CURLOPT_XFERINFODATA,                "CURLOPT_XFERINFODATA"},
  {CURLOPT_XFERINFOFUNCTION,            "CURLOPT_XFERINFOFUNCTION"},
  {CURLOPT_XOAUTH2_BEARER,              "CURLOPT_XOAUTH2_BEARER"}
}

--------------------------------------------------------------------------------

constant GETINFO_OPTIONS = {
  {CURLINFO_CONTENT_TYPE,               "CURLINFO_CONTENT_TYPE"},
  {CURLINFO_EFFECTIVE_URL,              "CURLINFO_EFFECTIVE_URL"},
  {CURLINFO_FTP_ENTRY_PATH,             "CURLINFO_FTP_ENTRY_PATH"},
  {CURLINFO_LOCAL_IP,                   "CURLINFO_LOCAL_IP"},
  {CURLINFO_PRIMARY_IP,                 "CURLINFO_PRIMARY_IP"},
  {CURLINFO_PRIVATE,                    "CURLINFO_PRIVATE"},
  {CURLINFO_REDIRECT_URL,               "CURLINFO_REDIRECT_URL"},
  {CURLINFO_RTSP_SESSION_ID,            "CURLINFO_RTSP_SESSION_ID"},
  {CURLINFO_ACTIVESOCKET,               "CURLINFO_ACTIVESOCKET"},
  {CURLINFO_APPCONNECT_TIME,            "CURLINFO_APPCONNECT_TIME"},
  {CURLINFO_CONNECT_TIME,               "CURLINFO_CONNECT_TIME"},
  {CURLINFO_CONTENT_LENGTH_DOWNLOAD,    "CURLINFO_CONTENT_LENGTH_DOWNLOAD"},
  {CURLINFO_CONTENT_LENGTH_UPLOAD,      "CURLINFO_CONTENT_LENGTH_UPLOAD"},
  {CURLINFO_NAMELOOKUP_TIME,            "CURLINFO_NAMELOOKUP_TIME"},
  {CURLINFO_PRETRANSFER_TIME,           "CURLINFO_PRETRANSFER_TIME"},
  {CURLINFO_REDIRECT_TIME,              "CURLINFO_REDIRECT_TIME"},
  {CURLINFO_SIZE_DOWNLOAD,              "CURLINFO_SIZE_DOWNLOAD"},
  {CURLINFO_SIZE_UPLOAD,                "CURLINFO_SIZE_UPLOAD"},
  {CURLINFO_SPEED_DOWNLOAD,             "CURLINFO_SPEED_DOWNLOAD"},
  {CURLINFO_SPEED_UPLOAD,               "CURLINFO_SPEED_UPLOAD"},
  {CURLINFO_STARTTRANSFER_TIME,         "CURLINFO_STARTTRANSFER_TIME"},
  {CURLINFO_TOTAL_TIME,                 "CURLINFO_TOTAL_TIME"},
  {CURLINFO_CONDITION_UNMET,            "CURLINFO_CONDITION_UNMET"},
  {CURLINFO_FILETIME,                   "CURLINFO_FILETIME"},
  {CURLINFO_HEADER_SIZE,                "CURLINFO_HEADER_SIZE"},
  {CURLINFO_HTTP_CONNECTCODE,           "CURLINFO_HTTP_CONNECTCODE"},
  {CURLINFO_HTTP_VERSION,               "CURLINFO_HTTP_VERSION"},
  {CURLINFO_HTTPAUTH_AVAIL,             "CURLINFO_HTTPAUTH_AVAIL"},
  {CURLINFO_LASTSOCKET,                 "CURLINFO_LASTSOCKET"},
  {CURLINFO_LOCAL_PORT,                 "CURLINFO_LOCAL_PORT"},
  {CURLINFO_NUM_CONNECTS,               "CURLINFO_NUM_CONNECTS"},
  {CURLINFO_OS_ERRNO,                   "CURLINFO_OS_ERRNO"},
  {CURLINFO_PRIMARY_PORT,               "CURLINFO_PRIMARY_PORT"},
  {CURLINFO_PROXYAUTH_AVAIL,            "CURLINFO_PROXYAUTH_AVAIL"},
  {CURLINFO_REDIRECT_COUNT,             "CURLINFO_REDIRECT_COUNT"},
  {CURLINFO_REQUEST_SIZE,               "CURLINFO_REQUEST_SIZE"},
  {CURLINFO_RESPONSE_CODE,              "CURLINFO_RESPONSE_CODE"},
  {CURLINFO_RTSP_CLIENT_CSEQ,           "CURLINFO_RTSP_CLIENT_CSEQ"},
  {CURLINFO_RTSP_CSEQ_RECV,             "CURLINFO_RTSP_CSEQ_RECV"},
  {CURLINFO_RTSP_SERVER_CSEQ,           "CURLINFO_RTSP_SERVER_CSEQ"},
  {CURLINFO_SSL_VERIFYRESULT,           "CURLINFO_SSL_VERIFYRESULT"},
  {CURLINFO_CERTINFO,                   "CURLINFO_CERTINFO"},
  {CURLINFO_COOKIELIST,                 "CURLINFO_COOKIELIST"},
  {CURLINFO_SSL_ENGINES,                "CURLINFO_SSL_ENGINES"},
  {CURLINFO_TLS_SESSION,                "CURLINFO_TLS_SESSION"},
  {CURLINFO_TLS_SSL_PTR,                "CURLINFO_TLS_SSL_PTR"}
}

--------------------------------------------------------------------------------

public function curl_write_callback(atom ptr, atom size, atom nmemb, atom stream)
  atom realsize = size * nmemb
  sequence data = peek({ ptr, realsize })
  ram_space[stream] = append( ram_space[stream], data )
  return realsize
end function

--------------------------------------------------------------------------------

public function curl_read_callback(atom ptr, atom size, atom nmemb, atom stream)
--  stream = stream -- stop warning
  poke(ptr, ram_space[stream])
  return size * nmemb
end function

--------------------------------------------------------------------------------
-- LIBCURL ROUTINES
--------------------------------------------------------------------------------

public function curl_strequal(sequence s1, sequence s2)
  -- log_printf("curl_strequal(%s, %s)\n", {s1, s2})
  atom addr_s1 = allocate_string(s1)
  atom addr_s2 = allocate_string(s2)
  integer ret = c_func(xcurl_strequal, {addr_s1, addr_s2})
  machine:free(addr_s1)
  machine:free(addr_s2)
  return ret
end function

--------------------------------------------------------------------------------

public function curl_strnequal(sequence s1, sequence s2, atom n)
  atom addr_s1 = allocate_string(s1)
  atom addr_s2 = allocate_string(s2)
  integer ret = c_func(xcurl_strnequal, {addr_s1, addr_s2, n})
  machine:free(addr_s1)
  machine:free(addr_s2)
  return ret
end function

--------------------------------------------------------------------------------

public function curl_formadd(atom httppost, atom last_post, atom param)
  return c_func(xcurl_formadd, {httppost, last_post, param})
end function

--------------------------------------------------------------------------------

public function curl_formget(atom form, atom arg, atom app)
  return c_func(xcurl_formget, {form, arg, app})
end function

--------------------------------------------------------------------------------

public procedure curl_formfree(atom form)
  c_proc(xcurl_formfree, {form})
end procedure

--------------------------------------------------------------------------------

public function curl_getenv(sequence variable)
  atom addr = allocate_string(variable)
  atom ret = c_func(xcurl_getenv, {addr})
  sequence s = peek_string(ret)
  machine:free(addr)
  return s
end function

--------------------------------------------------------------------------------

public function curl_version()
  atom ret = c_func(xcurl_version, {})
  return peek_string(ret)
end function

--------------------------------------------------------------------------------

public function curl_easy_escape(atom handle, sequence string)
  atom addr, ret
  sequence s

  addr = allocate_string(string)
  ret = c_func(xcurl_easy_escape, {handle, addr, length(string)})
  s = peek_string(ret)
  machine:free(addr)
  return s
end function

--------------------------------------------------------------------------------

public function curl_escape(sequence string)
  atom addr, ret
  sequence s

  addr = allocate_string(string)
  ret = c_func(xcurl_escape, {addr, length(string)})
  s = peek_string(ret)
  machine:free(addr)
  return s
end function

--------------------------------------------------------------------------------

public function curl_easy_unescape(atom handle, sequence string)
  atom addr, len, ret
  sequence s

  addr = allocate_string(string)
  len = allocate(4)
  ret = c_func(xcurl_easy_unescape, {handle, addr, length(string), len})
  s = peek_string(ret)
  machine:free(addr)
  machine:free(len)
  return s
end function

--------------------------------------------------------------------------------

public function curl_unescape(sequence string)
  atom addr, ret
  sequence s

  addr = allocate_string(string)
  ret = c_func(xcurl_unescape, {addr, length(string)})
  s = peek_string(ret)
  machine:free(addr)
  return s
end function

--------------------------------------------------------------------------------

public procedure curl_free(atom p)
  c_proc(xcurl_free, {p})
end procedure

--------------------------------------------------------------------------------

public function curl_global_init(atom flags)
  return c_func(xcurl_global_init, {flags})
end function

--------------------------------------------------------------------------------

public function curl_slist_append(atom slist, sequence string)
  atom addr, ret

  addr = allocate_string(string)
  ret = c_func(xcurl_slist_append, {slist, addr})
  machine:free(addr)
  return ret
end function

--------------------------------------------------------------------------------

public procedure curl_slist_free_all(atom slist)
  c_proc(xcurl_slist_free_all, {slist})
end procedure

--------------------------------------------------------------------------------

public function peek_curl_slist( atom slist, integer max )
  sequence strings, str, s
  atom next

  -- log_puts("peek_curl_slist\n")
  strings = {}
  -- log_printf("slist = %d\n", slist)
  if slist = NULL then return strings end if
  next = slist
  while next != NULL do
    s = peek_pointer({next,2})
    -- analyze_object(s, sprintf("item@%d",next), f_debug)
    if s[1] = NULL then return strings end if
    str = peek_string( s[1] )
    --- analyze_object(str, "str", f_debug)
    strings = append( strings, str )
    if (max != -1) and (length(strings) = max) then exit end if
    next = s[2]
    -- log_printf("next = %d\n", next)
--    if next = NULL then return strings end if
  end while
  return strings
end function

--------------------------------------------------------------------------------

public procedure curl_global_cleanup()
  c_proc(xcurl_global_cleanup, {})
end procedure

--------------------------------------------------------------------------------

public function curl_getdate(sequence string)
  atom addr, ret

  addr = allocate_string(string)
  ret = c_func(xcurl_getdate, {addr, NULL})
  machine:free(addr)
  return ret
end function

--------------------------------------------------------------------------------

public function curl_version_info()
  return c_func(xcurl_version_info, {CURLVERSION_NOW})
end function

--------------------------------------------------------------------------------

public function curl_easy_strerror(integer code)
  atom ret = c_func(xcurl_easy_strerror, {code})
  return peek_string(ret)
end function

--------------------------------------------------------------------------------

public function curl_easy_pause(atom handle, integer bitmask)
  return c_func(xcurl_easy_pause, {handle, bitmask})
end function

--------------------------------------------------------------------------------

public function curl_easy_init()
  return c_func(xcurl_easy_init, {})
end function

--------------------------------------------------------------------------------

public procedure curl_easy_setopt(atom curl, integer option, object param)
  integer code
  object o

  -- log_printf("+curl_easy_setopt(%d, %s)\n", {option, object_dump(param)})

  if find(option, {
    CURLOPT_ACCEPT_ENCODING, CURLOPT_CAINFO, CURLOPT_CAPATH, CURLOPT_COOKIE,
    CURLOPT_COOKIEFILE, CURLOPT_COOKIEJAR, CURLOPT_COOKIELIST,
    CURLOPT_COPYPOSTFIELDS, CURLOPT_CRLFILE, CURLOPT_CUSTOMREQUEST,
    CURLOPT_DEFAULT_PROTOCOL, CURLOPT_DNS_INTERFACE, CURLOPT_DNS_LOCAL_IP4,
    CURLOPT_DNS_LOCAL_IP6, CURLOPT_DNS_SERVERS, CURLOPT_EGDSOCKET,
    CURLOPT_FTP_ACCOUNT, CURLOPT_FTP_ALTERNATIVE_TO_USER,
    CURLOPT_FTPPORT, CURLOPT_INTERFACE, CURLOPT_ISSUERCERT, CURLOPT_KEYPASSWD,
    CURLOPT_KRBLEVEL, CURLOPT_LOGIN_OPTIONS, CURLOPT_MAIL_AUTH,
    CURLOPT_MAIL_FROM, CURLOPT_NETRC_FILE, CURLOPT_NOPROXY, CURLOPT_PASSWORD,
    CURLOPT_PINNEDPUBLICKEY, CURLOPT_POSTFIELDS, CURLOPT_PREQUOTE,
    CURLOPT_PROXY, CURLOPT_PROXY_SERVICE_NAME, CURLOPT_PROXYPASSWORD,
    CURLOPT_PROXYUSERNAME, CURLOPT_PROXYUSERPWD, CURLOPT_RANDOM_FILE,
    CURLOPT_RANGE, CURLOPT_REFERER, CURLOPT_RTSP_SESSION_ID,
    CURLOPT_RTSP_STREAM_URI, CURLOPT_RTSP_TRANSPORT, CURLOPT_SERVICE_NAME,
    CURLOPT_SOCKS5_GSSAPI_SERVICE, CURLOPT_SSH_HOST_PUBLIC_KEY_MD5,
    CURLOPT_SSH_KNOWNHOSTS, CURLOPT_SSH_PRIVATE_KEYFILE,
    CURLOPT_SSH_PUBLIC_KEYFILE, CURLOPT_SSL_CIPHER_LIST, CURLOPT_SSLCERT,
    CURLOPT_SSLCERTTYPE, CURLOPT_SSLENGINE, CURLOPT_SSLKEY,
    CURLOPT_SSLKEYTYPE, CURLOPT_TLSAUTH_PASSWORD, CURLOPT_TLSAUTH_TYPE,
    CURLOPT_TLSAUTH_USERNAME, CURLOPT_UNIX_SOCKET_PATH, CURLOPT_URL,
    CURLOPT_USERAGENT, CURLOPT_USERNAME, CURLOPT_USERPWD,
    CURLOPT_XOAUTH2_BEARER}
  ) then  -- char *
    if atom(param) then  -- NULL
      code = c_func(xcurl_easy_setopt, {curl, option, param})
    else
      code = c_func(xcurl_easy_setopt, {curl, option,
                       allocate_string(param)})
    end if

  elsif option = CURLOPT_ERRORBUFFER then  -- char *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_CHUNK_BGN_FUNCTION, CURLOPT_CHUNK_END_FUNCTION,
    CURLOPT_CLOSESOCKETFUNCTION, CURLOPT_CONV_FROM_NETWORK_FUNCTION,
    CURLOPT_CONV_FROM_UTF8_FUNCTION, CURLOPT_CONV_TO_NETWORK_FUNCTION,
    CURLOPT_DEBUGFUNCTION, CURLOPT_FNMATCH_FUNCTION, CURLOPT_HEADERFUNCTION,
    CURLOPT_INTERLEAVEFUNCTION, CURLOPT_IOCTLFUNCTION,
    CURLOPT_OPENSOCKETFUNCTION, CURLOPT_PROGRESSFUNCTION,
    CURLOPT_READFUNCTION, CURLOPT_SEEKFUNCTION, CURLOPT_SOCKOPTFUNCTION,
    CURLOPT_SSH_KEYFUNCTION, CURLOPT_SSL_CTX_FUNCTION, CURLOPT_WRITEFUNCTION,
    CURLOPT_XFERINFOFUNCTION}
  ) then  -- callback
--    code = c_func(xcurl_easy_setopt, {curl, option, cdecl_callback(param)},
--                     "+curl_easy_setopt",
--                  CURL_LIBRARY_DEFINITION, CURL_ROUTINE_DEFINITION)
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_STREAM_DEPENDS, CURLOPT_STREAM_DEPENDS_E}
  ) then  -- CURL *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_INFILESIZE_LARGE, CURLOPT_MAX_RECV_SPEED_LARGE,
    CURLOPT_MAX_SEND_SPEED_LARGE, CURLOPT_MAXFILESIZE_LARGE,
    CURLOPT_POSTFIELDSIZE_LARGE, CURLOPT_RESUME_FROM_LARGE}
  ) then  -- curl_off_t
    code = c_func(xcurl_easy_setopt, {curl, option, param})

--  elsif option = CURLOPT_SHARE then   -- CURLSH *
--    code = c_func(xcurl_easy_setopt, {curl, option, param},
--                     "+curl_easy_setopt")

  elsif option = CURLOPT_STDERR then  -- FILE *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_ACCEPTTIMEOUT_MS, CURLOPT_ADDRESS_SCOPE, CURLOPT_APPEND,
    CURLOPT_AUTOREFERER, CURLOPT_BUFFERSIZE, CURLOPT_CERTINFO,
    CURLOPT_CONNECT_ONLY, CURLOPT_CONNECTTIMEOUT, CURLOPT_CONNECTTIMEOUT_MS,
    CURLOPT_COOKIESESSION, CURLOPT_CRLF, CURLOPT_DIRLISTONLY,
    CURLOPT_DNS_CACHE_TIMEOUT, CURLOPT_DNS_USE_GLOBAL_CACHE,
    CURLOPT_EXPECT_100_TIMEOUT_MS, CURLOPT_FAILONERROR, CURLOPT_FILETIME,
    CURLOPT_FOLLOWLOCATION, CURLOPT_FORBID_REUSE, CURLOPT_FRESH_CONNECT,
    CURLOPT_FTP_CREATE_MISSING_DIRS, CURLOPT_FTP_FILEMETHOD,
    CURLOPT_FTP_RESPONSE_TIMEOUT, CURLOPT_FTP_SKIP_PASV_IP,
    CURLOPT_FTP_SSL_CCC, CURLOPT_FTP_USE_EPRT, CURLOPT_FTP_USE_EPSV,
    CURLOPT_FTP_USE_PRET, CURLOPT_FTPSSLAUTH, CURLOPT_GSSAPI_DELEGATION,
    CURLOPT_HEADER, CURLOPT_HEADEROPT, CURLOPT_HTTP_CONTENT_DECODING,
    CURLOPT_HTTP_TRANSFER_DECODING, CURLOPT_HTTP_VERSION, CURLOPT_HTTPAUTH,
    CURLOPT_HTTPGET, CURLOPT_HTTPPROXYTUNNEL, CURLOPT_IGNORE_CONTENT_LENGTH,
    CURLOPT_INFILESIZE, CURLOPT_IPRESOLVE, CURLOPT_LOCALPORT,
    CURLOPT_LOCALPORTRANGE, CURLOPT_LOW_SPEED_LIMIT, CURLOPT_LOW_SPEED_TIME,
    CURLOPT_MAXCONNECTS, CURLOPT_MAXFILESIZE, CURLOPT_MAXREDIRS,
    CURLOPT_NETRC, CURLOPT_NEW_DIRECTORY_PERMS, CURLOPT_NEW_FILE_PERMS,
    CURLOPT_NOBODY, CURLOPT_NOPROGRESS, CURLOPT_NOSIGNAL, CURLOPT_PATH_AS_IS,
    CURLOPT_PIPEWAIT, CURLOPT_PORT, CURLOPT_POST, CURLOPT_POSTFIELDSIZE,
    CURLOPT_POSTREDIR, CURLOPT_PROTOCOLS, CURLOPT_PROXY_TRANSFER_MODE,
    CURLOPT_PROXYAUTH, CURLOPT_PROXYPORT, CURLOPT_PROXYTYPE, CURLOPT_PUT,
    CURLOPT_REDIR_PROTOCOLS, CURLOPT_RESUME_FROM, CURLOPT_RTSP_CLIENT_CSEQ,
    CURLOPT_RTSP_REQUEST, CURLOPT_RTSP_SERVER_CSEQ, CURLOPT_SASL_IR,
    CURLOPT_SOCKS5_GSSAPI_NEC, CURLOPT_SSH_AUTH_TYPES,
    CURLOPT_SSL_ENABLE_ALPN, CURLOPT_SSL_ENABLE_NPN, CURLOPT_SSL_FALSESTART,
    CURLOPT_SSL_OPTIONS, CURLOPT_SSL_SESSIONID_CACHE, CURLOPT_SSL_VERIFYHOST,
    CURLOPT_SSL_VERIFYPEER, CURLOPT_SSL_VERIFYSTATUS,
    CURLOPT_SSLENGINE_DEFAULT, CURLOPT_SSLVERSION, CURLOPT_STREAM_WEIGHT,
    CURLOPT_TCP_FASTOPEN, CURLOPT_TCP_KEEPALIVE, CURLOPT_TCP_KEEPIDLE,
    CURLOPT_TCP_KEEPINTVL, CURLOPT_TCP_NODELAY, CURLOPT_TFTP_BLKSIZE,
    CURLOPT_TFTP_NO_OPTIONS, CURLOPT_TIMECONDITION, CURLOPT_TIMEOUT,
    CURLOPT_TIMEOUT_MS, CURLOPT_TIMEVALUE, CURLOPT_TRANSFER_ENCODING,
    CURLOPT_TRANSFERTEXT, CURLOPT_UNRESTRICTED_AUTH, CURLOPT_UPLOAD,
    CURLOPT_USE_SSL, CURLOPT_VERBOSE, CURLOPT_WILDCARDMATCH}
  ) then  -- long
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif option = CURLOPT_HTTPPOST then  -- struct curl_httppost *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_CONNECT_TO, CURLOPT_HTTP200ALIASES, CURLOPT_HTTPHEADER,
    CURLOPT_MAIL_RCPT, CURLOPT_POSTQUOTE, CURLOPT_PROXYHEADER,
    CURLOPT_QUOTE, CURLOPT_RESOLVE, CURLOPT_TELNETOPTIONS}
  ) then  -- struct curl_slist *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_CHUNK_DATA, CURLOPT_CLOSESOCKETDATA, CURLOPT_DEBUGDATA,
    CURLOPT_FNMATCH_DATA, CURLOPT_HEADERDATA, CURLOPT_INTERLEAVEDATA,
    CURLOPT_IOCTLDATA, CURLOPT_OPENSOCKETDATA, CURLOPT_PRIVATE,
    CURLOPT_PROGRESSDATA, CURLOPT_READDATA, CURLOPT_SEEKDATA,
    CURLOPT_SOCKOPTDATA, CURLOPT_SSH_KEYDATA, CURLOPT_SSL_CTX_DATA,
    CURLOPT_WRITEDATA, CURLOPT_XFERINFODATA}
  ) then  -- void *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  end if
  if (code != CURLE_OK) then
    o = vlookup(option, SETOPT_OPTIONS, 1, 2)
    if atom(o) then
      error_message(sprintf("Unknown option '%d'", {option}), 1)
    else
      error_message(sprintf("Failed to set option '%s'", {o}), 1)
    end if
  end if
end procedure

--------------------------------------------------------------------------------

public function curl_easy_perform(atom curl)
  return c_func(xcurl_easy_perform, {curl})
end function

--------------------------------------------------------------------------------

public procedure curl_easy_cleanup(atom curl)
  c_proc(xcurl_easy_cleanup, {curl})
end procedure

--------------------------------------------------------------------------------

public function curl_easy_getinfo(atom curl, integer option)
  atom ret, param
  object o, res
  
  if find(option, {
    CURLINFO_APPCONNECT_TIME, CURLINFO_CONNECT_TIME,
	CURLINFO_CONTENT_LENGTH_DOWNLOAD, CURLINFO_CONTENT_LENGTH_UPLOAD,
	CURLINFO_NAMELOOKUP_TIME, CURLINFO_PRETRANSFER_TIME, CURLINFO_REDIRECT_TIME,
	CURLINFO_SIZE_DOWNLOAD, CURLINFO_SIZE_UPLOAD, CURLINFO_SPEED_DOWNLOAD,
	CURLINFO_SPEED_UPLOAD, CURLINFO_STARTTRANSFER_TIME, CURLINFO_TOTAL_TIME}
  ) then  -- DOUBLE
    param = allocate(8)

  elsif find(option, {
    CURLINFO_CONDITION_UNMET, CURLINFO_FILETIME, CURLINFO_HEADER_SIZE,
	CURLINFO_HTTP_CONNECTCODE, CURLINFO_HTTP_VERSION, CURLINFO_HTTPAUTH_AVAIL,
	CURLINFO_LASTSOCKET, CURLINFO_LOCAL_PORT, CURLINFO_NUM_CONNECTS,
	CURLINFO_OS_ERRNO, CURLINFO_PRIMARY_PORT, CURLINFO_PROXYAUTH_AVAIL,
	CURLINFO_REDIRECT_COUNT, CURLINFO_REQUEST_SIZE, CURLINFO_RESPONSE_CODE,
	CURLINFO_RTSP_CLIENT_CSEQ, CURLINFO_RTSP_CSEQ_RECV,
	CURLINFO_RTSP_SERVER_CSEQ, CURLINFO_SSL_VERIFYRESULT}
  ) then  -- LONG
    param = allocate(4)

  elsif find(option, {
    CURLINFO_CERTINFO, CURLINFO_COOKIELIST, CURLINFO_SSL_ENGINES,
	CURLINFO_TLS_SESSION, CURLINFO_TLS_SSL_PTR}
  ) then  -- SLIST
    param = curl_slist_append(NULL, "")
--    param = NULL

  elsif option = CURLINFO_ACTIVESOCKET then  -- SOCKET
    param = allocate(4)

  elsif find(option, {
    CURLINFO_CONTENT_TYPE, CURLINFO_EFFECTIVE_URL, CURLINFO_FTP_ENTRY_PATH,
	CURLINFO_LOCAL_IP, CURLINFO_PRIMARY_IP, CURLINFO_PRIVATE,
	CURLINFO_REDIRECT_URL, CURLINFO_RTSP_SESSION_ID}
  ) then  -- STRING
    param = allocate_string("")

  end if
  
  res = -1
  ret = c_func(xcurl_easy_getinfo, {curl, option, param})
--  analyze_object(ret, "ret", f_debug)
  
  if ret = CURLE_UNKNOWN_OPTION then
    o = vlookup(option, GETINFO_OPTIONS, 1, 2)
    if atom(o) then
      error_message(sprintf("Unknown option '%d'", {option}), 1)
    else
      error_message(sprintf("Unknown option '%s'", {o[2]}), 1)
    end if
  end if

  if find(option, {
    CURLINFO_CONTENT_TYPE, CURLINFO_EFFECTIVE_URL,
    CURLINFO_FTP_ENTRY_PATH, CURLINFO_LOCAL_IP,
    CURLINFO_PRIMARY_IP, CURLINFO_PRIVATE,
    CURLINFO_REDIRECT_URL, CURLINFO_RTSP_SESSION_ID}
  ) then  -- char **
    if ret = CURLE_OK then
      res = peek_string(peek_pointer(param))
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    machine:free(param)

  elsif option = CURLINFO_ACTIVESOCKET then  -- curl_socket_t *
    if ret = CURLE_OK then
      res = peek4u(param)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    machine:free(param)

  elsif find(option, {
    CURLINFO_APPCONNECT_TIME, CURLINFO_CONNECT_TIME,
    CURLINFO_CONTENT_LENGTH_DOWNLOAD, CURLINFO_CONTENT_LENGTH_UPLOAD,
    CURLINFO_NAMELOOKUP_TIME, CURLINFO_PRETRANSFER_TIME,
    CURLINFO_REDIRECT_TIME, CURLINFO_SIZE_DOWNLOAD,
    CURLINFO_SIZE_UPLOAD, CURLINFO_SPEED_DOWNLOAD, CURLINFO_SPEED_UPLOAD,
    CURLINFO_STARTTRANSFER_TIME, CURLINFO_TOTAL_TIME}
  ) then  -- double *
    if ret = CURLE_OK then
      res = float64_to_atom(peek({param,8}))  -- peek8s(param)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    machine:free(param)

  elsif find(option, {
    CURLINFO_CONDITION_UNMET, CURLINFO_FILETIME, CURLINFO_HEADER_SIZE,
    CURLINFO_HTTP_CONNECTCODE, CURLINFO_HTTP_VERSION,
    CURLINFO_HTTPAUTH_AVAIL, CURLINFO_LASTSOCKET, CURLINFO_LOCAL_PORT,
    CURLINFO_NUM_CONNECTS, CURLINFO_OS_ERRNO, CURLINFO_PRIMARY_PORT,
    CURLINFO_PROXYAUTH_AVAIL, CURLINFO_REDIRECT_COUNT,
    CURLINFO_REQUEST_SIZE, CURLINFO_RESPONSE_CODE,
    CURLINFO_RTSP_CLIENT_CSEQ, CURLINFO_RTSP_CSEQ_RECV,
    CURLINFO_RTSP_SERVER_CSEQ, CURLINFO_SSL_VERIFYRESULT}
  ) then  -- long *
    if ret = CURLE_OK then
      res = peek4s(param)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    machine:free(param)

  elsif option = CURLINFO_CERTINFO then  -- struct curl_certinfo *
    if ret = CURLE_OK then
      -- analyze_object(param, "param", f_debug)
      o = peek_pointer({peek_pointer(param),2})
      -- analyze_object(o, "o", f_debug)
      if o[2] then
        res = peek_curl_slist(peek_pointer(o[2]), -1)
        curl_slist_free_all(param)
      end if
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if

  elsif find(option, {
    CURLINFO_COOKIELIST, CURLINFO_SSL_ENGINES}
  ) then  -- struct curl_slist **
    if ret = CURLE_OK then
      res = peek_curl_slist(peek_pointer(param), -1)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    curl_slist_free_all(param)


  elsif find(option, {
    CURLINFO_TLS_SESSION, CURLINFO_TLS_SSL_PTR}
  ) then  -- struct curl_tlssessioninfo **
    if ret = CURLE_OK then
      res = peek_curl_slist(peek_pointer(param), -1)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    curl_slist_free_all(param)

  end if
  return res
end function

--------------------------------------------------------------------------------

public function curl_easy_duphandle(atom curl)
  return c_func(xcurl_easy_duphandle, {curl})
end function

--------------------------------------------------------------------------------

public procedure curl_easy_reset(atom curl)
  c_proc(xcurl_easy_reset, {curl})
end procedure

--------------------------------------------------------------------------------

public function curl_easy_recv(atom curl, atom buffer, integer buflen)
  atom addr, ret
  integer len

  addr = allocate(4)
  ret = c_func(xcurl_easy_recv, {curl, buffer, buflen, addr})
  len = peek4s(addr)
  machine:free(addr)
  return {ret, buffer, len}
end function

--------------------------------------------------------------------------------

public function curl_easy_send(atom curl, atom buffer, integer buflen)
  atom addr, ret
  integer len

  addr = allocate(4)
  ret = c_func(xcurl_easy_send, {curl, buffer, buflen, addr})
  len = peek4s(addr)
  machine:free(addr)
  return {ret, len}
end function

--------------------------------------------------------------------------------

public function curl_extract_cookies( sequence headers, integer raw=0 )
  sequence result, s, cookie
  integer p
  
  result = {}
  if length(headers) = 0 then return {} end if
  for i = 1 to length(headers[$]) do
    if begins("Set-Cookie:", headers[$][i]) then
      if raw then
        result = append(result, headers[$][i])
      else
        s = headers[$][i][13..$]
        p = find(';', s)
        if p then s = s[1..p-1] end if
        cookie = split(s, '=',, 2) -- Only want 2 sub-sequences
        result = append(result, cookie)
      end if
    end if
  end for
  return result
end function

--------------------------------------------------------------------------------

public function curl_easy_perform_ex( atom handle )
  atom write_cb, pcontent, pheaders, result
  sequence content, headers, url, section, s
  object status

ifdef WINDOWS then
  write_cb = call_back({ '+', routine_id("curl_write_callback") })
elsifdef LINUX then
  write_cb = call_back(routine_id("curl_write_callback"))
end ifdef
  curl_easy_setopt(handle, CURLOPT_HEADERFUNCTION, write_cb)
  curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION,  write_cb)

  pheaders = eumem:malloc( "" )
  pcontent = eumem:malloc( "" )
  curl_easy_setopt(handle, CURLOPT_HEADERDATA, pheaders)
  curl_easy_setopt(handle, CURLOPT_WRITEDATA,  pcontent )

  result = curl_easy_perform( handle )
  if (result != CURLE_OK) then
    error_message(sprintf("Curl perform failed: %s\n",
                          {curl_easy_strerror(result)}),
                  1)
  end if

  status = curl_easy_getinfo(handle, CURLINFO_RESPONSE_CODE)
  url = curl_easy_getinfo(handle, CURLINFO_EFFECTIVE_URL)
  content = join(ram_space[pcontent], "")
--  headers = join(ram_space[pheaders], "")
  s = ram_space[pheaders]
  headers = {}
  section = {}
  for i = 1 to length(s) do
    if equal(s[i], "\r\n") then
      headers = append(headers, section)
      section = {}
    else
      section = append(section, trim(s[i]))
    end if
  end for
  eumem:free( pheaders )
  eumem:free( pcontent )

  return {status, url, headers, content}
end function

--------------------------------------------------------------------------------

function curl_send(atom curl)
  object res = curl_easy_perform_ex(curl)
  log_printf("Status: %d\n", {res[HTTP_STATUS]}, DEBUG)
  log_printf("Effective URL: %s\n", {res[HTTP_URL]}, DEBUG)
  analyze_object(res[HTTP_HEADERS], "Headers", DEBUG)
  analyze_object(res[HTTP_BODY], "Content", DEBUG)
  return res
end function

--------------------------------------------------------------------------------

public function curl_get(atom curl, sequence url, sequence headers={})
  log_puts("\nGET " & object_dump(url) & " " & object_dump(headers) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0)
  curl_easy_setopt(curl, CURLOPT_POST, 0)

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function

--------------------------------------------------------------------------------

public function curl_post(atom curl, sequence url, sequence headers,
                          object body)
  log_printf("\nPOST %s\n  - headers: %s\n  - data: %s\n",
             {url, object_dump(headers), object_dump(body)})
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POST, 1)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body)

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function

--------------------------------------------------------------------------------

public function curl_put(atom curl, sequence url, sequence headers,
                         object body)
  log_puts("\nPUT " & object_dump(url) & " " & object_dump(headers) & " "  &
           object_dump(body) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POST, 0)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body)
  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT")

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function

--------------------------------------------------------------------------------

public function curl_delete(atom curl, sequence url, sequence headers={})
  log_puts("\nDELETE " & object_dump(url) & " " & object_dump(headers) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0)
  curl_easy_setopt(curl, CURLOPT_POST, 0)
  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE")

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function

--------------------------------------------------------------------------------

public function curl_patch(atom curl, sequence url, sequence headers,
                           object body)
  log_puts("\nPATCH " & object_dump(url) & " " & object_dump(headers) & " " &
           object_dump(body) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POST, 1)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body)
  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PATCH")

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function

--------------------------------------------------------------------------------

public function curl_head(atom curl, sequence url, sequence headers={})
  log_puts("\nHEAD " & object_dump(url) & " " & object_dump(headers) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0)
  curl_easy_setopt(curl, CURLOPT_POST, 0)
  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "HEAD")
  curl_easy_setopt(curl, CURLOPT_NOBODY, 1 )

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function

--------------------------------------------------------------------------------

public function curl_options(atom curl, sequence url, sequence headers={})
  log_puts("\nOPTIONS " & object_dump(url) & " " & object_dump(headers) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0)
  curl_easy_setopt(curl, CURLOPT_POST, 0)
  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "OPTIONS")
  curl_easy_setopt(curl, CURLOPT_NOBODY, 1 )

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function

--------------------------------------------------------------------------------

public function curl_trace(atom curl, sequence url, sequence headers={})
  log_puts("\nTRACE " & object_dump(url) & " " & object_dump(headers) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  atom pheaders = NULL
  for i = 1 to length(headers) do
    pheaders = curl_slist_append(pheaders, headers[i])
  end for
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, pheaders)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0)
  curl_easy_setopt(curl, CURLOPT_POST, 0)
  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "TRACE")
  curl_easy_setopt(curl, CURLOPT_NOBODY, 1 )

  sequence res = curl_send(curl)
  curl_slist_free_all(pheaders)
  return res
end function
