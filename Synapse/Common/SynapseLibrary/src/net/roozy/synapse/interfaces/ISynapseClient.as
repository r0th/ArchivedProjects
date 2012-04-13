package net.roozy.synapse.interfaces
{
	/**
	 * The interface describing both remote clients (used on the server) and regular client.
	 */
	public interface ISynapseClient
	{
		function set name(value:String) : void;
		function get name() : String;
		
		function set address(value:String) : void;
		function get address() : String;
		
		function set port(value:uint) : void;
		function get port() : uint;
	}
}