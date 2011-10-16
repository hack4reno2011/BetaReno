package hack4reno.betareno;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.view.MotionEvent;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;



public class CustomMapView extends MapView
{

	private int oldZoomLevel = -1;
	private GeoPoint oldCenterGeoPoint;
	private OnPanAndZoomListener mListener;	
	
    // Set this variable to your preferred timeout
	// private long events_timeout = 500L;
	// private Timer zoom_event_delay_timer = new Timer();
	// private Timer pan_event_delay_timer = new Timer();

	public interface OnPanAndZoomListener
	{
		public void onPan();

		public void onZoom();
	}

	public CustomMapView(Context context, String apiKey)
	{
		super(context, apiKey);
	}

	public CustomMapView(Context context, AttributeSet attrs)
	{
		super(context, attrs);
	}

	public CustomMapView(Context context, AttributeSet attrs, int defStyle)
	{
		super(context, attrs, defStyle);
	}

	public void setOnPanListener(OnPanAndZoomListener listener)
	{
		mListener = listener;
	}

	@Override
	public boolean onTouchEvent(MotionEvent ev)
	{
		if (ev.getAction() == MotionEvent.ACTION_UP)
		{
			GeoPoint centerGeoPoint = this.getMapCenter();
			if (oldCenterGeoPoint == null || (oldCenterGeoPoint.getLatitudeE6() != centerGeoPoint.getLatitudeE6())
					|| (oldCenterGeoPoint.getLongitudeE6() != centerGeoPoint.getLongitudeE6()))
			{
			
				/*
		       pan_event_delay_timer.cancel();
		       pan_event_delay_timer = new Timer();
		       pan_event_delay_timer.schedule(new TimerTask() {

					@Override
					public void run()
					{
						mListener.onPan();						
					}
		        	
		        }, events_timeout);
		        */
				mListener.onPan();
				oldCenterGeoPoint = this.getMapCenter();
				
			}
			// 
			
		}
		return super.onTouchEvent(ev);
	}

	@Override
	protected void dispatchDraw(Canvas canvas)
	{
		super.dispatchDraw(canvas);
		if (getZoomLevel() != oldZoomLevel)
		{
			/*
	        zoom_event_delay_timer.cancel();
	        zoom_event_delay_timer = new Timer();
	        zoom_event_delay_timer.schedule(new TimerTask() {

				@Override
				public void run()
				{
					mListener.onZoom();					
				}
	        	
	        }, events_timeout);
	        */
			
			mListener.onZoom();
			oldZoomLevel = getZoomLevel();
		}
	}

}
