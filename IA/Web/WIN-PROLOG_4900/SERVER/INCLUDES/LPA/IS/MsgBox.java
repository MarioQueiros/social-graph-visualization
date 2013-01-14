package lpa.is;

import java.awt.*;
import java.awt.event.*;
import java.util.StringTokenizer;

public class MsgBox extends Dialog
{
   Frame parent;

   Button okButton;
   Button cancelButton;
   Button yesButton;
   Button noButton;

   TextArea messageText;

   public String returnText;

// Constructor
   public MsgBox( Frame f )
   {
      super( (Frame)f, "flex", true );

      messageText   = new TextArea("",0,0,TextArea.SCROLLBARS_NONE);

      messageText.setEditable( false );

      okButton      = new Button( "OK" );
      cancelButton  = new Button( "Cancel" );
      yesButton     = new Button( "Yes" );
      noButton      = new Button( "No" );

      Panel buttonPanel  = new Panel( new GridLayout(5,1) );
      Panel listPanel    = new Panel();

      buttonPanel.add( okButton );
      buttonPanel.add( cancelButton );
      buttonPanel.add( yesButton );
      buttonPanel.add( noButton );

      this.add( listPanel,   BorderLayout.CENTER );
      this.add( buttonPanel, BorderLayout.EAST );

      parent = f;

      listPanel.add( messageText );

      okButton.addActionListener( new ActionListener()
         {
            public void actionPerformed(ActionEvent e)
            {
               setReturnText( "ok. " );
            }
         }
      );

      cancelButton.addActionListener( new ActionListener()
         {
            public void actionPerformed( ActionEvent e )
            {
               setReturnText( "cancel. " );
            }
         }
      );

      yesButton.addActionListener( new ActionListener()
         {
            public void actionPerformed( ActionEvent e )
            {
               setReturnText( "yes. " );
	        }
         }
      );

      noButton.addActionListener( new ActionListener()
         {
            public void actionPerformed( ActionEvent e )
            {
               setReturnText( "no. " );
	        }
         }
      );

      this.pack();
   }

// Control the modal dialog.
   public String MessageBox( String InputString )
   {
      StringTokenizer StrTok = new StringTokenizer( InputString.substring(1) );

      String Buttons = StrTok.nextToken( InputString.substring(0,1) );
      messageText.setText( StrTok.nextToken() );

      if( Buttons.equals( "ok" ) )
      {
         okButton.setVisible( true );
         cancelButton.setVisible( false );
         yesButton.setVisible( false );
         noButton.setVisible( false );
      }
      else
      if( Buttons.equals( "okcancel" ) )
      {
         okButton.setVisible( true );
         cancelButton.setVisible( true );
         yesButton.setVisible( false );
         noButton.setVisible( false );
      }
      else
      if( Buttons.equals( "yesno" ) )
      {
         okButton.setVisible( false );
         cancelButton.setVisible( false );
         yesButton.setVisible( true );
         noButton.setVisible( true );
      }
      else
      if( Buttons.equals("yesnocancel") )
      {
         okButton.setVisible( false );
         cancelButton.setVisible( true );
         yesButton.setVisible( true );
         noButton.setVisible( true );
      }

      setVisible( true );

      return( returnText );
   }

// Set the return text of the modal dialog and hide the dialog
   public void setReturnText( String s )
   {
      returnText = s;
      setVisible( false );
   }
}
