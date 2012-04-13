package net.roozy.airdroid;

import java.util.ArrayList;

import net.roozy.airdroid.net.AirplayDevice;
import net.roozy.airdroid.net.AirplayManager;
import net.roozy.airdroid.net.AirplayManagerDelegate;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends ListActivity implements AirplayManagerDelegate
{
    private AirplayManager airplayManager;
    private ArrayList<AirplayDevice> listedDevices;
    
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        
        airplayManager = AirplayManager.getInstance(this, this);
        airplayManager.searchForDevices();
        
        Toast.makeText(this, "Searching for devices.", Toast.LENGTH_SHORT).show();
    }
    
    @Override
    public void onStop()
    {
    	//airplayManager.dispose();
    	//airplayManager = null;
    	
    	super.onStop();
    }
    
    /*
     * Airplay Manager Delegate
     */
    public void airplayManagerFoundDevices(ArrayList<AirplayDevice> devices)
    {
    	listedDevices = devices;
    	
    	String names[] = new String[devices.size()];
    	for(int i=0; i < devices.size(); i++)
    	{
    		names[i] = devices.get(i).name;
    	}
    	
    	this.setListAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, names));
    }
    
    public void airplayManagerConnectedDevice()
    {
    	
    }
    
    @Override
    protected void onListItemClick(ListView l, View v, int position, long id)
    {
    	super.onListItemClick(l, v, position, id);
    	
    	AirplayDevice device = listedDevices.get(position);
    	
    	Intent detailIntent = new Intent(this, DeviceDetailActivity.class);
    	detailIntent.putExtra("device", device);
    	startActivity(detailIntent);
    }
}