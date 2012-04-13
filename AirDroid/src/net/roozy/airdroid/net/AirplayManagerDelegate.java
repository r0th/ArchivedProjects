package net.roozy.airdroid.net;

import java.util.ArrayList;

public interface AirplayManagerDelegate 
{
	void airplayManagerFoundDevices(ArrayList<AirplayDevice> devices);
	void airplayManagerConnectedDevice();
}
