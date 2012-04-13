package net.roozy.synapse.events
{
	import flash.events.Event;
	
	import net.roozy.synapse.interfaces.ISynapseClient;
	
	/**
	 * An event dispatched for client interactions.
	 */
	public class SynapseClientEvent extends Event
	{
		/**
		 * The event type dispatched when a client connects to the server.
		 */
		public static const CLIENT_CONNECTED:String = "clientConnected";
		
		/**
		 * The event type dispatched when a client has disconnected from the server.
		 */
		public static const CLIENT_DISCONNECTED:String = "clientDisconnected";
		
		/**
		 * The client which is the target of the event.
		 */
		public var client:ISynapseClient;
		
		/**
		 * Constructor.
		 */
		public function SynapseClientEvent(type:String, client:ISynapseClient)
		{
			super(type);
			
			this.client = client;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event
		{
			return new SynapseClientEvent(type, client);
		}
	}
}