package net.roozy.airdroid;

import java.util.ArrayList;

import net.roozy.airdroid.net.AirplayDevice;
import net.roozy.airdroid.net.AirplayManager;
import net.roozy.airdroid.net.AirplayManagerDelegate;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class DeviceDetailActivity extends Activity implements AirplayManagerDelegate
{
	private AirplayManager airplayManager;
	private AirplayDevice device;
	
	private TextView nameTextView;
	private Button resolveButton;
	private TextView deviceInfoTextView;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.devicedetail);
		
		Intent extras = getIntent();
		device = (AirplayDevice)extras.getSerializableExtra("device");
		
		airplayManager = AirplayManager.getInstance(this, this);
		
		nameTextView = (TextView) findViewById(R.id.deviceNameTextView);
		nameTextView.setText(device.name);
		
		resolveButton = (Button) findViewById(R.id.resolveButton);
		resolveButton.setOnClickListener(new View.OnClickListener()
		{
			@Override
			public void onClick(View v)
			{
				resolveDevice();
			}
		});
		
		deviceInfoTextView = (TextView) findViewById(R.id.deviceInfoTextView);
	}
	
	private void resolveDevice()
	{
		airplayManager.connectToDevice(device);
	}
	
	public void airplayManagerFoundDevices(ArrayList<AirplayDevice> devices)
	{
		
	}
	
	public void airplayManagerConnectedDevice()
	{
		Toast.makeText(this, "Connected!", Toast.LENGTH_LONG).show();
		
		device = airplayManager.connectedDevice;
		
		resolveButton.setEnabled(false);
		deviceInfoTextView.setText("IP: " + device.address + "\nPort:" + device.port);
	}
}
