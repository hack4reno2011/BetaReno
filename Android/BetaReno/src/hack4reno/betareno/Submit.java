package hack4reno.betareno;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;

public class Submit extends Activity 
{
	protected Submit submit;
	
	protected EditText editWhat, editWhere;
	protected Spinner spinWho;
	protected ArrayAdapter<String> spinAdapter;
	protected Button btnPic;	
	protected CheckBox chkPlan;
	protected DatePicker datePlan;
	
	// Index for case statement when listening for photo picture intent to resolve
	protected static final int REQ_CODE_PICK_IMAGE = 1;
	
	// The reference to the image the user selected
	protected String m_userSelectedImagePath = "";
	

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
    }
    
    // After the user selects a picture from the galery, this function fires
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
}
