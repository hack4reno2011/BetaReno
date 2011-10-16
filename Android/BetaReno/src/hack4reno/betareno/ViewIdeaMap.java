package hack4reno.betareno;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import hack4reno.betareno.CustomBalloonDrawer.OnBalloonTapListener;
import hack4reno.betareno.CustomMapView.OnPanAndZoomListener;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.OverlayItem;

public class ViewIdeaMap extends MapActivity
{
	ViewIdeaMap viewMap;
	CustomMapView mapView;
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.viewideamap);
		viewMap = this;		
		
		mapView = (CustomMapView) findViewById(R.id.mapView);
		mapView.setOnPanListener(new OnPanAndZoomListener()
		{	
			Double currentMileSpan;
			GeoPoint currentCenter;
			
			public void onPan()
			{
				currentCenter = getMapCenter();
				currentMileSpan = getMapSpanMiles();					
				getIdeas(currentCenter, currentMileSpan);					
			}
			
			public void onZoom()
			{
				currentCenter = getMapCenter();
				currentMileSpan = getMapSpanMiles();				
				getIdeas(currentCenter, currentMileSpan);					
			}
			
		});		
	
	}
	
	private void getIdeas(GeoPoint currentCenter, Double currentMileSpan)
	{
		String latitude = String.valueOf(Double.parseDouble(String.valueOf(currentCenter.getLatitudeE6())) / 1E6);
		String longitude = String.valueOf(Double.parseDouble(String.valueOf(currentCenter.getLongitudeE6())) / 1E6);
		String mileSpan = String.valueOf(currentMileSpan);		
		String url = "http://betareno.cyberhobo.net/wp-admin/admin-ajax.php?action=betareno-get-ideas&lat=" + latitude + "&lng=" + longitude + "&r=" + mileSpan;
		new GetIdeas().execute(url);
	}	
	
	private GeoPoint getMapCenter()
	{		
		GeoPoint xCenter = mapView.getProjection().fromPixels(mapView.getWidth()/2, 0);
		GeoPoint yCenter = mapView.getProjection().fromPixels(0, mapView.getHeight()/2);		
		return new GeoPoint(xCenter.getLatitudeE6(), yCenter.getLongitudeE6());
	}
	
	private double getMapSpanMiles()
	{		
		double miles;
		
		GeoPoint bottomLeft = mapView.getProjection().fromPixels(0, 0);
		GeoPoint upperRight = mapView.getProjection().fromPixels(mapView.getWidth(), mapView.getHeight());

		float[] results = new float[1];
		Location.distanceBetween(((double)bottomLeft.getLatitudeE6())/1E6, ((double)bottomLeft.getLongitudeE6())/1E6, ((double)upperRight.getLatitudeE6())/1E6, ((double)upperRight.getLongitudeE6())/1E6, results);
		miles = results[0] * 0.000621371192;		
		return miles;		
	}
	
	private class GetIdeas extends AsyncTask<String, Integer, ArrayList<Idea>>
	{
		URL url;
		
		String responseString = "";
		String code,message;
		JSONArray jsonIdeas;
		ArrayList<Idea> ideas = new ArrayList<Idea>();
		
		// ProgressDialog pd;

		public GetIdeas()
		{
	
		}
	
		@Override
		protected void onPreExecute()
		{
			// TODO actionBar.setProgressBarVisibility(View.VISIBLE);
			// pd = ProgressDialog.show(market, "", "Finding Rides...");
			// pd.show();
		}
	
		@Override
		protected ArrayList<Idea> doInBackground(String... uri)
		{			
			try
			{
				url = new URL(uri[0]);
				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
				connection.setRequestMethod("GET");
				connection.setDoOutput(true);
				connection.setDoInput(true);
				connection.connect();
	
				responseString = HelperFunctions.parseString(connection.getInputStream());
				JSONObject jsonObject = new JSONObject(responseString);

				// code = (String) jsonObject.get("code");
				// if the code wasn't 200, throw an exception
				//if (code.equals("200"))
				//	throw new Exception();
				
				jsonIdeas = jsonObject.getJSONArray("ideas");
				
				// Get all ideas and put them in an arraylist
				for (int i = 0; i < jsonIdeas.length(); i++)				
					ideas.add(new Idea( (JSONObject) jsonIdeas.get(i)));
				
				return ideas;
						
			} 
			
			catch (Exception e)
			{
				System.out.println(e);
				return null;
			}
		}
	
		@Override
		protected void onProgressUpdate(Integer... progress)
		{
		}
	
		@Override
		protected void onPostExecute(ArrayList<Idea> ideas)
		{
			if (ideas == null)
			{	
				new AlertDialog.Builder(viewMap)
						.setMessage("A network error has occured.  Would you like to try again?")
						.setTitle("Network Error").setPositiveButton("Retry", new DialogInterface.OnClickListener()
						{
							public void onClick(DialogInterface dialog, int which)
							{
								// pd.dismiss();
								// actionBar.setProgressBarVisibility(View.INVISIBLE);
								new GetIdeas().execute(url.toString());
							}
							
						}
	
						).setNegativeButton("Cancel", new DialogInterface.OnClickListener()
						{
							public void onClick(DialogInterface dialog, int which)
							{
								// actionBar.setProgressBarVisibility(View.INVISIBLE);
							}
						}).show();
			}
	
			// Store the name of the image
			else
			{
				drawIdeaMap(ideas);
			}
			// actionBar.setProgressBarVisibility(View.INVISIBLE);
	}
}

	private void drawIdeaMap(final ArrayList<Idea> ideas)
	{
		// TODO - change the point logo
		Drawable startMarker = getResources().getDrawable(R.drawable.point);
		startMarker.setBounds(0, 0, startMarker.getIntrinsicWidth(), startMarker.getIntrinsicHeight());
		CustomBalloonDrawer bubbleDrawer = new CustomBalloonDrawer(startMarker, mapView);
		// SampleBalloonItemizedOverlay bubbleDrawer = new SampleBalloonItemizedOverlay(startMarker, mapView);
		
		// Clear Current Markers
		if (!mapView.getOverlays().isEmpty())
			mapView.getOverlays().clear();
		
		// Draw markers
		for (int i = 0; i < ideas.size(); i++)
		{
			int lat = ((int)(Double.parseDouble(ideas.get(i).getLatitude())*1E6));
			int lon = ((int)(Double.parseDouble(ideas.get(i).getLongitude())*1E6));
			String name = ideas.get(i).getWhat();
			StringBuilder info = new StringBuilder();
			info.append("Who should do this:" + ideas.get(i).getWho());
			// TODO - make human readable date
			if (!ideas.get(i).getWhen().equals(""))
				info.append("Date: " + ideas.get(i).getWhen());			
			GeoPoint point = new GeoPoint(lat, lon);
			OverlayItem overlayItem = new OverlayItem(point, name, info.toString());
			bubbleDrawer.addOverlay(overlayItem);			
		
			mapView.getOverlays().add(bubbleDrawer);
		}	
		
		// Set listener
		
		bubbleDrawer.setOnBaloonListener(new OnBalloonTapListener()
		{

			public void onBalloonTap(int index, OverlayItem item) 
			{
				
				String url = "http://betareno.cyberhobo.net/?p=" + ideas.get(index).getID();
				Intent i = new Intent(Intent.ACTION_VIEW);
				i.setData(Uri.parse(url));
				startActivity(i);				
				
			}		
		});		
	}

	@Override
	protected boolean isRouteDisplayed() 
	{
		// TODO Auto-generated method stub
		return false;
	}

}
