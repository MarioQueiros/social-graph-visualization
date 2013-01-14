/*
   Windows Socket (Winsock) Error Numbers and Names - Brian D Steel - 14 Mar 05
   ============================================================================

   This file contains a list of all the common Windows Sockets (Winsock) error
   numbers and their names, and can be used to look up and explain the meaning
   of runtime errors encountered during the execution of sockets applications.
*/

socket_error( 10000, wsabaseerr         ).
socket_error( 10004, wsaeintr           ).
socket_error( 10009, wsaebadf           ).
socket_error( 10013, wsaeacces          ).
socket_error( 10014, wsaefault          ).
socket_error( 10022, wsaeinval          ).
socket_error( 10024, wsaemfile          ).
socket_error( 10035, wsaewouldblock     ).
socket_error( 10036, wsaeinprogress     ).
socket_error( 10037, wsaealready        ).
socket_error( 10038, wsaenotsock        ).
socket_error( 10039, wsaedestaddrreq    ).
socket_error( 10040, wsaemsgsize        ).
socket_error( 10041, wsaeprototype      ).
socket_error( 10042, wsaenoprotoopt     ).
socket_error( 10043, wsaeprotonosupport ).
socket_error( 10044, wsaesocktnosupport ).
socket_error( 10045, wsaeopnotsupp      ).
socket_error( 10046, wsaepfnosupport    ).
socket_error( 10047, wsaeafnosupport    ).
socket_error( 10048, wsaeaddrinuse      ).
socket_error( 10049, wsaeaddrnotavail   ).
socket_error( 10050, wsaenetdown        ).
socket_error( 10051, wsaenetunreach     ).
socket_error( 10052, wsaenetreset       ).
socket_error( 10053, wsaeconnaborted    ).
socket_error( 10054, wsaeconnreset      ).
socket_error( 10055, wsaenobufs         ).
socket_error( 10056, wsaeisconn         ).
socket_error( 10057, wsaenotconn        ).
socket_error( 10058, wsaeshutdown       ).
socket_error( 10059, wsaetoomanyrefs    ).
socket_error( 10060, wsaetimedout       ).
socket_error( 10061, wsaeconnrefused    ).
socket_error( 10062, wsaeloop           ).
socket_error( 10063, wsaenametoolong    ).
socket_error( 10064, wsaehostdown       ).
socket_error( 10065, wsaehostunreach    ).
socket_error( 10066, wsaenotempty       ).
socket_error( 10067, wsaeproclim        ).
socket_error( 10068, wsaeusers          ).
socket_error( 10069, wsaedquot          ).
socket_error( 10070, wsaestale          ).
socket_error( 10071, wsaeremote         ).
socket_error( 10101, wsaediscon         ).
socket_error( 10091, wsasysnotready     ).
socket_error( 10092, wsavernotsupported ).
socket_error( 10093, wsanotinitialised  ).
socket_error( 11001, wsahost_not_found  ).
socket_error( 11002, wsatry_again       ).
socket_error( 11003, wsano_recovery     ).
socket_error( 11004, wsano_data         ).
