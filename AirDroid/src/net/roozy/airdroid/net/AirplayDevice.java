package net.roozy.airdroid.net;

import java.io.Serializable;

public class AirplayDevice implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	public String name;
	public String type;
	public String address;
	public int port;
	public boolean connected = false;
	
	public AirplayDevice(String name, String type)
	{
		this.name = name;
		this.type = type;
	}
}
