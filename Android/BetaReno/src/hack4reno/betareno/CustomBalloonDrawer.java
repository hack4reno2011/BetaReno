package hack4reno.betareno;

import java.util.Collection;
import java.util.ConcurrentModificationException;
import java.util.concurrent.CopyOnWriteArrayList;

import android.app.Activity;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.util.Log;

import com.discalis.android.maps.BalloonItemizedOverlay;
import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;
import com.google.android.maps.OverlayItem;

/**
 * Sample illustrating {@link BalloonItemizedOverlay} use. We are using
 * {@link OverlayItem} to parametrize {@link BalloonItemizedOverlay}, you'll
 * probably want to have some more specific type there, something like
 * MyOwnOverlayItem which extends {@link OverlayItem}.
 * 
 * @author isaac.salgueiro@discalis.com
 * 
 */
public class CustomBalloonDrawer extends BalloonItemizedOverlay<OverlayItem> {

	/**
	 * Overlay constructor. Usually you'll build this overlay with a reference
	 * to a {@link MapView} or an {@link Activity} containing a {@link MapView}.
	 * 
	 * @param resources
	 *            {@link Resources} used to get the drawable. Tipically a
	 *            reference to {@link Activity#getResources()}
	 * @param mapView
	 */
	public CustomBalloonDrawer(Drawable drawable, MapView mapView) 
	{
		// Initializes the Overlay. Each OverlayItem will be drawn with this
		// drawable.
		// super(boundCenterBottom(mapView.getContext().getResources().getDrawable(R.drawable.icon_24)), mapView);
		super(boundCenterBottom(drawable), mapView);
	}

	/**
	 * Returning just one static item.
	 */
	@Override
	protected OverlayItem createItem(int i) {
		final GeoPoint somePosition = new GeoPoint(42431320, -8642187);
		final OverlayItem ovelayItem = new OverlayItem(somePosition, "Discalis Soluciones S.L.",
				"Actually, we're not using this for anything...");
		return ovelayItem;
	}

	/**
	 * Just one single static item...
	 * <p>
	 * You're probably backing your {@link OverlayItem}s in some
	 * {@link Collection}, so this method will return the size of that
	 * {@link Collection}.
	 * </p>
	 * <p>
	 * Please, take <i>thread safeiness</i> in consideration on your
	 * implementation. Something like {@link CopyOnWriteArrayList} may be very
	 * usefull avoiding {@link ConcurrentModificationException}s...
	 * </p>
	 * 
	 * @see #createItem(int);
	 */
	@Override
	public int size() {
		return 1;
	}

	/**
	 * Drop a log entry when user taps a balloon
	 * 
	 */
	@Override
	protected boolean onBalloonTap(int index) {
		Log.i("Discalis Soluciones","TAP!");
		return true;
	}
}
