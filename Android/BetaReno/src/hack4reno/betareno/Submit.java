package hack4reno.betareno;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

public class Submit extends Activity 
{
	EditText editWhat, editWhere ;
	Button btnUpdate;
	Submit submit;
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.submit);
        submit = this;
        
        /*btnCreate = (Button) findViewById(R.id.home_btn_create);
       //btnCreate.setOnClickListener(new OnClickListener()
        {
			public void onClick(View v) 
			{
				// Intent intent = new Intent(main, MyClassHere.class);
				// intent.putExtra("MyExtraVariable", "Hello");
				// main.startActivity(intent);			
			}        	
        });*/
    }
}
