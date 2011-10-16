package hack4reno.betareno;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import com.google.android.maps.GeoPoint;

import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class ViewIdeaList extends ListActivity 
{	
	ViewIdeaList viewIdeaList;
	GeoPoint currentLocation;
	
	ListView listView;
	
	ArrayList<String> ideaStrings = new ArrayList<String>();
	ArrayList<Idea> ideas = new ArrayList<Idea>();
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		// setContentView(R.layout.viewidealist);
		viewIdeaList = this;
		
		listView = getListView();
		
		listView.setOnItemClickListener(new OnItemClickListener() 
		{

			public void onItemClick(AdapterView<?> v, View view, int pos,
					long id) 
			{
				String url = "http://betareno.cyberhobo.net/?p=" + ideas.get(pos).getID();
				Intent i = new Intent(Intent.ACTION_VIEW);
				i.setData(Uri.parse(url));
				startActivity(i);				
			}
		});
		 
		
		currentLocation = HelperFunctions.getLastKnownLocation(viewIdeaList);
		
		// Get the data
		if (currentLocation != null)
			new GetIdeas().execute("http://betareno.cyberhobo.net/wp-admin/admin-ajax.php?action=betareno-get-ideas&lat=" + HelperFunctions.latitude1e6toString(currentLocation) + "&lon=" + HelperFunctions.longitude1e6toString(currentLocation));
		else
			HelperFunctions.say(viewIdeaList, "Unable to determine your location!");
	}	
	
	private class GetIdeas extends AsyncTask<String, Integer, ArrayList<String>>
	{

		URL url;
		String responseString = "";
		String code, message;
		JSONArray jsonIdeas;

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
		protected ArrayList<String> doInBackground(String... uri) 
		{
			try {
				url = new URL(uri[0]);
				HttpURLConnection connection = (HttpURLConnection) url
						.openConnection();
				connection.setRequestMethod("GET");
				connection.setDoOutput(true);
				connection.setDoInput(true);
				connection.connect();

				responseString = HelperFunctions.parseString(connection
						.getInputStream());
				JSONObject jsonObject = new JSONObject(responseString);

				// code = (String) jsonObject.get("code");
				// if the code wasn't 200, throw an exception
				// if (code.equals("200"))
				// throw new Exception();

				jsonIdeas = jsonObject.getJSONArray("ideas");

				// Get all ideas and put them in an string arraylist.  I am lazy and want to just use a String arraylist so that I can use simpleadapter
				for (int i = 0; i < jsonIdeas.length(); i++)
				{
					ideas.add(new Idea(jsonIdeas.getJSONObject(i)));
					ideaStrings.add(new Idea(jsonIdeas.getJSONObject(i)).getWhat() + "\n" + new Idea(jsonIdeas.getJSONObject(i)).getWho());
				}

				return ideaStrings;

			}

			catch (Exception e) {
				System.out.println(e);
				return null;
			}
		}

		@Override
		protected void onProgressUpdate(Integer... progress) {
		}

		@Override
		protected void onPostExecute(ArrayList<String> ideas) {
			if (ideas == null) {
				new AlertDialog.Builder(viewIdeaList)
						.setMessage(
								"A network error has occured.  Would you like to try again?")
						.setTitle("Network Error")
						.setPositiveButton("Retry",
								new DialogInterface.OnClickListener() {
									public void onClick(DialogInterface dialog,
											int which) {
										// pd.dismiss();
										// actionBar.setProgressBarVisibility(View.INVISIBLE);
										new GetIdeas().execute(url.toString());
									}

								}

						)
						.setNegativeButton("Cancel",
								new DialogInterface.OnClickListener() {
									public void onClick(DialogInterface dialog,
											int which) {
										// actionBar.setProgressBarVisibility(View.INVISIBLE);
									}
								}).show();
			}

			// Store the name of the image
			else
			{
				viewIdeaList.setListAdapter(new ArrayAdapter<String>(viewIdeaList, android.R.layout.simple_list_item_1, ideas));
			}
			// actionBar.setProgressBarVisibility(View.INVISIBLE);
		}
		}
		
	}


