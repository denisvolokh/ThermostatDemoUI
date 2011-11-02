package sg.denisvolokh.gwr
{
	import mx.graphics.SolidColor;
	
	import spark.primitives.Path;
	
	public class BarTick extends Path
	{
		public function BarTick()
		{
			super();
			
			this.data = "M 94,-2 L 114,-2 114,4 94,4 Z";
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