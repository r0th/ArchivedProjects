package net.roozy.synapse.core
{
	import com.adobe.serialization.json.JSON;

	public class SynapseMotionData
	{
		/**
		 * The device's motion along the X axis.
		 */
		public var x:Number;
		
		/**
		 * The device's motion along the Y axis.
		 */
		public var y:Number;
		
		/**
		 * The device's motion along the Z axis.
		 */
		public var z:Number;
		
		/**
		 * Constructor.
		 */
		public function SynapseMotionData(jsonData:String = null)
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
			var ob:Object = {deviceX: x, deviceY: y, deviceZ: z}
			return JSON.encode(ob);
		}
		
		/**
		 * Deserializes a JSON string into a valid data object.
		 */
		private function deserialize(json:String) : void
		{
			var ob:Object = JSON.decode(json);
			x = ob.deviceX;
			y = ob.deviceY;
			z = ob.deviceZ;
		}
	}
}