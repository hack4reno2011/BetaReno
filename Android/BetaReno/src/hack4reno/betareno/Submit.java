package hack4reno.betareno;

import java.io.File;
import java.util.ArrayList;

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

import com.google.android.maps.GeoPoint;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ListView;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;

public class Submit extends Activity 
{
	protected Submit submit;
	
	protected EditText editWhat, editWhere;
	protected Spinner spinWho;
	protected ArrayAdapter<String> spinAdapter;
	protected Button btnPic, btnSubmit;	
	protected CheckBox chkPlan;
	protected DatePicker datePlan;
	
	// Index for case statement when listening for photo picture intent to resolve
	protected static final int REQ_CODE_PICK_IMAGE = 1;
	
	// The reference to the image the user selected
	protected String m_userSelectedImagePath = "";
	
	// Geolocation stuff
	protected GeoPoint addressLocation = null;
	

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
					// Get geolocation of address.  This function will launch a listview that the user selects and picks an address
					addressLocation = getLocation(editWhere.getText().toString());
					
					System.out.println("Hello world");
				}
				
				
				
			}			
		});		
    }
    
    private GeoPoint getLocation(String address)
    {
    	// This function is going to launch a listview dialog box which will allow the user to select an google approved address
    	// given the address that they entered.  
    	
    	// Used to store and sort possible start locations of the user
    	ArrayAdapter<String> startAddressListAdapter;
    	ArrayList<String> startAddressList;
    	ArrayList<SuggestionPoint> dataStartAddressList;
    	Dialog dialogStartAddressSuggestions = new Dialog(this);
    	ListView lstStartSuggestions;
    	
    	
    	
    	
		return null;    	
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
    private class HttpMultipartPost extends AsyncTask<HttpResponse, Integer, Idea>
	{
		ProgressDialog pd;
		long totalSize;
		
		HttpMultipartPost()
		{
			
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
			HttpPost httpPost = new HttpPost("http://blahblhablha.php");

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
				multipartContent.addPart("what", new StringBody(editWhat.getText().toString()));
				multipartContent.addPart("who", new StringBody(spinWho.getSelectedItem().toString()));
				multipartContent.addPart("latitude", new StringBody(editWhat.getText().toString()));
				multipartContent.addPart("what", new StringBody(editWhat.getText().toString()));
				multipartContent.addPart("what", new StringBody(editWhat.getText().toString()));
				multipartContent.addPart("uploaded_file", new FileBody(new File(m_userSelectedImagePath)));
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
		protected void onPostExecute(Idea idea)
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
								new HttpMultipartPost().execute();
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
