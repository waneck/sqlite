package sqlite.tests;
import haxe.io.Bytes;
import haxe.EnumFlags;
import sqlite.tests.data.ComplexClass;
import sqlite.tests.data.MySpodClass;
import sqlite.tests.data.OtherSpodClass;
import sys.db.Connection;
import sys.db.Manager;
import sys.db.Sqlite;
import sys.db.TableCreate;
import sys.FileSystem;
import utest.Assert;

class SpodTests
{
	var db:Connection;
	
	public function new() 
	{
		if (FileSystem.exists("db.db3"))
		{
			FileSystem.deleteFile("db.db3");
		}
		
		db = Sqlite.open("db.db3");
		//create tables
		
		Manager.cnx = db;
		
		TableCreate.create(MySpodClass.manager);
		TableCreate.create(OtherSpodClass.manager);
	}
	
	function testSpodFail()
	{
		Assert.raises(function() new MySpodClass().insert());
		Assert.raises(function() new OtherSpodClass(null).insert());
	}
	
	function getDefaultClass()
	{
		var scls = new MySpodClass();
		scls.int = 1;
		scls.double = 2.0;
		scls.boolean = true;
		scls.string = "some string";
		scls.date = new Date(2012, 07, 30, 0, 0, 0);
		
		var bytes = Bytes.ofString("\x01\n\r\x02");
		scls.binary = bytes;
		scls.enumFlags = EnumFlags.ofInt(0);
		scls.enumFlags.set(FirstValue);
		scls.enumFlags.set(ThirdValue);
		
		#if haxe_2011
		scls.data = new ComplexClass( { name:"test", array:["this", "is", "a", "test"] } );
		scls.anEnum = SecondValue;
		#end
		
		return scls;
	}
	
	function testSpod()
	{
		var c1 = new OtherSpodClass("first spod");
		c1.insert();
		var c2 = new OtherSpodClass("second spod");
		c2.insert();
		
		var scls = getDefaultClass();
		
		scls.relation = c1;
		scls.relationNullable = c2;
		scls.insert();
		
		//after inserting, id must be filled
		Assert.notEquals(0, scls.theId);
		var theid = scls.theId;
		
		c1 = c2 = null;
		Manager.cleanup();
		
		var cls1 = MySpodClass.manager.get(theid);
		Assert.notNull(cls1);
		//after Manager.cleanup(), the instances should be different
		Assert.notEquals(cls1, scls);
		scls = null;
		
		Assert.equals(1, cls1.int);
		Assert.equals(2.0, cls1.double);
		Assert.equals(true, cls1.boolean);
		Assert.equals("some string", cls1.string);
		Assert.equals(new Date(2012, 07, 30, 0, 0, 0).getTime(), cls1.date.getTime());
		
		Assert.equals("\x01\n\r\x02", cls1.binary.toString());
		Assert.isTrue(cls1.enumFlags.has(FirstValue));
		Assert.isFalse(cls1.enumFlags.has(SecondValue));
		Assert.isTrue(cls1.enumFlags.has(ThirdValue));
		
		#if haxe_2011
		Assert.same(new ComplexClass( { name:"test", array:["this", "is", "a", "test"] } ), cls1.data);
		Assert.equals(SecondValue, cls1.anEnum);
		
		#end
		
		Assert.equals("first spod", cls1.relation.name);
		Assert.equals("second spod", cls1.relationNullable.name);
		
		//test create a new class
		var scls = getDefaultClass();
		
		scls.relation = new OtherSpodClass("third spod");
		scls.insert();
		
		scls = cls1 = null;
		Manager.cleanup();
		
		Assert.equals(2, MySpodClass.manager.all().length);
		var req = MySpodClass.manager.search( { relation: OtherSpodClass.manager.search( { name:"third spod" } ).first() } );
		Assert.equals(1, req.length);
		scls = req.first();
		
		scls.relation.name = "Test";
		scls.relation.update();
		
		Assert.isNull(OtherSpodClass.manager.search( { name:"third spod" } ).first());
	}
}