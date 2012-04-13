package net.roozy.synapse.events
{
	import flash.events.Event;
	
	import net.roozy.synapse.core.SynapseMotionData;
	import net.roozy.synapse.core.SynapseTouchData;
	import net.roozy.synapse.interfaces.ISynapseClient;
	
	public class SynapseTouchEvent extends Event
	{
		/**
		 * Event type for receving a connected device's motion.
		 */
		public static const TOUCH_RECEIVED:String = "touchReceived";
		
		/**
		 * The data object describing the touch.
		 */
		public var touch:SynapseTouchData;
		
		/**
		 * The client who's device is sending the touch.
		 */
		public var client:ISynapseClient;
		
		/**
		 * Constructor.
		 */
		public function SynapseTouchEvent(type:String, touch:SynapseTouchData, client:ISynapseClient)
		{
			super(type);
			
			this.touch = touch;
			this.client = client;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SynapseTouchEvent(type, touch, client);
		}
	}
}