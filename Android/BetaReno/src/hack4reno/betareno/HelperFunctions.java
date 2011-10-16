package hack4reno.betareno;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;

import com.google.android.maps.GeoPoint;

import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.widget.Toast;

public class HelperFunctions 
{
	private HelperFunctions()
	{};
	
	static public void say(Context context, String text)
	{
		Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
	}
	
	public static String parseString(InputStream is)
	{

		/*
		 * To convert the InputStream to String we use the Reader.read(char[]
		 * buffer) method. We iterate until the Reader return -1 which means
		 * there's no more data to read. We use the StringWriter class to
		 * produce the string.
		 */
		if (is != null)
		{
			Writer writer = new StringWriter();
			char[] buffer = new char[1024];
			try
			{

				Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
				int n;
				while ((n = reader.read(buffer)) != -1)
				{
					writer.write(buffer, 0, n);
				}
			}

			catch (Exception e)
			{

			}

			finally
			{
				try
				{
					is.close();
				}

				catch (IOException e)
				{
					e.printStackTrace();
				}
			}
			return writer.toString();
		} else
			return null;
	}
	
	public static GeoPoint getLastKnownLocation(Context context)
	{
		LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
		Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
		if (lastKnownLocation != null)
			return new GeoPoint((int) (lastKnownLocation.getLatitude() * 1000000), (int) (lastKnownLocation.getLongitude() * 1000000));
		else
			return null;
	}
	
	public static String latitude1e6toString(GeoPoint point)
	{
		return String.valueOf(Double.parseDouble(String.valueOf(point.getLatitudeE6())) / 1E6);
	}
	
	public static String longitude1e6toString(GeoPoint point)
	{
		return String.valueOf(Double.parseDouble(String.valueOf(point.getLongitudeE6())) / 1E6);
	}
	
	

}
