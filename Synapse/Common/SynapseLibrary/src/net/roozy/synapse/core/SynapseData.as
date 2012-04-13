package net.roozy.synapse.core
{
	import com.adobe.serialization.json.JSON;
	
	import flash.utils.ByteArray;

	/**
	 * A serialized version of data received and sent between client and server.
	 * This class is responsible for serializing and deserializing data to send and data received.
	 * Data is turned into a String in JSON format, then a ByteArray to send via a Socket.
	 */
	public class SynapseData
	{
		/**
		 * The data type.
		 * 
		 * @see net.roozy.synapse.enum.SynapseDataTypeEnum
		 */
		public var type:String;
		
		/**
		 * The payload of the data.
		 */
		public var payload:String;
		
		/**
		 * Constructor.
		 * 
		 * @param bytes An optional ByteArray argument which will be deserialized to construct this object.
		 */
		public function SynapseData(bytes:ByteArray = null)
		{
			if(bytes)
			{
				deserialize(bytes);
			}
		}
		
		/**
		 * Serializes this object into a JSON string, then to a ByteArray.
		 */
		public function serialize() : ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			var stringData:String = JSON.encode(this);
			bytes.writeUTFBytes(stringData);
			
			return bytes;
		}
		
		/**
		 * Deserializes a ByteArray into a valid object.
		 */
		private function deserialize(bytes:ByteArray) : void
		{
			var stringData:String = bytes.readUTFBytes(bytes.bytesAvailable);
			
			// Only take the first JSON object if multiple have been sent by the client
			if(stringData.indexOf("}{") != -1)
			{
				stringData = stringData.split("}{")[0] + "}";
			}
			
			var dataObject:Object = JSON.decode(stringData);
			
			this.type = dataObject.type;
			this.payload = dataObject.payload;
		}
	}
}