import ctypes

class PrologError( Exception ) :
   """ Exception raised for errors in prolog.
   """
   
   def __init__( self, *value ):
      self.parameter = value

   def __str__( self ) :
      return repr(self.parameter)

class int386w() :
   """Intelligence Server Interface
      
      loadProlog( self, command, buffer, type )
      initGoal( self, goal )
      callGoal( self ) 
      exitGoal( self )
      tellGoal( self, data )
      haltProlog( self )

   """

   def __init__(self) :
       "Load the Intelligence Server DLL."
       self.prolog = ctypes.windll.LoadLibrary( "Int386W.DLL" )

   def __iter__( self ) :
      "Return an iterator."
      return self

   def loadProlog( self, command="", buffer=0, type=0 ) :
      """Load prolog with the given arguments.
         command : Is a string of commands for prolog (memory sizes etc).
         buffer  : Is the requested size for the interface buffer, 0 = 65535
         type    : Is unicode or ansi strings, 0 (default) is ansi, 1 is unicode.
      """
      self.type = type
      result = self.prolog.LoadProlog( command, buffer, type, 0 )
      if result < 1 :
         raise PrologError( result, "An error occured while attempting to load prolog." )
      else:
         if type == 0 :
            self.to_string = ctypes.c_char_p
         else:
            self.to_string = ctypes.c_wchar_p
         self.id = result
         return self.id
   
   def initGoal( self, goal ) :
      " Initialise a goal to execute "
      return self.to_string( self.prolog.InitGoal(self.id, goal)).value

   def callGoal( self ) :
      " Call a previously initialised goal "
      return self.to_string( self.prolog.CallGoal(self.id)).value
   
   def tellGoal( self, data ) :
      " Respond to prologs request for more data "
      return self.to_string( self.prolog.TellGoal(self.id,data)).value
   
   def exitGoal( self ) :
      "Drop or exit a previously initialized goal."
      return self.prolog.ExitGoal(self.id)

   def haltProlog( self ) :
      "Halt the currently running prolog."
      return self.prolog.HaltProlog(self.id) 

   def next( self ) :
      "Get the next result through backtracking, finish if failure reported"
      result = self.callGoal()
      if result[0] == 'F':
         self.exitGoal()
         raise StopIteration
      else :
         return result

   def __next__( self ) :
      "Get the next result through backtracking, finish if failure reported"
      result = self.callGoal()
      if result[0] == 'F':
         self.exitGoal()
         raise StopIteration
      else :
         return result

if __name__ == "__main__": 

   def callOneGoal( prolog, goal ) :
      prolog.initGoal( goal )
      s = prolog.callGoal()
      prolog.exitGoal()
      return( s )
  
   prolog=int386w()
   prolog.loadProlog( "", 0, 0)
   prolog.initGoal( "statistics. ")

   s = prolog.callGoal()
   prolog.exitGoal()

   (r,c,v) = (s[0],s[2:6],s[8:])
   print( r )
   print( c )
   print( v )

   for r in callOneGoal( prolog, "pdict(-1,-1,0,P), forall( member(X,P), (writeq(X),write( `~I`))). ")[8:].split( '\t'):
      print( r.split(',') )

   prolog.initGoal( "integer_bound(1,X,10), write(X). " )
   
   for s in prolog :
      r, c, v = s[0], s[2:6], int(s[8:])
      print( '| {0:{4}}| {1:{4}}| {2:{4}}| {3:{4}}|'.format(v,v*v,v*v*v,v*v*v*v,"<12"))

   prolog.exitGoal()

   prolog.haltProlog()

