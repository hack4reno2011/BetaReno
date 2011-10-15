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
	protected Button btnCreate;
	protected Button btnUpdate;
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
				Intent submit;
				submit = new Intent(context, Submit.class);
				context.startActivity(submit);			
			}        	
        });
        
    }
}