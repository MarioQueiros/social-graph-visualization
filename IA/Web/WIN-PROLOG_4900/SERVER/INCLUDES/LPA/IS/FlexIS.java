package lpa.is;

import java.awt.*;

public class FlexIS extends Int386w
{
   Frame parentFrame;

// Constructor
   public FlexIS( Frame f )
   {
      parentFrame = f ;
   }


// Load a flex session
   public int loadFlex( String CommandLine )
   {
      int Id = loadProlog( CommandLine, 0, 0 );
      if(  Id < 0 )
     {
	    String MsgString = "";

       if( Id == isERR_ENCODE )
          MsgString = "isERR_ENCODE";
       else if( Id == isERR_CMUTEX )
          MsgString = "isERR_CMUTEX";
       else if( Id == isERR_WMUTEX)
          MsgString = "isERR_WMUTEX";
       else if( Id == isERR_LOCATE )
          MsgString = "isERR_LOCATE";
       else if( Id == isERR_CREATE )
          MsgString = "isERR_CREATE";
       else if( Id == isERR_MAPFIL )
          MsgString = "isERR_MAPFIL";
       else if( Id == isERR_PROLOG )
          MsgString = "isERR_PROLOG";
       else if( Id == isERR_WINDOW )
          MsgString = "isERR_WINDOW";

       MsgBox M = new MsgBox( parentFrame );
       String thisMessage = "\0ok\0" + "There was an error loading flex: " + MsgString + String.valueOf(Id);
       M.MessageBox( thisMessage );
     }

     // Load the flex system
     initGoal( "ensure_loaded( prolog(flexserv) ). " );
     String ResultString = callGoal();
     exitGoal();

     if( 'E' == ResultString.charAt(0) )
     {
		 MsgBox M = new MsgBox( parentFrame );
		 String thisMessage = "\0ok\0" + ResultString;
		 M.MessageBox( thisMessage );
	 }

     return( Id );
   }

// Halt a flex session
   public void haltFlex()
   {
      haltProlog();
   }

   public String runGoal( String Command )
   {
      // Initialize the goal
      String ResultString = initGoal( Command );

      // If an error has occurred then return immediately with the error
      if( 'E' == ResultString.charAt(0) )
      {
         return( ResultString );
      }

      // Call the goal for the first time
      ResultString = callGoal();

      while( ResultString.charAt(0) == 'I' )
      {
         // Get the text portion of the string
         String TextString = ResultString.substring( 9 );

         // Select on the input tag
         switch( ResultString.charAt(8) )
         {
            case 'f' : // Flash a message
               MsgBox Msg1 = new MsgBox( parentFrame );
               Msg1.MessageBox( "\0ok\0"+TextString.substring(1) );
               ResultString = "";
            break;
            case 'm' : // A multiple selection
               MltBox Mlt = new MltBox( parentFrame );
               ResultString = Mlt.MultiBox( TextString ) + ". \0";
            break;
            case 's' : // A single selection
               LstBox Lst = new LstBox( parentFrame );
               ResultString = Lst.ListBox( TextString ) + ". \0";
            break;
            case 'e' : // An edit selection
               EdtBox Edt = new EdtBox( parentFrame );
               ResultString = Edt.EditBox( TextString ) + "\0";
            break;
            case 'x' : // A message box
               MsgBox Msg2 = new MsgBox( parentFrame );
               ResultString = Msg2.MessageBox( TextString );
            break;
         }

         ResultString = tellGoal( ResultString );
      }

      exitGoal();

      return( ResultString );

   }

}
