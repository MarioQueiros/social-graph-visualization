package lpa.is;

import java.awt.*;
import java.awt.event.*;
import java.util.StringTokenizer;

public class MltBox extends Dialog
{
   Frame parent;

   Button okButton;
   Button explainButton;
   List inputList;
   TextArea messageText;

   public String returnText;

// Constructor
   MltBox( Frame f )
   {
      super( (Frame)f, "flex", true );

      okButton      = new Button( "OK" );
      explainButton = new Button( "Explain" );
      inputList     = new List();
      messageText   = new TextArea("",0,0,TextArea.SCROLLBARS_NONE);

      messageText.setEditable( false );

      Panel buttonPanel  = new Panel( new GridLayout(5,1) );
      Panel listPanel    = new Panel( new GridLayout(2,1) );

      this.add( listPanel,   BorderLayout.CENTER );
      this.add( buttonPanel, BorderLayout.EAST );

      parent = f;

      buttonPanel.add( okButton );
      buttonPanel.add( explainButton );

      listPanel.add( messageText );
      listPanel.add( inputList   );

      inputList.setMultipleMode( true );

      okButton.addActionListener( new ActionListener()
         {
            public void actionPerformed(ActionEvent e)
            {
               String[] StringArray = inputList.getSelectedItems();

               String ResultString = new String( "[" );
               String SeparatorString = new String( " " );

               for( int i = 0; i < StringArray.length ; i ++ )
               {
                  ResultString = ResultString + SeparatorString + StringArray[i];
                  SeparatorString = ",";
               }


               if( ResultString.equals( "[" ) )
                  setReturnText( "??" );
               else
                  setReturnText( ResultString + "] " );
            }
         }
      );

      explainButton.addActionListener( new ActionListener()
         {
            public void actionPerformed( ActionEvent e )
            {
               setReturnText( "??" );
            }
         }
      );

      this.pack();
   }


// Control the modal dialog.
   public String MultiBox( String InputString )
   {
      StringTokenizer StrTok = new StringTokenizer( InputString.substring(1) );

      setTitle( StrTok.nextToken( InputString.substring(0,1) ) );
      messageText.setText( StrTok.nextToken() );

	  inputList.removeAll();

      while( StrTok.hasMoreTokens() )
      {
         inputList.add( StrTok.nextToken() );
      }

      returnText = "";

      setVisible( true );

      return( returnText );
   }

// Set the return text of the modal dialog
   public void setReturnText( String s )
   {
      returnText = s;
      setVisible( false );
   }
}
