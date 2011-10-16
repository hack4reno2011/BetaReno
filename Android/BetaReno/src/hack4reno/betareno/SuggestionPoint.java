package hack4reno.betareno;

import com.google.android.maps.GeoPoint;

/*
 * Represents a suggestion point that is in the list
 */
public class SuggestionPoint
{
	String name = null;
	String address = null;
	GeoPoint point = null;
	
	SuggestionPoint(String name, String address, GeoPoint point)
	{
		this.name = name;
		this.address = address;
		this.point = point;
	}
	
	SuggestionPoint(String name, GeoPoint point)
	{
		this.name = name;		
		this.point = point;
	}
	
	SuggestionPoint()
	{
		
	}
	
	public String getFullName()
	{
		if (name != null && address != null)
			return name + " " + address;
		else if (address == null)
			return name;
		else
			return "";
		
			
	}
	
	public String getName()
	{
		return name;
	}
	
	public void setName(String s)
	{
		this.name = s;
	}
	
	public String getAddress()
	{
		return address;		
	}
	
	public void setAddress(String s)
	{
		this.address = s;
	}
	
	public GeoPoint getPoint()
	{
		return point;
	}
	
	public void setPoint(GeoPoint p)
	{
		this.point = p;
	}

}
