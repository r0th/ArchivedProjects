package net.roozy.synapse
{
	import flash.events.EventDispatcher;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.utils.Dictionary;
	
	import net.roozy.synapse.core.SynapseRemoteClient;
	import net.roozy.synapse.events.SynapseClientEvent;
	import net.roozy.synapse.events.SynapseMessageEvent;
	import net.roozy.synapse.events.SynapseMotionEvent;
	import net.roozy.synapse.events.SynapseTouchEvent;

	/**
	 * The base class for an AIR Desktop application that behaves as a server.
	 */
	[Event(type="net.roozy.synapse.events.SynapseClientEvent", name="clientConnected")]
	[Event(type="net.roozy.synapse.events.SynapseClientEvent", name="clientDisconnected")]
	[Event(type="net.roozy.synapse.events.SynapseMessageEvent", name="messageReceived")]
	[Event(type="net.roozy.synapse.events.SynapseMotionEvent", name="deviceMotionReceived")]
	[Event(type="net.roozy.synapse.events.SynapseTouchEvent", name="touchReceived")]
	public class SynapseServer extends EventDispatcher
	{
		/**
		 * The IP of the server.
		 */
		public var address:String;
		
		/**
		 * The port of the server.
		 */
		public var port:int;
		
		/**
		 * The map of all clients.
		 */
		private var clients:Dictionary;
		
		/**
		 * The number of clients connected.
		 */
		private var numClients:uint = 0;
		
		/**
		 * The server socket used for all communication.
		 */
		private var serverSocket:ServerSocket;
		
		/**
		 * Constructor.
		 * 
		 * @param port The target port of the server.
		 * @param address The IP address of the server, which usually doesn't need to change.
		 */
		public function SynapseServer(port:int = 2460, address:String = "0.0.0.0")
		{
			this.address = address;
			this.port = port;
			
			clients = new Dictionary();
		}
		
		/**
		 * When a client connects, add it to the dictionary.
		 */
		protected function onSocketConnect(event:ServerSocketConnectEvent) : void
		{
			numClients++;
			var newName:String = "CLIENT_" + numClients;
			var client:SynapseRemoteClient = new SynapseRemoteClient(event.socket, newName);
			client.addEventListener(SynapseClientEvent.CLIENT_CONNECTED, onClientConnected, false, 0, true);
			client.addEventListener(SynapseClientEvent.CLIENT_DISCONNECTED, onClientDisconnected, false, 0, true);
			client.addEventListener(SynapseMessageEvent.MESSAGE_RECEIVED, onClientMessageReceived, false, 0, true);
			client.addEventListener(SynapseMotionEvent.DEVICE_MOTION_RECEIVED, onClientMotionReceived, false, 0, true);
			client.addEventListener(SynapseTouchEvent.TOUCH_RECEIVED, onClientTouchReceived, false, 0, true);
			clients[newName] = client;
		}
		
		/**
		 * Starts the server.
		 */
		public function start() : void
		{
			serverSocket = new ServerSocket();
			serverSocket.bind(port, address);
			serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onSocketConnect, false, 0, true);
			serverSocket.listen();
		}
		
		/**
		 * Stops the server.
		 */
		public function stop() : void
		{
			serverSocket.close();
		}
		
		/**
		 * Sends a message to all connected clients.
		 */
		public function sendMessageToAll(message:String) : void
		{
			var client:SynapseRemoteClient;
			for each(client in clients)
			{
				if(client.connected)
				{
					client.sendMessage(message);
				}
			}
		}
		
		/**
		 * When a client has connected, dispatch an event.
		 */
		private function onClientConnected(event:SynapseClientEvent) : void
		{
			dispatchEvent(event.clone());
		}
		
		/**
		 * When a client has disonnected, dispatch an event.
		 */
		private function onClientDisconnected(event:SynapseClientEvent) : void
		{
			dispatchEvent(event.clone());
		}
		
		/**
		 * When a client has sent a message, dispatch an event.
		 */
		private function onClientMessageReceived(event:SynapseMessageEvent) : void
		{
			dispatchEvent(event.clone());
		}
		
		/**
		 * When a client has sent device motion, dispatch an event.
		 */
		private function onClientMotionReceived(event:SynapseMotionEvent) : void
		{
			dispatchEvent(event.clone());
		}
		
		/**
		 * When a client has sent a touch, dispatch an event.
		 */
		private function onClientTouchReceived(event:SynapseTouchEvent) : void
		{
			dispatchEvent(event.clone());
		}
	}
}