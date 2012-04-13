package net.roozy.synapse.events
{
	import flash.events.Event;
	
	import net.roozy.synapse.interfaces.ISynapseClient;
	
	/**
	 * An event that represents plain text messages.
	 */
	public class SynapseMessageEvent extends Event
	{
		/**
		 * The event type for the server receiving a plain text message.
		 */
		public static const MESSAGE_RECEIVED:String = "messageReceived";
		
		/**
		 * The message that has been received by a client.
		 */
		public var message:String;
		
		/**
		 * The client that sent the message.
		 */
		public var client:ISynapseClient;
		
		/**
		 * Constructor.
		 */
		public function SynapseMessageEvent(type:String, message:String, client:ISynapseClient)
		{
			super(type);
			
			this.message = message;
			this.client = client;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event
		{
			return new SynapseMessageEvent(type, message, client);
		}
	}
}