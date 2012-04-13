package net.roozy.synapse.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import net.roozy.synapse.enum.SynapseDataTypeEnum;
	import net.roozy.synapse.events.SynapseClientEvent;
	import net.roozy.synapse.events.SynapseMessageEvent;
	import net.roozy.synapse.events.SynapseMotionEvent;
	import net.roozy.synapse.events.SynapseTouchEvent;
	import net.roozy.synapse.interfaces.ISynapseClient;

	/**
	 * A client that has connected to the SynapseServer.
	 */
	[Event(type="net.roozy.synapse.events.SynapseClientEvent", name="clientConnected")]
	[Event(type="net.roozy.synapse.events.SynapseClientEvent", name="clientDisconnected")]
	[Event(type="net.roozy.synapse.events.SynapseMessageEvent", name="messageReceived")]
	[Event(type="net.roozy.synapse.events.SynapseMotionEvent", name="deviceMotionReceived")]
	[Event(type="net.roozy.synapse.events.SynapseTouchEvent", name="touchReceived")]
	public class SynapseRemoteClient extends EventDispatcher implements ISynapseClient
	{
		/**
		 * The unique name of the client.
		 */
		private var _name:String
		
		public function set name(value:String) : void
		{
			_name = value;
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		/**
		 * The remote IP address of the client.
		 */
		private var _address:String;
		
		public function set address(value:String) : void
		{
			_address = value;
		}
		
		public function get address() : String
		{
			return _address;
		}
		
		/**
		 * The remote port of the client.
		 */
		private var _port:uint;
		
		public function set port(value:uint) : void
		{
			_port = value;
		}
		
		public function get port() : uint
		{
			return _port;
		}
		
		/**
		 * Flag set based on if the socket is open or closed.
		 */
		public var connected:Boolean;
		
		/**
		 * The socket used to communicate with the remote client.
		 */
		private var socket:Socket;
		
		/**
		 * Constructor.
		 * 
		 * @param socket The socket used for all communication with a remote client.
		 */
		public function SynapseRemoteClient(socket:Socket, name:String)
		{
			super();
			
			// Add the client's properties
			this.socket = socket;
			this.name = name;
			this.connected = socket.connected;
			
			// Add event listeners
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData, false, 0, true);
			socket.addEventListener(Event.CLOSE, onSocketClose, false, 0, true);
			
			// Send the connect data to the client, with its client name
			sendMessageInternal(SynapseDataTypeEnum.CONNECTED, name);
		}
		
		/**
		 * When the socket has received data, dispatch an event to the server.
		 */
		private function onSocketData(event:ProgressEvent) : void
		{
			var byteData:ByteArray = new ByteArray();
			socket.readBytes(byteData, 0, socket.bytesAvailable);
			var data:SynapseData = new SynapseData(byteData);
			
			switch(data.type)
			{
				case SynapseDataTypeEnum.CONNECTED:
					dispatchEvent(new SynapseClientEvent(SynapseClientEvent.CLIENT_CONNECTED, this));
					break;
				case SynapseDataTypeEnum.MESSAGE:
					dispatchEvent(new SynapseMessageEvent(SynapseMessageEvent.MESSAGE_RECEIVED, data.payload, this));
					break;
				case SynapseDataTypeEnum.DEVICE_MOTION:
					dispatchEvent(new SynapseMotionEvent(SynapseMotionEvent.DEVICE_MOTION_RECEIVED, new SynapseMotionData(data.payload), this));
					break;
				case SynapseDataTypeEnum.TOUCH:
					dispatchEvent(new SynapseTouchEvent(SynapseTouchEvent.TOUCH_RECEIVED, new SynapseTouchData(data.payload), this));
						break;
			}
		}
		
		/**
		 * When the socket has been closed by the client, dispatch an event to the server.
		 */
		private function onSocketClose(event:Event) : void
		{
			connected = false;
			dispatchEvent(new SynapseClientEvent(SynapseClientEvent.CLIENT_DISCONNECTED, this));
		}
		
		/**
		 * Sends a message through the socket of the appropriate type.
		 */
		private function sendMessageInternal(type:String, payload:String) : void
		{
			var data:SynapseData = new SynapseData();
			data.type = type;
			data.payload = payload;
			
			var bytes:ByteArray = data.serialize();
			
			socket.writeBytes(bytes, 0, bytes.bytesAvailable);
		}
		
		/**
		 * Sends a simple message to the client.
		 */
		public function sendMessage(message:String) : void
		{
			sendMessageInternal(SynapseDataTypeEnum.MESSAGE, message);
		}
		
		/**
		 * Sends a message to tell the client device to vibrate.
		 */
		public function sendVibrate() : void
		{
			sendMessageInternal(SynapseDataTypeEnum.VIBRATE, "");
		}
	}
}