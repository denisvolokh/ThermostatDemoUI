package sg.denisvolokh.gwr
{
	import flash.events.MouseEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("down")]
	
	[Bindable]
	public class GWRThermostat extends SkinnableComponent
	{
		public function GWRThermostat()
		{
			super();
			
			width = 350;
			height = 350;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		
		private var mouseDownY : Number;
		
		private var mouseDownInitial : Number;
		
		public var currentValue : Number = 270;
		
		public var currentValueDelta : Number = 0;
		
		private var acumulatedDelta : Number = 0;
		
		private function onMouseDownHandler(event : MouseEvent):void
		{
			isMouseDown = true;
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			mouseDownY = event.stageY;
			mouseDownInitial = event.stageY;
		}
		
		private function onMouseMoveHandler(event : MouseEvent):void
		{
			this.currentValueDelta = event.stageY - mouseDownY;
			//this.currentValue += this.currentValueDelta;
			
			mouseDownY = event.stageY;
		}
		
		private function onMouseUpHandler(event : MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			currentValueDelta = 0;
			
			isMouseDown = false;
		}
		
		private var _isMouseDown : Boolean = false;

		public function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}

		public function set isMouseDown(value:Boolean):void
		{
			_isMouseDown = value;
			
			invalidateSkinState();
		}
		
		override protected function getCurrentSkinState():String
		{
			if (isMouseDown)
			{
				return "down";
			}
			
			return "normal";
		}
				
	}
}