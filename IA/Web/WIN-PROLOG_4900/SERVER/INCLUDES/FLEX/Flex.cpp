// Flex.cpp: implementation of the CFlex class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "flexeg.h"
#include "Flex.h"
#include "MultBox.h"
#include "LstBox.h"
#include "EdtBox.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

// Load flex
// Int386w constructor called first to load prolog
// Then the flex runtime code is loaded through Int386w
const CString errorMessages[] = {
		"isERR_ENCODE",
		"isERR_TICKLE",
		"isERR_CMUTEX",
		"isERR_WMUTEX",
		"isERR_LOCATE",
		"isERR_CREATE",
		"isERR_MAPFIL",
		"isERR_MODULE",
		"isERR_PROLOG",
		"isERR_ACTIVE",
		"isERR_WINDOW" 
};


CFlex::CFlex( LPSTR command, UINT bufferSize, UINT encryption, UINT tickle ) 
   : Int386w( command, bufferSize, encryption, tickle ) {

	if( loadError ) {
		CString errorMessage;

		errorMessage = "Error: " + errorMessages[ abs(loadError) - 1 ] + ", Loading Prolog";

        AfxMessageBox( errorMessage );
		exit( 0 );
	}

	char *resultString = callOneGoal( "ensure_loaded( prolog(flexserv) ). " );

	if( resultString[0] == 'E' ) {
        AfxMessageBox( resultString );
		exit( 0 );
	}
}

CFlex::~CFlex(){

}

char * CFlex::runGoal( char *command ) {
	char *resultString;

	resultString = initGoal( command );

	if( resultString[0] == 'E' ) {
		return( resultString );
		exit(0);
	}

	resultString = callGoal();

	while( resultString[0] == 'I' ) {

		char *textString = &resultString[10];

		switch( resultString[8] ) {
		case 'f' : // Flash a message
			AfxMessageBox( textString );
			break;
		case 'm' : // Multiple selection
			{
				CMltBox dlg;
				dlg.setDialog( textString );
				if ( dlg.DoModal() == IDOK){
					resultString = dlg.m_textString;
				} else {
					resultString = "??. ";
				}

			}
			break;
		case 's' : // Single selection
			{
				CLstBox dlg;
				dlg.setDialog( textString );
				if (dlg.DoModal() == IDOK) {
					resultString = dlg.m_textString;
					strcat( resultString, ". " );
				} else {
					resultString = "??. ";
				}
			}
			break;
		case 'e' : // Edit text
			{
				CEdtBox dlg;
				dlg.setDialog( textString );
				if ( dlg.DoModal() == IDOK) {
					resultString = dlg.m_textString;
				} else {
					resultString = "??. ";
				}
			}
			break;
		case 'x' : // A message box
			char *token;
			char *message;
			int selection, buttons;

			token = strtok( textString, "\001" );
            message  = strtok( NULL, "\001" );
			if( !strcmp( token, "ok" ) )
				buttons = MB_OK;
			else
			    if( !strcmp(token, "okcancel" ) )
				   buttons = MB_OKCANCEL;
			else
				if( !strcmp(token, "yesno") )
					buttons = MB_YESNO;
			else
				if( !strcmp(token, "yesnocancel") )
					buttons = MB_YESNOCANCEL;

            selection = AfxMessageBox(message,buttons);

			switch( selection ) {
			case IDOK:
				resultString = "ok. ";
				break;
			case IDCANCEL:
				resultString = "cancel. ";
				break;
			case IDNO:
				resultString = "no. ";
				break;
			case IDYES:
				resultString = "yes. ";
				break;
			default:
				resultString = "ok. ";
			}

			break;

		default : ;
		}
		resultString = tellGoal( resultString );
	}

	lstrcpy( m_text, resultString );
	exitGoal();

	return( m_text );
}
