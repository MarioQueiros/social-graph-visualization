package lpa.is ;

public class Int386w
{
   private int Id;
   
   public static int isERR_ENCODE = -1;
   public static int isERR_TICKLE = -2;
   public static int isERR_CMUTEX = -3;
   public static int isERR_WMUTEX = -4;
   public static int isERR_LOCATE = -5;
   public static int isERR_CREATE = -6;
   public static int isERR_MAPFIL = -7;
   public static int isERR_MODULE = -8;
   public static int isERR_PROLOG = -9;
   public static int isERR_ACTIVE = -10;
   public static int isERR_WINDOW = -11;
   
   
   public int loadProlog( String s )
   {
      return( loadProlog( s, 0, 0 ) );
   }
   
   public int loadProlog( String s, int desire, int tickle )
   {
      Id = nativeLoadProlog( s, desire, tickle );
      return Id;
   }

   public int haltProlog()
   {
      if( nativeHaltProlog(Id) != 0 ) {
         Id = 0;
         return 1;
      }  else
          return 0;
      
   }
   
   public String initGoal( String Goal )
   {
      return nativeInitGoal( Id, Goal );
   }
   
   public String callGoal( )
   {
      return nativeCallGoal( Id );
   }
   
   public String tellGoal( String Goal )
   {
      return nativeTellGoal( Id, Goal );
   }

   public int exitGoal( )
   {
      return nativeExitGoal(Id);
   }
   

   native int    nativeLoadProlog( String s, int desire, int tickle );
   native int    nativeHaltProlog( int prolog );
   native String nativeInitGoal( int prolog, String goal );
   native String nativeCallGoal( int prolog );
   native String nativeTellGoal( int prolog, String goal );
   native int    nativeExitGoal( int prolog );
   
   static {
      System.loadLibrary( "jint386w" );
   }
   
   public void finalize() {
      if( 0 != Id ) {
          haltProlog();
          Id = 0;
      }
   }
}
