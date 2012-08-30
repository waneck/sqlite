package sqlite.tests.data;

class ComplexClass 
{
	public var val: { name:String, array:Array<String> };
	
	public function new(val) 
	{
		this.val = val;
	}
}