package sqlite.tests.data;
import sys.db.Object;
import sys.db.Types;

class OtherSpodClass extends Object
{
	public var theid:SId;
	public var name:SString<255>;
	
	public function new(name:String)
	{
		super();
		this.name = name;
	}
}