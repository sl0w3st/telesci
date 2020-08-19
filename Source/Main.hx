package;

import openfl.display.Application;
import lime.ui.Window;
import minimalcomps.components.PushButton;
import minimalcomps.components.Label;
import minimalcomps.components.InputText;
import minimalcomps.components.Style;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

class Main extends Sprite
{
	var telesci:TeleSci = new TeleSci();
	var off_power_input:LabeledInput;
	var off_rot_input:LabeledInput;
	var power_input:LabeledInput;
	var angle_input:LabeledInput;
	var rotation_input:LabeledInput;
	var d_x_input:LabeledInput;
	var d_y_input:LabeledInput;
	public function new()
	{
		super();
		
		Style.setStyle(Style.DARK);
		var t_label:Label = new Label(this, 10, 10, "Pad coords:");
		var t_x_input:LabeledInput = new LabeledInput(this, 10, 30, "x");
		t_x_input.addEventListener(Event.CHANGE, (_)->{
			telesci.x = Std.parseInt(t_x_input.text);
		});
		t_x_input.set_width(30);
		var t_y_input:LabeledInput = new LabeledInput(this, 10, 50, "y");
		t_y_input.addEventListener(Event.CHANGE, (_)->{
			telesci.y = Std.parseInt(t_y_input.text);
		});
		t_y_input.set_width(30);

		var off_label:Label = new Label(this, 80, 10, "Offsets:");

		off_power_input = new LabeledInput(this, 80, 30, "Pow");
		off_power_input.addEventListener(Event.CHANGE, (_)->{
			telesci.x = Std.parseInt(off_power_input.text);
		});
		off_power_input.set_width(30);
		off_rot_input = new LabeledInput(this, 80, 50, "Rot");
		off_rot_input.addEventListener(Event.CHANGE, (_)->{
			telesci.rot_offset = Std.parseInt(off_rot_input.text);
		});
		off_rot_input.set_width(30);


		var inputs_label:Label = new Label(this, 150, 10, "Console input:");

		power_input = new LabeledInput(this, 150, 30, "Pow");
		power_input.addEventListener(Event.CHANGE, (_)->{
			telesci.power = Std.parseInt(power_input.text);
		});
		power_input.set_width(30);
		angle_input = new LabeledInput(this, 150, 50, "Ele");
		angle_input.addEventListener(Event.CHANGE, (_)->{
			telesci.a = Std.parseFloat(angle_input.text);
		});
		angle_input.set_width(30);
		rotation_input = new LabeledInput(this, 150, 70, "Bea");
		rotation_input.addEventListener(Event.CHANGE, (_)->{
			telesci.rot = Std.parseFloat(rotation_input.text);
		});
		rotation_input.set_width(30);

		var dest_label:Label = new Label(this, 230, 10, "Destination:");
		d_x_input = new LabeledInput(this, 230, 30, "x");
		d_x_input.addEventListener(Event.CHANGE, (_)->{
			telesci.dest_x = Std.parseInt(d_x_input.text);
		});
		d_x_input.set_width(30);
		d_y_input = new LabeledInput(this, 230, 50, "y");
		d_y_input.addEventListener(Event.CHANGE, (_)->{
			telesci.dest_y = Std.parseInt(d_y_input.text);
		});
		d_y_input.set_width(30);

		power_input.text = Std.string(telesci.power);
		angle_input.text = Std.string(Math.round(telesci.a*10)/10);
		rotation_input.text = Std.string(Math.round(telesci.rot*100)/100);

		var calc_offsets_btn:PushButton = new PushButton(this, 300, 30, "Calc offsets");
		calc_offsets_btn.addEventListener(MouseEvent.CLICK, find_offsets);

		var calc_inputs_btn:PushButton = new PushButton(this, 300, 50, "Calc input");
		calc_inputs_btn.addEventListener(MouseEvent.CLICK, find_input);
	}

	function find_offsets(_)
	{
		telesci.rot_offset = Math.asin(telesci.dest_x-telesci.x)/(telesci.dest_y-telesci.y)*180/Math.PI;
		off_rot_input.text = Std.string(telesci.rot_offset);

		var d = Math.sqrt(Math.pow(telesci.dest_x-telesci.x, 2)+Math.pow(telesci.dest_y-telesci.y, 2));
		telesci.power_offset = telesci.power - Math.round(Math.sqrt(10*d));
		off_power_input.text = Std.string(telesci.power_offset);

		if(telesci.rot_offset <-10 || telesci.rot_offset > 10)
			trace("Wrong rot_offset calculation");
		if(telesci.power_offset <-4 || telesci.power_offset > 0)
			trace("Wrong power_offset calculation");

		d_x_input.text = "";
		d_y_input.text = "";
	}
	function find_input(_)
	{
		var d:Float = Math.sqrt(Math.pow(telesci.dest_x-telesci.x, 2)+Math.pow(telesci.dest_y-telesci.y, 2));

		var raw_power = Math.sqrt(10*d)-telesci.power_offset;

		if ( raw_power <= 5.0 ) {
			telesci.power = 5;
		} else if ( raw_power <= 10.0 ) {
			telesci.power = 10;
		} else if ( raw_power <= 20.0 ) {
			telesci.power = 20;
		} else if ( raw_power <= 25.0 ) {
			telesci.power = 25;
		} else if ( raw_power <= 30.0 ) {
			
		} else if ( raw_power <= 40.0 ) {
			telesci.power = 40;
		} else if ( raw_power <= 50.0 ) {
			telesci.power = 50;
		} else if ( raw_power <= 80.0 ) {
			telesci.power = 80;
		} else if ( raw_power <= 100.0 ) {
			telesci.power = 100;
		}
		power_input.text = Std.string(telesci.power);

		telesci.a = Math.asin(10*d/Math.pow(telesci.power-telesci.power_offset, 2))*90/Math.PI;
		angle_input.text = Std.string(Math.round(telesci.a*10)/10);

		telesci.rot = Math.asin((telesci.dest_x-telesci.x)/d)*180/Math.PI;
		rotation_input.text = Std.string(Math.round(telesci.rot*100)/100);

	}
}

class LabeledInput extends InputText
{
	var label:Label;
	public function new(?parent:openfl.display.DisplayObjectContainer = null, ?xpos:Float = 0.0, ?ypos:Float = 0.0, ?text:String = "", ?defaultHandler:Dynamic = null) {
		super(parent, xpos+30, ypos, "", defaultHandler);
		label = new Label(parent, xpos, ypos, text);
	}
}

class TeleSci{
	public var x:Int;
	public var y:Int;

	public var dest_x:Int;
	public var dest_y:Int;

	public var power:Int = 20;
	public var power_offset:Int;

	public var rot:Float = 0;
	public var rot_offset:Float;

	public var a:Float = 45;
	public function new() {
		
	}
}

