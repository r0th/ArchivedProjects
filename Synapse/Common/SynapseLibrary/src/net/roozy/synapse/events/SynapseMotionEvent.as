package net.roozy.synapse.events
{
	import flash.events.Event;
	
	import net.roozy.synapse.core.SynapseMotionData;
	import net.roozy.synapse.interfaces.ISynapseClient;
	
	public class SynapseMotionEvent extends Event
	{
		/**
		 * Event type for receving a connected device's motion.
		 */
		public static const DEVICE_MOTION_RECEIVED:String = "deviceMotionReceived";
		
		/**
		 * The data object describing the device's motion.
		 */
		public var deviceMotion:SynapseMotionData;
		
		/**
		 * The client who's device is sending motion data.
		 */
		public var client:ISynapseClient;
		
		/**
		 * Constructor.
		 */
		public function SynapseMotionEvent(type:String, deviceMotion:SynapseMotionData, client:ISynapseClient)
		{
			super(type);
			
			this.deviceMotion = deviceMotion;
			this.client = client;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SynapseMotionEvent(type, deviceMotion, client);
		}
	}
}