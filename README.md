# AutoIT-junit-module
## USAGE
1.  include this file on your .au3 script: #include <autoit.junit.au3>
2.  register the function: OnAutoItExitRegister("FlushTestResultsJUNIT")
3.  use the 2 main functions:
    * setup the suite case:	SetupJUNITTestSuite('Suite package one','1','Suite tests one')
    * add a failed case:	AddJUNITTestCase( '1','Initial start test case','Parameters Initialization Failed','Parameter Type Exception','first parameter type failed' )
    * add a success case:	AddJUNITTestCase( '2','Parameters Initialization successfully','','','' )