// Flex.h: interface for the CFlex class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_FLEX_H__8663C206_1429_479D_8EE2_4FD4969EEE9F__INCLUDED_)
#define AFX_FLEX_H__8663C206_1429_479D_8EE2_4FD4969EEE9F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "int386w.hpp"

class CFlex  : public Int386w
{
public:
	CFlex( LPSTR Command="", UINT bufferSize = 0, UINT encryption = 0, UINT tickle = 0 );
	virtual ~CFlex();

	char *runGoal( char *command );
};

#endif // !defined(AFX_FLEX_H__8663C206_1429_479D_8EE2_4FD4969EEE9F__INCLUDED_)
