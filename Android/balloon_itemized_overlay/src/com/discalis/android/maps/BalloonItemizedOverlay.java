package com.discalis.android.maps;

import java.util.List;

import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

/**
 * {@link ItemizedOverlay} which draws balloons over POIs at a {@link MapView}.
 * 
 * @author isaac.salgueiro@discalis.com (based on Jeff Gilfelt's
 *         BalloonItemizedOverlay)
 */
public abstract class BalloonItemizedOverlay<Item> extends ItemizedOverlay<OverlayItem> {

	private final static String TAG = "Discalis BIO";

	protected final MapView mapView;
	protected BalloonLayout balloonView;
	protected View clickRegion;
	protected final int balloonViewOffset;

	/**
	 * Get a new instance.
	 * 
	 * @param defaultMarker
	 *            Default drawable that will be drawn for each
	 *            {@link OverlayItem}. <b>Rmember to set bounds with something
	 *            like boundCenterBottom</b>
	 * @param mapView
	 */
	public BalloonItemizedOverlay(Drawable defaultMarker, MapView mapView) {
		super(defaultMarker);
		this.mapView = mapView;
		balloonViewOffset = defaultMarker.getIntrinsicHeight();
		populate();
	}

	/**
	 * Override this method to execute code when the user taps a balloon.
	 * 
	 * @param index
	 *            {@link OverlayItem} which balloon was tapped
	 * @return true, we're not propagating the event.
	 */
	protected boolean onBalloonTap(int index) {
		Log.d(TAG, "onBalloonTap not catched!");
		return true;
	}

	/**
	 * 
	 * @see ItemizedOverlay#onTap(GeoPoint, MapView)
	 */
	@Override
	protected final boolean onTap(int index) {

		boolean isRecycled = true;
		final int thisIndex = index;
		final GeoPoint point = createItem(index).getPoint();

		if (balloonView == null) {
			Log.d(TAG, "New balloonView");
			balloonView = new BalloonLayout(mapView.getContext(), balloonViewOffset);
			clickRegion = (View) balloonView.findViewById(R.id.balloon_inner_layout);
			isRecycled = false;
		}

		balloonView.setVisibility(View.GONE);

		if (mapView.getOverlays().size() > 1) {
			Log.d(TAG, "Hidding balloons from other overlays");
			final List<Overlay> overlays = mapView.getOverlays();
			for (Overlay overlay : overlays) {
				if ((overlay != this) && (overlay instanceof BalloonItemizedOverlay<?>)) {
					((BalloonItemizedOverlay<?>) overlay).hideBalloon();
				}
			}
		}

		balloonView.setText(createItem(index).getTitle());

		MapView.LayoutParams params = new MapView.LayoutParams(LayoutParams.WRAP_CONTENT,
				LayoutParams.WRAP_CONTENT, point, MapView.LayoutParams.BOTTOM_CENTER);
		params.mode = MapView.LayoutParams.MODE_MAP;

		clickRegion.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View arg0, MotionEvent arg1) {
				if (arg1.getAction() == MotionEvent.ACTION_UP) {
					return onBalloonTap(thisIndex);
				}
				return true;
			}
		});

		balloonView.setVisibility(View.VISIBLE);

		if (isRecycled) {
			balloonView.setLayoutParams(params);
		} else {
			mapView.addView(balloonView, params);
		}

		// TODO config parameter to determine wether we center the map or not
		mapView.getController().animateTo(point);

		return true;
	}

	/**
	 * Call this method to hide the current viewed balloon. It's safe to call
	 * this method even if no balloon is currently shown in the MapView.
	 * 
	 * @return <code>true</code> if it were a balloon visible.
	 */
	public boolean hideBalloon() {
		if ((balloonView != null) && (balloonView.getVisibility() != View.GONE)) {
			Log.d(TAG, "Hidding balloon");
			balloonView.setVisibility(View.GONE);
			return true;
		}
		return false;
	}
}