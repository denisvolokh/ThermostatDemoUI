package sg.denisvolokh.nest
{
	import mx.graphics.SolidColor;
	
	import spark.primitives.Path;
	
	public class SmallTick extends Path
	{
		public function SmallTick()
		{
			super();
			
			this.data = "M 74,-0.5 L 94,-0.5 94,0.5 74,0.5 Z";
			this.fill = new SolidColor(0x444444, .7);
		}
		
		private var _color : uint;
		
		private var isColorChanged : Boolean = false;

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			
			isColorChanged = true;
			this.invalidateProperties();
		}

		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (isColorChanged)
			{
				this.isColorChanged = false;
				this.fill = new SolidColor(color);
			}
		}
	}
}