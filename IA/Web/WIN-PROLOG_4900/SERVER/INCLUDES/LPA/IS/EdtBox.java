package lpa.is;

import java.awt.*;
import java.awt.event.*;
import java.util.StringTokenizer;

public class EdtBox extends Dialog
{
   Button okButton,
          explainButton;

   TextArea inputText,
            messageText;

   Frame parent;

   public String returnText;

// Constructor
   EdtBox( Frame f )
   {
      super( (Frame)f, "flex", true );

      okButton      = new Button( "OK" );
      explainButton = new Button( "Explain" );
      inputText     = new TextArea();
      messageText   = new TextArea("",0,0,TextArea.SCROLLBARS_NONE);

      messageText.setEditable( false );

      Panel buttonPanel = new Panel( new GridLayout(5,1) );
      Panel textPanel = new Panel( new GridLayout(2,1) );

      this.add( textPanel, BorderLayout.CENTER );
      this.add( buttonPanel, BorderLayout.EAST );

      parent = f;

      buttonPanel.add( okButton );
      buttonPanel.add( explainButton );

      textPanel.add( messageText );
      textPanel.add( inputText );

      okButton.addActionListener( new ActionListener()
         {
            public void actionPerformed(ActionEvent e)
            {
               setReturnText( inputText.getText() );
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

   }

// Control the modal dialog.
   public String EditBox( String InputString )
   {
      StringTokenizer StrTok = new StringTokenizer( InputString.substring(1) );

      setTitle( StrTok.nextToken( InputString.substring(0,1) ) );
      messageText.setText( StrTok.nextToken() );

      inputText.setText( StrTok.nextToken() );

      returnText = "";

      show();

      return( returnText );
   }

// Set the string returnText to the required value and hide the dialog.
   public void setReturnText( String s )
   {
      returnText = s;
      this.setVisible( false );
   }
}
