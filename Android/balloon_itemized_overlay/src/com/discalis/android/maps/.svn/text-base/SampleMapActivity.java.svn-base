package com.discalis.android.maps;

import android.os.Bundle;
import android.view.KeyEvent;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapView;

/**
 * Sample to show {@link BalloonItemizedOverlay} functionality. Here we're only
 * initializing the {@link MapView}, you'll find more interesting things into
 * {@link SampleBalloonItemizedOverlay} ;)
 * 
 * @author isaac.salgueiro@discalis.com
 * 
 */
public class SampleMapActivity extends MapActivity {

	/**
	 * Need this reference to hide current balloon.
	 * 
	 * @see SampleMapActivity#onKeyDown(int, KeyEvent)
	 */
	private SampleBalloonItemizedOverlay overlay;


	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		final MapView mapView = (MapView) findViewById(R.id.mapView);
		mapView.setBuiltInZoomControls(true);
		mapView.getZoomButtonsController().setAutoDismissed(false);
		mapView.displayZoomControls(true);
		overlay = new SampleBalloonItemizedOverlay(mapView);
		mapView.getOverlays().add(overlay);
		mapView.getController().animateTo(new GeoPoint(42431320, -8642187));
		mapView.getController().setZoom(16);
		mapView.invalidate();
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

	/**
	 * Use something like this to hide current balloon when <i>back</i> key is
	 * pressed.
	 * 
	 * @see MapActivity#onKeyDown(int, KeyEvent)
	 */
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK) && (overlay.hideBalloon())) {
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}
}