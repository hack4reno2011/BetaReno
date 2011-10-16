package hack4reno.betareno;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import hack4reno.betareno.CustomMultipartEntity.ProgressListener;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.google.android.maps.GeoPoint;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TimePicker;

public class Submit extends Activity 
{
	protected Submit submit;
	
	protected EditText editWhat, editWhere;
	protected Spinner spinWho;
	protected ArrayAdapter<String> spinAdapter;
	protected Button btnPic, btnSubmit;	
	protected CheckBox chkPlan;
	protected DatePicker datePlan;
	protected TimePicker timePlan;
	
	// Index for case statement when listening for photo picture intent to resolve
	protected static final int REQ_CODE_PICK_IMAGE = 1;
	
	// The reference to the image the user selected
	protected String m_userSelectedImagePath = "";
	
	// Geolocation stuff
	protected GeoPoint addressLocation = null;
	
	// TODO - This crap needs to be a local variable in getLocation() ...guhhhh
	public GeoPoint approximateLocationPoint, exactLocationPoint;
	

    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.submit);
        submit = this;
        
        // Get object references
        editWhat = (EditText) findViewById(R.id.editWhat);
        editWhere = (EditText) findViewById(R.id.editWhere);
        spinWho = (Spinner) findViewById(R.id.spinWho);
        btnPic = (Button) findViewById(R.id.btnPic);
        chkPlan = (CheckBox) findViewById(R.id.chkPlan);
        datePlan = (DatePicker) findViewById(R.id.datePlan);
        timePlan = (TimePicker) findViewById(R.id.timePlan);
        btnSubmit = (Button) findViewById(R.id.btnSubmit);
        
        // Populate spinner         
		spinAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, getResources().getStringArray(R.array.submit_spin_categories));
		spinWho.setAdapter(spinAdapter);
        
        // Instantiate listeners
		btnPic.setOnClickListener(new OnClickListener()
		{
			public void onClick(View v) 
			{
				Intent i = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.INTERNAL_CONTENT_URI);
				startActivityForResult(i, REQ_CODE_PICK_IMAGE);				
			}
			
		});
		
		chkPlan.setOnCheckedChangeListener(new OnCheckedChangeListener()
		{
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) 
			{
				if (isChecked)
					datePlan.setVisibility(1);
				else
					datePlan.setVisibility(0);
			}			
		});		
		
		btnSubmit.setOnClickListener(new OnClickListener()
		{
			public void onClick(View v) 
			{
				// Validate input before upload
				if (editWhat.getText().toString().equals(""))				
					HelperFunctions.say(submit, getString(R.string.submit_error_what));
				else if (editWhere.getText().toString().equals(""))				
					HelperFunctions.say(submit, getString(R.string.submit_error_where));			
				// Begin upload
				else
				{	
					// Get geolocation of address.  This function will launch a listview that the user selects and picks an address, it will then set "exactLocationPoint"
					// This does not stop as it is threaded.  It then 
					setLocationAndUpload(editWhere.getText().toString());							
				}			
			}			
		});		
    }
    
    private void setLocationAndUpload(String address)
    {
    	// This function is going to launch a listview dialog box which will allow the user to select an google approved address
    	// given the address that they entered.  
    	
    	// Used to store and sort possible start locations of the user
    	final ArrayList<String> startAddressList = new ArrayList<String>();
    	final ArrayAdapter<String> startAddressListAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, startAddressList);
    	final ArrayList<SuggestionPoint> dataStartAddressList = new ArrayList<SuggestionPoint>();
    	final Dialog dialogStartAddressSuggestions = new Dialog(submit);
    	dialogStartAddressSuggestions.setContentView(R.layout.dialogsuggestion);
    	final ListView lstStartSuggestions = (ListView) dialogStartAddressSuggestions.findViewById(R.id.lstSuggestion);
    	
    	final Dialog inputDialog;
    	LocationManager locationManager;   	
    	
    	
    	// Create the dialog box
    	inputDialog = new Dialog(submit);
		inputDialog.setContentView(R.layout.dialogsuggestion);
		inputDialog.setTitle("Possible Location Addresses");
		inputDialog.show();
    	
		try
		{
			// We are going to try and get a fix really fast using last known location.  This helps the service find a relevant result given an address
			locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);
			Location lastKnownLocation = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
			approximateLocationPoint = new GeoPoint((int) (lastKnownLocation.getLatitude() * 1000000), (int) (lastKnownLocation.getLongitude() * 1000000));
		}
		
		catch (Exception e)
		{
			System.out.println(e);
		}
    	
    	// This may return null given if the phone was able to get a location point at some point
    	if (approximateLocationPoint != null)
			new GetSuggestions(editWhere.getText().toString(), approximateLocationPoint, dialogStartAddressSuggestions, dataStartAddressList, startAddressList, startAddressListAdapter).execute();
		else
			new GetSuggestions(editWhere.getText().toString(), dialogStartAddressSuggestions, dataStartAddressList, startAddressList, startAddressListAdapter).execute();

    	
		lstStartSuggestions.setAdapter(startAddressListAdapter);    	
    	lstStartSuggestions.setOnItemClickListener(new OnItemClickListener()
		{
			public void onItemClick(AdapterView<?> a, View v, int pos, long id)
			{
				editWhere.setText(lstStartSuggestions.getItemAtPosition(pos).toString());
				// Set the GeoPoints to place on the map!				
				dialogStartAddressSuggestions.dismiss();
				exactLocationPoint = new GeoPoint(dataStartAddressList.get(pos).getPoint().getLatitudeE6(), dataStartAddressList.get(pos).getPoint().getLongitudeE6());
				inputDialog.dismiss();
				
				// Upload TODO
				Idea idea = new Idea();
				idea.setWhat(editWhat.getText().toString());
				idea.setWho(spinWho.getSelectedItem().toString());
				idea.setLatitude(String.valueOf(Double.parseDouble(String.valueOf(exactLocationPoint.getLatitudeE6())) / 1E6));
				idea.setLongitude(String.valueOf(Double.parseDouble(String.valueOf(exactLocationPoint.getLongitudeE6())) / 1E6));
				if (chkPlan.isChecked())
					idea.setWhen(datePlan, timePlan);
				
				
				new UploadIdea(idea).execute();
				
			}
		});	   	
    }
    
    // This function pulls possible locations from google maps
 	private class GetSuggestions extends AsyncTask<String, Integer, String>
 	{
 		GeoPoint currentLoc;
 		String userInput;
 		Dialog dialogStartAddressSuggestions;
 		ArrayList<SuggestionPoint> dataStartAddressList;
 		ArrayList<String> startAddressList;
 		ArrayAdapter<String> startAddressListAdapter;

 		private static final String ELEMENT_NAME = "name";
 		private static final String ELEMENT_ADDRESS = "address";
 		private static final String ELEMENT_PLACEMARK = "Placemark";
 		private static final String ELEMENT_POINT = "Point";
 		private static final String ELEMENT_COORDINATES = "coordinates";

 		ProgressDialog pd;

 		/**
 		 * Used when the user location is unknown
 		 * 
 		 * 
 		 */
 		public GetSuggestions(String input, Dialog dialogStartAddressSuggestions, ArrayList<SuggestionPoint> dataStartAddressList, ArrayList<String> startAddressList, ArrayAdapter<String> startAddressListAdapter)
 		{
 			this.userInput = input;
 			this.dialogStartAddressSuggestions = dialogStartAddressSuggestions;
 			this.dataStartAddressList = dataStartAddressList;
 			this.startAddressList = startAddressList;
 			this.startAddressListAdapter = startAddressListAdapter; 			
 		}

 		/**
 		 * Used when the user location is known
 		 * 
 		 * 
 		 */
 		public GetSuggestions(String input, GeoPoint p, Dialog dialogStartAddressSuggestions, ArrayList<SuggestionPoint> dataStartAddressList, ArrayList<String> startAddressList, ArrayAdapter<String> startAddressListAdapter)
 		{
 			this.userInput = input;
 			this.currentLoc = p;
 			this.dialogStartAddressSuggestions = dialogStartAddressSuggestions;
 			this.dataStartAddressList = dataStartAddressList;
 			this.startAddressList = startAddressList;
 			this.startAddressListAdapter = startAddressListAdapter;
 		}

 		@Override
 		protected void onPreExecute()
 		{
 			pd = ProgressDialog.show(submit, "", "Finding Your Address...");
 			pd.show(); 			
 		}

 		@Override
 		protected String doInBackground(String... input)
 		{
 			// TODO - OnRotate, the currenLoc is not being persisted.
 			String threadStatus = "success";
 			StringBuilder urlString = new StringBuilder();
 			urlString.append("http://maps.google.com/maps?hl=en");
 			// Get a more specific location result based upon the user's current
 			// location from the network pull
 			if (currentLoc != null)
 			{
 				// Latitude,longitude of map centre - Note the order. Only
 				// decimal format is accepted.
 				urlString.append("&sll=" + currentLoc.getLatitudeE6() / 1E6 + "," + currentLoc.getLongitudeE6() / 1E6);
 				// Localizes results to a certain radius. Requires sll or
 				// similar center point to work. Units are in miles, but it may
 				// be in km for metric countries. Useful in preventing Google
 				// from branching out across a city for results, and keeps it
 				// confined into the area.
 				urlString.append("&radius=50");
 				// Query - anything passed in this parameter is treated as if it
 				// had been typed into the query box on the maps.google.com
 				// page. In particular:
 				urlString.append("&q=" + java.net.URLEncoder.encode(userInput));
 				// Display, at most, this number of matches. The valid range is
 				// 0 to 20 (but 0 is a bit pointless).
 				urlString.append("&num=20");
 				// Outputs a KML file containing information representing the
 				// current map. (works with Normal Searches, Directions and
 				// MyMaps)
 				urlString.append("&ie=UTF8&0&om=0&output=kml");
 			}

 			// Gets a more generalized location result
 			else
 			{
 				// Query - anything passed in this parameter is treated as if it
 				// had been typed into the query box on the maps.google.com
 				// page. In particular:
 				urlString.append("&q=" + java.net.URLEncoder.encode(userInput));
 				// Display, at most, this number of matches. The valid range is
 				// 0 to 20 (but 0 is a bit pointless).
 				urlString.append("&num=20");
 				// Outputs a KML file containing information representing the
 				// current map. (works with Normal Searches, Directions and
 				// MyMaps)
 				urlString.append("&ie=UTF8&0&om=0&output=kml");
 			}

 			try
 			{
 				URL url = new URL(urlString.toString());
 				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
 				connection.setRequestMethod("GET");
 				connection.setDoOutput(true);
 				connection.setDoInput(true);
 				connection.connect();
 				parseResponse(connection.getInputStream());
 			}

 			catch (IOException e)
 			{
 				threadStatus = "internetError";
 			}

 			catch (Exception e)
 			{
				threadStatus = "error";
 			}
 			return threadStatus;
 		}

 		@Override
 		protected void onProgressUpdate(Integer... progress)
 		{
 		}

 		@Override
 		protected void onPostExecute(String result)
 		{
 			pd.dismiss();

 			if (result.toString().equals("success"))
 			{
				dialogStartAddressSuggestions.setTitle("Select a Starting Point");
 					dialogStartAddressSuggestions.show();
 			} 

 			
 			else if (result.toString().equals("error"))
 			{
 				new AlertDialog.Builder(submit).setMessage(
 							"Unable to find the provided address.  Please include a more specific adress or location.").setTitle(
 							"Address Lookup Error");
 			}
 
 			else if (result.toString().equals("internetError"))
 			{
 				new AlertDialog.Builder(submit)
 						.setMessage("A network error has occured.  Would you like to try again?")
 						.setTitle("Network Error").setPositiveButton("Retry", new DialogInterface.OnClickListener()
 						{

 							public void onClick(DialogInterface dialog, int which)
 							{
 								if (currentLoc != null)
 									new GetSuggestions(editWhere.getText().toString(), currentLoc, dialogStartAddressSuggestions, dataStartAddressList, startAddressList, startAddressListAdapter).execute();
 								else
 									new GetSuggestions(editWhere.getText().toString(), dialogStartAddressSuggestions, dataStartAddressList, startAddressList, startAddressListAdapter).execute();
 							}
 						}

 						).setNegativeButton("Cancel", new DialogInterface.OnClickListener()
 						{
 							public void onClick(DialogInterface dialog, int which)
 							{
 								// TODO
 								// What happens when the user decides to
 								// not refresh??
 							}
 						}).show();
 			}
 		}

 		// This function takes in a pased xml kml list by placemark tags from
 		// google maps, returns a suggestionPoint object
 		// which includes the name, address, and geopoint of the location
 		// and adds it to the arraylists and notifies the adapter. User will
 		// then pick a point.
 		private void parseResponse(InputStream in)
 		{
 			if (dataStartAddressList != null)
 				dataStartAddressList.clear();
 			if (startAddressList != null)
 				startAddressList.clear();

 			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
 			DocumentBuilder builder;
 			try
 			{
 				builder = factory.newDocumentBuilder();
 				Document document = builder.parse(in);
 				// Get the names and locations
 				NodeList placemarkList = document.getElementsByTagName(ELEMENT_PLACEMARK);

 				for (int i = 0; i < placemarkList.getLength(); i++)
 				{
 					String name = null;
 					String address = null;
 					String GPS = null;
 					NodeList childPlacemarkList = placemarkList.item(i).getChildNodes();
 					for (int j = 0; j < childPlacemarkList.getLength(); j++)
 					{
 						Node node = childPlacemarkList.item(j);
 						if (node.getNodeName().equals(ELEMENT_NAME))
 							name = node.getFirstChild().getNodeValue();
 						else if (node.getNodeName().equals(ELEMENT_ADDRESS))
 							address = node.getFirstChild().getNodeValue();
 						else if (node.getNodeName().equals(ELEMENT_POINT))
 						{
 							NodeList childChildPlacemarkList = node.getChildNodes();
 							for (int k = 0; k < childChildPlacemarkList.getLength(); k++)
 							{
 								Node childNode = childChildPlacemarkList.item(k);
 								if (childNode.getNodeName().equals(ELEMENT_COORDINATES))
 									GPS = childNode.getFirstChild().getNodeValue();
 							}
 						}

 						if (name != null && address != null && GPS != null)
 						{
 							SuggestionPoint point = new SuggestionPoint();
 							String arr[] = GPS.split(",");

 							// sometmies the name and the address are the same
 							if (name.equals(address))
 							{
 								point.setName(name);
 								point.setPoint(new GeoPoint((int) (Double.valueOf(arr[1].trim()) * 1E6), (int) (Double.valueOf(arr[0].trim()) * 1E6)));
								dataStartAddressList.add(point);
								startAddressList.add(point.getFullName());
							} 
 							
 							else
 							{
 								point.setName(name);
 								point.setAddress(address);
 								point.setPoint(new GeoPoint((int) (Double.valueOf(arr[1].trim()) * 1E6), (int) (Double.valueOf(arr[0].trim()) * 1E6)));
								dataStartAddressList.add(point);
 								startAddressList.add(point.getFullName());
 							}
 							
 							break;
 						}
 					}
					startAddressListAdapter.notifyDataSetChanged();
 				}
 			} 
 			
 			catch (Exception e)
 			{
 				e.printStackTrace();
 			}

 		}
 	}
    
    // After the user selects a picture from the gallery, this function fires
    protected void onActivityResult(int requestCode, int resultCode, Intent imageReturnedIntent)
	{
		super.onActivityResult(requestCode, resultCode, imageReturnedIntent);

		switch (requestCode)
		{
		case REQ_CODE_PICK_IMAGE:
			if (resultCode == RESULT_OK)
			{
				Uri selectedImage = imageReturnedIntent.getData();
				String[] filePathColumn = {MediaStore.Images.Media.DATA };

				Cursor cursor = getContentResolver().query(selectedImage, filePathColumn, null, null, null);
				cursor.moveToFirst();

				int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
				String filePath = cursor.getString(columnIndex);
				cursor.close();

				m_userSelectedImagePath = filePath;
			}
		}
	}
    
    /**
     * Given valid member objects, this function will post to the server
     * @author john
     *
     */
    private class UploadIdea extends AsyncTask<HttpResponse, Integer, Idea>
	{
    	Idea idea;
		ProgressDialog pd;
		long totalSize;
		
		UploadIdea(Idea idea)
		{
			this.idea = idea;			
		}
		
		

		@Override
		protected void onPreExecute()
		{
			pd = new ProgressDialog(submit);
			pd.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
			pd.setMessage("Uploading Picture...");
			pd.setCancelable(false);
			pd.show();
		}

		@Override
		protected Idea doInBackground(HttpResponse... arg0)
		{
			HttpClient httpClient = new DefaultHttpClient();
			HttpContext httpContext = new BasicHttpContext();
			HttpPost httpPost = new HttpPost("http://betareno.cyberhobo.net/?action=betareno-add-idea");

			try
			{
				CustomMultipartEntity multipartContent = new CustomMultipartEntity(new ProgressListener()
				{
					public void transferred(long num) 
					{
						publishProgress((int) ((num / (float) totalSize) * 100));						
					}
				});

				// We use string data to transfer normal stuff
				// multipartContent.addPart("type", new StringBody("photo"));

				// We use FileBody to transfer an image
				// multipartContent.addPart("data", new FileBody(new File
				// (m_userSelectedImagePath)));
				multipartContent.addPart("api_key", new StringBody("BetaReno4hack4reno"));
				multipartContent.addPart("what", new StringBody(idea.getWhat()));
				multipartContent.addPart("who", new StringBody(idea.getWho()));
				multipartContent.addPart("latitude", new StringBody(idea.getLatitude()));
				multipartContent.addPart("longitude", new StringBody(idea.getLongitude()));
				multipartContent.addPart("when", new StringBody(idea.getWhen()));
				multipartContent.addPart("before_photo", new FileBody(new File(m_userSelectedImagePath)));
				totalSize = multipartContent.getContentLength();

				// Send the bitch
				httpPost.setEntity(multipartContent);
				HttpResponse response = httpClient.execute(httpPost, httpContext);
				String serverResponse = EntityUtils.toString(response.getEntity());

				// JSON Stuff parsing here - will return the idea listing after post						
				JSONObject jsonObject = new JSONObject(serverResponse);
				return new Idea(jsonObject);
			}

			catch (Exception e)
			{
				System.out.println(e);
			}
			return null;
		}

		@Override
		protected void onProgressUpdate(Integer... progress)
		{
			pd.setProgress((int) (progress[0]));
		}

		@Override
		protected void onPostExecute(final Idea idea)
		{
			// If the parsing failed for whatever reason, try and resubmit the request again.
			if (idea.getID().equals(""))
			{
				setProgressBarIndeterminateVisibility(false);
				new AlertDialog.Builder(submit)
						.setMessage("A network error has occured. Would you like to try again?")
						.setTitle("Network Error").setPositiveButton("Retry", new DialogInterface.OnClickListener()
						{
							public void onClick(DialogInterface dialog, int which)
							{
								pd.dismiss();
								new UploadIdea(idea).execute();
							}
						}

						).setNegativeButton("Cancel", new DialogInterface.OnClickListener()
						{
							public void onClick(DialogInterface dialog, int which)
							{
								pd.dismiss();
							}
						}).show();
			} 
			
			else
			{
				
			}
			
			pd.dismiss();
		}
	}
}
