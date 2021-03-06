package sqlite.tests.data;
import sys.db.Object;
import sys.db.Types;

class MySpodClass extends Object
{
	public var theId:SId;
	public var int:SInt;
	public var double:SFloat;
	public var boolean:SBool;
	public var string:SString<255>;
	public var date:SDateTime;
	public var binary:SBinary;
	
	public var nullInt:SNull<Int>;
	public var enumFlags:SFlags<MyEnum>;
	
	@:relation(rid) public var relation:OtherSpodClass;
	@:relation(rnid) public var relationNullable:Null<OtherSpodClass>;
	
	//public var data:SData<ComplexClass>;
	//not working - cpp compile error
	//public var anEnum:SEnum<MyEnum>;
	
}