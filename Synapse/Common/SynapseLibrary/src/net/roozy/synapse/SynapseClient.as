package net.roozy.synapse
{
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.Socket;
	import flash.sensors.Accelerometer;
	import flash.utils.ByteArray;
	
	import net.roozy.synapse.core.SynapseData;
	import net.roozy.synapse.core.SynapseMotionData;
	import net.roozy.synapse.core.SynapseTouchData;
	import net.roozy.synapse.enum.SynapseDataTypeEnum;
	import net.roozy.synapse.events.SynapseClientEvent;
	import net.roozy.synapse.events.SynapseMessageEvent;
	import net.roozy.synapse.interfaces.ISynapseClient;

	/**
	 * The base class for an AIR for Android client.
	 */
	[Event(type="net.roozy.synapse.events.SynapseClientEvent", name="clientConnected")]
	[Event(type="net.roozy.synapse.events.SynapseClientEvent", name="clientDisconnected")]
	[Event(type="net.roozy.synapse.events.SynapseMessageEvent", name="messageReceived")]
	public class SynapseClient extends EventDispatcher implements ISynapseClient
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
		 * The socket to communicate with the server.
		 */
		private var socket:Socket;
		
		/**
		 * The accelerometer used to send motion events
		 */
		private var accelerometer:Accelerometer;
		
		/**
		 * Constructor.
		 */
		public function SynapseClient(address:String = "127.0.0.1", port:uint = 2460)
		{
			this.address = address;
			this.port = port;
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
		 * Initiates the connection with the server.
		 */
		public function connect() : void
		{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onSocketConnect, false, 0, true);
			socket.addEventListener(Event.CLOSE, onSocketClose, false, 0, true);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData, false, 0, true);
			socket.connect(address, port);
		}
		
		/**
		 * Dispatched when the socket has connected.
		 */
		private function onSocketConnect(event:Event) : void
		{
			trace("CONNECTED");
		}
		
		/**
		 * Dispatch a disconnect event
		 */
		public function onSocketClose(event:Event) : void
		{
			dispatchEvent(new SynapseClientEvent(SynapseClientEvent.CLIENT_DISCONNECTED, this));
		}
		
		/**
		 * Parse the received data and dispatch an appropriate event.
		 */
		private function onSocketData(event:ProgressEvent) : void
		{
			var byteData:ByteArray = new ByteArray();
			socket.readBytes(byteData, 0, socket.bytesAvailable);
			var data:SynapseData = new SynapseData(byteData);
			
			switch(data.type)
			{
				case SynapseDataTypeEnum.CONNECTED:
					this.name = data.payload;
					dispatchEvent(new SynapseClientEvent(SynapseClientEvent.CLIENT_CONNECTED, this));
					sendMessageInternal(SynapseDataTypeEnum.CONNECTED, "");
					break;
				case SynapseDataTypeEnum.MESSAGE:
					dispatchEvent(new SynapseMessageEvent(SynapseMessageEvent.MESSAGE_RECEIVED, data.payload, this));
					break;
				case SynapseDataTypeEnum.VIBRATE:
					//TODO: Vibrate the device
					break;
			}
		}
		
		/**
		 * Create a new JSON string from the motion data on send a message to the server.
		 */
		private function onAccelerometerData(event:AccelerometerEvent) : void
		{
			var data:SynapseMotionData = new SynapseMotionData();
			data.x = event.accelerationX;
			data.y = event.accelerationY;
			data.z = event.accelerationZ;
			
			sendMessageInternal(SynapseDataTypeEnum.DEVICE_MOTION, data.serialize());
		}
		
		/**
		 * Sends a simple message to the server.
		 */
		public function sendMessage(message:String) : void
		{
			sendMessageInternal(SynapseDataTypeEnum.MESSAGE, message);
		}
		
		/**
		 * Starts sending device motion updates.
		 */
		public function startMotionUpdates() : void
		{
			if(!Accelerometer.isSupported)
			{
				if(!accelerometer)
				{
					accelerometer = new Accelerometer();
				}
				
				accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerData, false, 0, true);
			}
		}
		
		/**
		 * Stops sending device motion updates.
		 */
		public function stopMotionUpdates() : void
		{
			if(accelerometer)
			{
				accelerometer.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometerData);
			}
		}
		
		/**
		 * Sends a touch event to the server.
		 */
		public function sendTouch(point:Point) : void
		{
			var data:SynapseTouchData = new SynapseTouchData();
			data.point = new Point(Math.max(0, Math.min(point.x, 1)), Math.max(0, Math.min(point.y, 1)));
			
			sendMessageInternal(SynapseDataTypeEnum.TOUCH, data.serialize());
		}
	}
}