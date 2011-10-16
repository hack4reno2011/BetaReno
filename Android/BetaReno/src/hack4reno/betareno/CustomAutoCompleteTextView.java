package hack4reno.betareno;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;

public class CustomAutoCompleteTextView extends AutoCompleteTextView
{

	private static final String PREF_BOXES = "Pref_Boxes";
	Context context;

	SharedPreferences pref_box;
	String sharedPreferencesStringKey;
	String data;
	String[] arrayData;
	ArrayAdapter<String> adapterData;

	public CustomAutoCompleteTextView(Context context)
	{
		super(context);
		this.context = context;
		// Weird bug where all text is white - this changes it to black.
		this.setTextColor(Color.BLACK);
	}
	
	public CustomAutoCompleteTextView(Context context, AttributeSet attrs)
	{
		super(context, attrs);
		this.context = context;
		// Weird bug where all text is white - this changes it to black.
		this.setTextColor(Color.BLACK);
	}

	public CustomAutoCompleteTextView(Context context, AttributeSet attrs, int defStyle)
	{
		super(context, attrs, defStyle);
		this.context = context;
		// Weird bug where all text is white - this changes it to black.
		this.setTextColor(Color.BLACK);
	}
	
	public void setSharedPreferenceKey(String s)
	{		
		sharedPreferencesStringKey = s;
		initializeSharedPreferences();
	}
	
	public void recordTextboxData()
	{
		updateSuggestionData();
	}

	@Override
	protected void onFocusChanged(boolean gainFocus, int direction, Rect previouslyFocusedRect)
	{
		 super.onFocusChanged(gainFocus, direction, previouslyFocusedRect);
		if (gainFocus == false)
		{
			updateSuggestionData();
		}
	}

	private void initializeSharedPreferences()
	{
		try
		{
			pref_box = context.getSharedPreferences(PREF_BOXES, 0);
			data = pref_box.getString(sharedPreferencesStringKey, "");
			arrayData = data.split(",,,,,");
			adapterData = new ArrayAdapter<String>(context, android.R.layout.simple_dropdown_item_1line, arrayData);
			this.setAdapter(adapterData);
		} 
		
		catch (Exception e)
		{
			System.out.println(e);
		}
	}

	private void updateSuggestionData()
	{
		boolean noDuplicates = true;
		try
		{
			for (int i = 0; i < arrayData.length; i++)
			{
				if (arrayData[i].equals(this.getText().toString()))
				{
					noDuplicates = false;
				}
			}

			if (noDuplicates)
			{
				data = data + ",,,,," + this.getText().toString();
				SharedPreferences.Editor editor = pref_box.edit();
				editor.putString(sharedPreferencesStringKey, data);
				editor.commit();
				adapterData.notifyDataSetChanged();
			}
		}

		catch (Exception e)
		{
			System.out.println(e);
		}
	}

}
