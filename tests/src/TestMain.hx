package ;
import sqlite.tests.SpodTests;
import utest.Runner;
import utest.ui.Report;

class TestMain 
{
	
	static function main() 
	{
		var runner = new Runner();
		runner.addCase(new SpodTests());
		
		var report = Report.create(runner);
		runner.run();
		
		
	}
	
}