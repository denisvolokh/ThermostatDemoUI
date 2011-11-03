package sg.denisvolokh.gwr
{
	import flash.events.MouseEvent;
	
	import spark.components.Group;
	import spark.components.VGroup;
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("down")]
	[SkinState("notConfirmed")]
	
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
		
		[SkinPart(required="false")]
		public var containerPrevValues : VGroup;
		
		[SkinPart(required="false")]
		public var containerCurrentValues : VGroup;
		
		private var mouseDownY : Number;
		
		public var currentValue : Number = 270;
		
		public var currentValueDelta : Number = 0;
		
		public var pendingValue : Number = 0;
		
		private var _notConfirmed : Boolean = false;
		
		private var notConfirmedChanged : Boolean = false;
		
		public function get notConfirmed():Boolean
		{
			return _notConfirmed;
		}
		
		public function set notConfirmed(value:Boolean):void
		{
			_notConfirmed = value;
			
			notConfirmedChanged = true;
			invalidateProperties();
			invalidateSkinState();
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
		
		private function onMouseDownHandler(event : MouseEvent):void
		{
			isMouseDown = true;
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			mouseDownY = event.stageY;
		}
		
		private function onMouseMoveHandler(event : MouseEvent):void
		{
			currentValueDelta = event.stageY - mouseDownY;
			
			mouseDownY = event.stageY;
		}
		
		private function onMouseUpHandler(event : MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			currentValueDelta = 0;
			
			isMouseDown = false;
			
			if (currentValue != pendingValue)
			{
				notConfirmed = true;
			}
		}
		
		private function onPrevValuesClickHandler(event : *):void
		{
			notConfirmed = false;
		}
		
		private function onCurrentValuesClickHandler(event : *):void
		{
			currentValue = pendingValue;
			
			notConfirmed = false;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (notConfirmedChanged)
			{
				notConfirmedChanged = false;
				
				if (notConfirmed)
				{
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				}
				else
				{
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				}
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (containerPrevValues == instance)
			{
				containerPrevValues.addEventListener(MouseEvent.CLICK, onPrevValuesClickHandler);
			}
			
			if (containerCurrentValues)
			{
				containerCurrentValues.addEventListener(MouseEvent.CLICK, onCurrentValuesClickHandler);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (containerPrevValues == instance)
			{
				containerPrevValues.removeEventListener(MouseEvent.CLICK, onPrevValuesClickHandler);
			}
			
			if (containerCurrentValues)
			{
				containerCurrentValues.removeEventListener(MouseEvent.CLICK, onCurrentValuesClickHandler);
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if (isMouseDown)
			{
				return "down";
			}
			
			if (notConfirmed)
			{
				return "notConfirmed";
			}
			
			return "normal";
		}
				
	}
}