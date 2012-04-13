package net.roozy.synapse.enum
{
	/**
	 * Enumerations for different types of data sent between client and server.
	 * These are available values for the type property of SynapseData.
	 */
	public class SynapseDataTypeEnum
	{
		/**
		 * Represents data sent when a client connects and the server provides the client its name.
		 */
		public static const CONNECTED:String = "connected";
		
		/**
		 * Represents a simple message (String) received from a client.
		 */
		public static const MESSAGE:String = "message";
		
		/**
		 * Represents device motion received from a client.
		 */
		public static const DEVICE_MOTION:String = "motion";
		
		/**
		 * Represents a message to tell the client device to vibrate.
		 */
		public static const VIBRATE:String = "vibrate";
		
		/**
		 * Represents a touch on a remote device.
		 */
		public static const TOUCH:String = "touch";
	}
}