package net.roozy.synapse.core
{
	import com.adobe.serialization.json.JSON;
	
	import flash.geom.Point;

	public class SynapseTouchData
	{
		/**
		 * The point representing touch.
		 * The x and y are values between 0 and 1.
		 */
		public var point:Point;
		
		/**
		 * Constructor.
		 */
		public function SynapseTouchData(jsonData:String = null)
		{
			if(jsonData)
			{
				deserialize(jsonData);
			}
		}
		
		/**
		 * Serializes the data into a JSON string.
		 */
		public function serialize() : String
		{
			var ob:Object = {touchX: point.x, touchY: point.y}
			return JSON.encode(ob);
		}
		
		/**
		 * Deserializes a JSON string into a valid data object.
		 */
		private function deserialize(json:String) : void
		{
			var ob:Object = JSON.decode(json);
			point = new Point(ob.touchX, ob.touchY);;
		}
	}
}