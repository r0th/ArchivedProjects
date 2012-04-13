package net.roozy.airdroid.net;

import java.io.IOException;
import java.util.ArrayList;

import javax.jmdns.JmDNS;
import javax.jmdns.ServiceEvent;
import javax.jmdns.ServiceListener;

import android.app.Activity;
import android.content.Context;
import android.net.wifi.WifiManager;
import android.net.wifi.WifiManager.MulticastLock;
import android.os.Handler;

public class AirplayManager
{
	private String BONJOUR_TYPE = "_airplay._tcp.local.";
	
	private Activity parentActivity;
	private AirplayManagerDelegate delegate;
	private MulticastLock lock;
	private JmDNS bonjour;
	private ServiceListener bonjourListener;
	private ArrayList<AirplayDevice> discoveredDevices;
	private Handler osHandler = new Handler();
	
	public AirplayDevice connectedDevice;
	
	private static AirplayManager instance = null;
	public static AirplayManager getInstance(Activity parentActivity, AirplayManagerDelegate delegate)
	{
		if(instance == null) instance = new AirplayManager(parentActivity, delegate);
		
		instance.parentActivity = parentActivity;
		instance.delegate = delegate;
		
		return instance;
	}
	
	private AirplayManager(Activity parentActivity, AirplayManagerDelegate delegate)
	{
		this.parentActivity = parentActivity;
		this.delegate = delegate;
		
		discoveredDevices = new ArrayList<AirplayDevice>();
		
		osHandler = new Handler();
		
		WifiManager manager = (WifiManager)parentActivity.getSystemService(Context.WIFI_SERVICE);
		lock = manager.createMulticastLock("airdroid");
		lock.setReferenceCounted(true);
		lock.acquire();
	}
	
	public void dispose()
	{
		if (bonjour != null)
		{
            if (bonjourListener != null)
            {
                bonjour.removeServiceListener(BONJOUR_TYPE, bonjourListener);
                bonjourListener = null;
            }
            
            bonjour.unregisterAllServices();
            
            try
            {
                bonjour.close();
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            
            bonjour = null;
    	}

		osHandler = null;
		delegate = null;
		parentActivity = null;
        lock.release();
	}
	
	public void searchForDevices()
	{
		osHandler.postDelayed(new Runnable()
		{
			@Override
			public void run()
			{
				try
				{
					bonjour = JmDNS.create();
					bonjour.addServiceListener(BONJOUR_TYPE, bonjourListener = new ServiceListener()
			        {
			            @Override
			            public void serviceResolved(ServiceEvent ev)
			            {
			            	for(int i=0; i < discoveredDevices.size(); i++)
			            	{
			            		if(ev.getInfo().getName().equals(discoveredDevices.get(i).name))
			            		{
			            			connectedDevice = discoveredDevices.get(i);
			            			break;
			            		}
			            	}
			            	
			            	connectedDevice.address = ev.getInfo().getHostAddresses()[0];
			            	connectedDevice.port = ev.getInfo().getPort();
			            	
			            	parentActivity.runOnUiThread(new Runnable()
			            	{	
								@Override
								public void run()
								{
									delegate.airplayManagerConnectedDevice();
								}
							});
			            }

			            @Override
			            public void serviceRemoved(ServiceEvent ev)
			            {
			                //notifyUser("Service removed: " + ev.getName());
			            }

			            @Override
			            public void serviceAdded(ServiceEvent event)
			            {
			            	AirplayDevice device = new AirplayDevice(event.getName(), event.getType());
			            	discoveredDevices.add(device);
			            	
			            	parentActivity.runOnUiThread(new Runnable()
			            	{	
								@Override
								public void run()
								{
									delegate.airplayManagerFoundDevices(discoveredDevices);
								}
							});
			            }
			        });
				}
				catch (IOException e)
				{
					e.printStackTrace();
				}
			}
		}, 500);
	}
	
	public void connectToDevice(AirplayDevice device)
	{
		bonjour.requestServiceInfo(device.type, device.name, 1);
	}
}
