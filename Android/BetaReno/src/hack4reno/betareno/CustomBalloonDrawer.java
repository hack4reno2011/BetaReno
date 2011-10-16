package hack4reno.betareno;

import java.util.ArrayList;
import java.util.List;

import android.graphics.Canvas;
import android.graphics.drawable.Drawable;

import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

public class CustomBalloonDrawer extends BalloonItemizedOverlay<OverlayItem>
{
	private List<OverlayItem> locations = new ArrayList<OverlayItem>();
	private Drawable marker;
	private OnBalloonTapListener mListener;	

	public interface OnBalloonTapListener
	{
		public void onBalloonTap(int index);
	}

	public CustomBalloonDrawer(Drawable defaultMarker, MapView mapView)
	{
		super(boundCenter(defaultMarker), mapView);
		this.marker = defaultMarker;

	}
	
	public void setOnBaloonListener(OnBalloonTapListener listener)
	{
		mListener = listener;
	}
	
	public void addOverlay(OverlayItem overlay)
	{
		locations.add(overlay);
		populate();
	}

	@Override
	protected OverlayItem createItem(int i)
	{
		// TODO Auto-generated method stub
		return locations.get(i);
	}

	@Override
	public int size()
	{
		// TODO Auto-generated method stub
		return locations.size();
	}

	@Override
	public void draw(Canvas canvas, MapView mapView, boolean shadow)
	{
		// TODO Auto-generated method stub
		super.draw(canvas, mapView, shadow);
		boundCenterBottom(marker);
	}
	
	//TODO - I dont know about this
	/*
	@Override
	protected boolean onBalloonTap(int index, OverlayItem item) 
	{
		mListener.onBalloonTap(index, item);
		return true;
	}
	*/
	
	//TODO - I dont know about this
	@Override
	protected boolean onBalloonTap(int index) 
	{
		mListener.onBalloonTap(index);
		return true;
	}
}
