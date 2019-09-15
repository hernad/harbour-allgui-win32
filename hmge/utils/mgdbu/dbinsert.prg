/*

Syntax

  dbInsert( [<lBefore>] )  ->  nil

Arguments

  <lBefore> is true if you wish to insert the record before the current
  record, false (or not passed) if after.

Returns

  nil

Description

  dbInsert emulates the dBase INSERT command by appending a blank record
  at the end of the current file and "moving" all the records down leaving
  a blank record at the current position (or current position + 1 depending
  on the value of <lBefore>).

Examples

  #command INSERT [<b4: BEFORE>] => dbInsert( <.b4.> )

  use WHATEVER

  INSERT BEFORE

Author

  Todd C. MacDonald

Notes

  This function is an original work and is placed into the Public Domain by
  the author.

*/

#define DBS_NAME  1
#define FLD_BLK   1
#define FLD_VAL   2

//--------------------------------------------------------------------------//
FUNCTION dbInsert( lBefore )
//--------------------------------------------------------------------------//

   LOCAL nRec := RecNo() + 1
   LOCAL lSavDel := Set( _SET_DELETED, .F. )
   LOCAL nSavOrd := IndexOrd()
   LOCAL aFields := {}
   LOCAL lDeleted

   IF lBefore = NIL ; lBefore := .F. ; ENDIF

   IF lBefore

      // stop moving records when the current record is reached
      --nRec

   ENDIF

   // build the array of field get/set blocks with cargo space for field values
   AEval( dbStruct(), {| a | ;
      AAdd( aFields, { FieldBlock( a[ DBS_NAME ] ), nil } ) } )

   // process in physical order for speed
   dbSetOrder( 0 )

   // add a new record at eof
   dbAppend()

   // back up through the file moving records down as we go
   WHILE RecNo() > nRec

      // store all values from previous record in the appropriate cargo space
      dbSkip( -1 )
      AEval( aFields, {| a | a[ FLD_VAL ] := Eval( a[ FLD_BLK ] ) } )

      // save deleted status
      lDeleted := Deleted()

      // replace all values in next record with stored cargo values
      dbSkip()
      AEval( aFields, {| a | Eval( a[ FLD_BLK ], a[ FLD_VAL ] ) } )

      // set deleted status
      iif( lDeleted, dbDelete(), dbRecall() )

      // go to previous record
      dbSkip( -1 )

   END

   // blank out the "inserted" record
   AEval( aFields, {| a, cType | ;
      cType := ValType( Eval( a[ FLD_BLK ] ) ), ;
      Eval( a[ FLD_BLK ], ;
      iif( cType $ 'CM', '', ;
      iif( cType = 'N', 0, ;
      iif( cType = 'D', CToD( '  /  /  ' ), ;
      iif( cType = 'L', .F., nil ) ) ) ) ) } )

   // make sure it's not deleted
   dbRecall()

   // leave things the way we found them
   dbSetOrder( nSavOrd )
   Set( _SET_DELETED, lSavDel )

RETURN NIL
//--------------------------------------------------------------------------//
