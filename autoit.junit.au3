#include <Date.au3>
#include <Array.au3>

;# AutoIT-junit-module
;## USAGE
;1.  include this file on your .au3 script: #include <autoit.junit.au3>
;2.  register the function: OnAutoItExitRegister("FlushTestResultsJUNIT")
;3.  use the 2 main functions:
;    * setup the suite case:	SetupJUNITTestSuite('Suite package one','1','Suite tests one')
;    * add a failed case:	AddJUNITTestCase( '1','Parameters Initialization unsuccessfully','Details message','first parameter type failed','type failed message detail')
;    * add a success case:	AddJUNITTestCase( '','Parameters Initialization successfully','Details message','','' )

Global $JUNIT_start_date = _NowCalc()

Global $JUNIT_last_test_end_date = _NowCalc()

Global $JUNIT_LOGFILE = @ScriptDir & "\JUnit_Report.xml"

Global $JUNIT_testsuites_name = "Test Suites Name"
Global $JUNIT_testsuite_id = "1"
Global $JUNIT_testsuite_name = "Test Suite Name"

Global $JUNIT_testsuite_failures = 0
Global $JUNIT_testsuite_tests = 0

Global $JUNIT_testcase_id = []
Global $JUNIT_testcase_name = []
Global $JUNIT_testcase_message = []
Global $JUNIT_testcase_failure_type = []
Global $JUNIT_testcase_failure_text = []
Global $JUNIT_testcase_time = []

Func SetupJUNITTestSuite($testsuites_name,$testsuite_id,$testsuite_name)
   $JUNIT_testsuites_name = $testsuites_name;
   $JUNIT_testsuite_id = $testsuite_id;
   $JUNIT_testsuite_name = $testsuite_name;
EndFunc

Func AddJUNITTestCase( $JUNIT_id,$JUNIT_name,$JUNIT_message,$JUNIT_failure_type,$JUNIT_failure_text )

   $JUNIT_testsuite_tests = $JUNIT_testsuite_tests + 1;
   _ArrayAdd( $JUNIT_testcase_id, ($JUNIT_id == '' ? $JUNIT_testsuite_tests : $JUNIT_id) );
   _ArrayAdd( $JUNIT_testcase_name, $JUNIT_name );
   _ArrayAdd( $JUNIT_testcase_message, $JUNIT_message );
   _ArrayAdd( $JUNIT_testcase_time, _DateDiff( 's', $JUNIT_last_test_end_date, _NowCalc() ) );

   If($JUNIT_failure_type <> "")Then
	 $JUNIT_testsuite_failures = $JUNIT_testsuite_failures + 1;
	  _ArrayAdd( $JUNIT_testcase_failure_type, $JUNIT_failure_type );
	  _ArrayAdd( $JUNIT_testcase_failure_text, $JUNIT_failure_text );
   Else
	  _ArrayAdd( $JUNIT_testcase_failure_type, "" );
	  _ArrayAdd( $JUNIT_testcase_failure_text, "" );
   EndIf
   $JUNIT_last_test_end_date = _NowCalc()
EndFunc


Func FlushTestResultsJUNIT()

   Local $str_XML = '<?xml version="1.0" encoding="UTF-8"?>' & @CRLF & _
	'<testsuites name="' & $JUNIT_testsuites_name & '"  time="' &  _DateDiff( 's', $JUNIT_start_date, _NowCalc() )  & '" >'& @CRLF & _
	'<testsuite id="' & $JUNIT_testsuite_id & '" failures="' & $JUNIT_testsuite_failures & '" name="' & $JUNIT_testsuite_name & '" tests="' & $JUNIT_testsuite_tests & '">'& @CRLF

   For $t = 1 to $JUNIT_testsuite_tests
	  Local $str_XML_system_out = $JUNIT_testcase_message[$t] <> '' ? '<system-out><![CDATA['& @CRLF & $JUNIT_testcase_message[$t] & @CRLF & ']]></system-out>' : '';
	  If($JUNIT_testcase_failure_type[$t] == "")Then
		 $str_XML = $str_XML & '		<testcase id="' & $JUNIT_testcase_id[$t] & '" name="' & $JUNIT_testcase_name[$t] & '" time="'&  $JUNIT_testcase_time[$t] &'">' & $str_XML_system_out & '</testcase>'& @CRLF
	  Else
		 $str_XML = $str_XML & '		<testcase id="' & $JUNIT_testcase_id[$t] & '" name="' & $JUNIT_testcase_name[$t] & '" time="'&  $JUNIT_testcase_time[$t] &'">'& @CRLF & _
		 '			<failure message="' & $JUNIT_testcase_message[$t] & '" type="'& $JUNIT_testcase_failure_type[$t] &'"></failure> ' & $str_XML_system_out & _
		 '		</testcase>'& @CRLF
	  EndIf
   Next
   $str_XML = $str_XML & '	</testsuite>'& @CRLF & _
   '</testsuites>'

   If FileExists( $JUNIT_LOGFILE ) then
	 FileDelete( $JUNIT_LOGFILE )
   EndIf

   $hFile = FileOpen($JUNIT_LOGFILE, 1)
   If $hFile <> -1 Then
	  FileWriteLine($hFile, $str_XML & @CRLF)
	  FileClose($hFile)
   Else
	  ConsoleWrite('ERROR: An error occurred writing the JUNIT file.' & @CRLF)
   EndIf
EndFunc