/**********************************************************************
 * Server Header  for WIN-PROLOG - by Alan Westwood - 10 Sep 01       *
 * Copyright (c) 2001 - Logic Programming Associates Ltd              *
 **********************************************************************/

int	WINAPI LoadProlog(LPSTR,UINT,UINT) ;
BOOL	WINAPI HaltProlog(UINT) ;
LPSTR	WINAPI InitGoal(UINT,LPSTR) ;
LPSTR	WINAPI CallGoal(UINT) ;
LPSTR	WINAPI TellGoal(UINT,LPSTR) ;
BOOL	WINAPI ExitGoal(UINT) ;
