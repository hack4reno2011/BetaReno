package hack4reno.betareno;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class Main extends Activity 
{
	protected Button btnCreate, btnView;
	protected Context context;
	
	
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        context = this;
        
        btnCreate = (Button) findViewById(R.id.home_btn_create);
        btnCreate.setOnClickListener(new OnClickListener()
        {
			public void onClick(View v) 
			{
				Intent submit = new Intent(context, SubmitRide.class);
				context.startActivity(submit);			
			}        	
        });
        
        btnView = (Button) findViewById(R.id.home_btn_view);
        btnView.setOnClickListener(new OnClickListener()
        {
        	public void onClick(View v)
        	{
        		Intent view = new Intent(context, ViewIdea.class);
        		context.startActivity(view);
        	}
        });
        
    }
}