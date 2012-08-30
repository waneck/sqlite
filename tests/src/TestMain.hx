package ;
import sqlite.tests.SpodTests;
import utest.Runner;

class TestMain 
{
	
	static function main() 
	{
		var runner = new Runner();
		runner.addCase(new SpodTests());
		runner.run();
	}
	
}