package hack4reno.betareno;

import org.json.JSONException;
import org.json.JSONObject;

import android.widget.DatePicker;
import android.widget.TimePicker;

public class Idea 
{
	private String ID;
	private String what;
	private String who;
	private String latitude;
	private String longitude;
	private String when;
	private String votes;
	private String before_photo;
	private String after_photo;
	
	Idea()
	{
		this.ID = "";
		this.what = "";
		this.who = "";
		this.latitude = "";
		this.longitude = "";
		this.when = "";
		this.votes = "";
		this.before_photo= "";
		this.after_photo = "";		
	}
	
	Idea (JSONObject jsonObject) throws JSONException
	{		
		this.ID = (String) jsonObject.get("ID");
		this.what = (String) jsonObject.get("what");
		this.who = (String) jsonObject.get("who");
		this.latitude = (String) jsonObject.get("latitude");
		this.longitude = (String) jsonObject.get("longitude");
		this.when = (String) jsonObject.get("when");
		this.votes = String.valueOf((Integer) jsonObject.get("votes"));
		this.before_photo = (String) jsonObject.get("before_photo_url");
		this.after_photo = (String) jsonObject.get("after_photo_url");		
	}

	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getWhat() {
		return what;
	}

	public void setWhat(String what) {
		this.what = what;
	}

	public String getWho() {
		return who;
	}

	public void setWho(String who) {
		this.who = who;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getWhen() {
		return when;
	}

	public void setWhen(String when) {
		this.when = when;
	}
	
	public void setWhen(DatePicker datePlan, TimePicker timePlan)
	{
		this.when = datePlan.getYear() + "-" + datePlan.getMonth() + "-" + datePlan.getDayOfMonth() + " " + timePlan.getCurrentHour() + ":" + timePlan.getCurrentMinute() + ":00 PDT";
	}

	public String getVotes() {
		return votes;
	}

	public void setVotes(String votes) {
		this.votes = votes;
	}

	public String getBefore_photo() {
		return before_photo;
	}

	public void setBefore_photo(String before_photo) {
		this.before_photo = before_photo;
	}

	public String getAfter_photo() {
		return after_photo;
	}

	public void setAfter_photo(String after_photo) {
		this.after_photo = after_photo;
	}
	
	

}
