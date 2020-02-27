# AutoIT-junit-module
## USAGE
1.  include this file on your .au3 script: #include <autoit.junit.au3>
2.  register the function: OnAutoItExitRegister("FlushTestResultsJUNIT")
3.  use the 2 main functions:
   * setup the suite case:	SetupJUNITTestSuite('Suite package one','1','Suite tests one')
    * add a failed case:	AddJUNITTestCase( '1','Parameters Initialization unsuccessfully','Details message','first parameter type failed','type failed message detail')
    * add a success case:	AddJUNITTestCase( '','Parameters Initialization successfully','Details message','','' )
