package hack4reno.betareno;

import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TabHost.TabSpec;

public class ViewIdea  extends TabActivity
{
	ViewIdea view;
	TabSpec tabSpec;
	
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.viewidea);
		view = this;
		
		
		// Create tabs for tabhost
		Intent list = new Intent(view, ViewIdeaList.class);
		tabSpec = getTabHost().newTabSpec("list").setIndicator("List", getResources().getDrawable(R.drawable.list)).setContent(list);
		getTabHost().addTab(tabSpec);
		
		Intent map = new Intent(view, ViewIdeaMap.class);
		tabSpec = getTabHost().newTabSpec("map").setIndicator("Map", getResources().getDrawable(R.drawable.map)).setContent(map);
		getTabHost().addTab(tabSpec);
		
		
	}

}
