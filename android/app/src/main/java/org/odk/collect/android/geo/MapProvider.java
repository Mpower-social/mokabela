package org.odk.collect.android.geo;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;

import androidx.annotation.NonNull;

import com.google.android.gms.maps.GoogleMap;

import org.odk.collect.android.R;
import org.odk.collect.android.geo.GoogleMapConfigurator.GoogleMapTypeOption;
import org.odk.collect.android.geo.MapboxMapConfigurator.MapboxUrlOption;
import org.odk.collect.android.preferences.PrefUtils;

import java.util.Map;
import java.util.WeakHashMap;

import static org.odk.collect.android.preferences.GeneralKeys.BASEMAP_SOURCE_CARTO;
import static org.odk.collect.android.preferences.GeneralKeys.BASEMAP_SOURCE_GOOGLE;
import static org.odk.collect.android.preferences.GeneralKeys.BASEMAP_SOURCE_MAPBOX;
import static org.odk.collect.android.preferences.GeneralKeys.BASEMAP_SOURCE_STAMEN;
import static org.odk.collect.android.preferences.GeneralKeys.BASEMAP_SOURCE_USGS;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_BASEMAP_SOURCE;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_CARTO_MAP_STYLE;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_GOOGLE_MAP_STYLE;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_MAPBOX_MAP_STYLE;
import static org.odk.collect.android.preferences.GeneralKeys.KEY_USGS_MAP_STYLE;

/**
 * Obtains a MapFragment according to the user's preferences.
 * This is the top-level class that should be used by the rest of the application.
 * The available options on the Maps preferences screen are also defined here.
 */
public class MapProvider {
    private static final SourceOption[] SOURCE_OPTIONS = initOptions();
    private static final String USGS_URL_BASE =
        "https://basemap.nationalmap.gov/arcgis/rest/services";
    private static final String CARTO_COPYRIGHT = "© CARTO";
    private static final String CARTO_ATTRIBUTION = CARTO_COPYRIGHT;
    private static final String STAMEN_ATTRIBUTION = "Map tiles by Stamen Design, under CC BY 3.0.\nData by OpenStreetMap, under ODbL.";
    private static final String USGS_ATTRIBUTION = "Map services and data available from U.S. Geological Survey,\nNational Geospatial Program.";

    // In general, there will only be one MapFragment, and thus one entry, in
    // each of these two Maps at any given time.  Nonetheless, it's a little
    // tidier and less error-prone to use a Map than to track the key and value
    // in separate fields, and the WeakHashMap will conveniently drop the key
    // automatically when it's no longer needed.

    /** Keeps track of the listener associated with a given MapFragment. */
    private final Map<MapFragment, OnSharedPreferenceChangeListener>
        listenersByMap = new WeakHashMap<>();

    /** Keeps track of the configurator associated with a given MapFragment. */
    private final Map<MapFragment, MapConfigurator>
        configuratorsByMap = new WeakHashMap<>();

    /**
     * In the preference UI, the available basemaps are organized into "sources"
     * to make them easier to find.  This defines the basemap sources and the
     * basemap options available under each one, in their order of appearance.
     */
    private static SourceOption[] initOptions() {
        return new SourceOption[] {
            new SourceOption(BASEMAP_SOURCE_GOOGLE, R.string.basemap_source_google,
                new GoogleMapConfigurator(
                    KEY_GOOGLE_MAP_STYLE, R.string.basemap_source_google,
                    new GoogleMapTypeOption(GoogleMap.MAP_TYPE_NORMAL, R.string.streets),
                    new GoogleMapTypeOption(GoogleMap.MAP_TYPE_TERRAIN, R.string.terrain),
                    new GoogleMapTypeOption(GoogleMap.MAP_TYPE_HYBRID, R.string.hybrid),
                    new GoogleMapTypeOption(GoogleMap.MAP_TYPE_SATELLITE, R.string.satellite)
                )
            ),
        };
    }

    /** Gets a new MapFragment from the selected MapConfigurator. */
    public MapFragment createMapFragment(Context context) {
        MapConfigurator cftor = getConfigurator();
        MapFragment map = cftor.createMapFragment(context);
        if (map != null) {
            configuratorsByMap.put(map, cftor);
            return map;
        }
        cftor.showUnavailableMessage(context);
        return null;
    }

    /** Gets the currently selected MapConfigurator. */
    public static @NonNull MapConfigurator getConfigurator() {
        return getOption(null).cftor;
    }

    /**
     * Gets the MapConfigurator for the SourceOption with the given id, or the
     * currently selected MapConfigurator if id is null.
     */
    public static @NonNull MapConfigurator getConfigurator(String id) {
        return getOption(id).cftor;
    }

    /** Gets the currently selected SourceOption's label string resource ID. */
    public static int getSourceLabelId() {
        return getOption(null).labelId;
    }

    /** Gets a list of the IDs of the basemap sources, in order. */
    public static String[] getIds() {
        String[] ids = new String[SOURCE_OPTIONS.length];
        for (int i = 0; i < ids.length; i++) {
            ids[i] = SOURCE_OPTIONS[i].id;
        }
        return ids;
    }

    /** Gets a list of the label string IDs of the basemap sources, in order. */
    public static int[] getLabelIds() {
        int[] labelIds = new int[SOURCE_OPTIONS.length];
        for (int i = 0; i < labelIds.length; i++) {
            labelIds[i] = SOURCE_OPTIONS[i].labelId;
        }
        return labelIds;
    }

    /**
     * Gets the SourceOption with the given id, or the currently selected option
     * if id is null, or the first option if the id is unknown.  Never null.
     */
    private static @NonNull SourceOption getOption(String id) {
        if (id == null) {
            id = PrefUtils.getSharedPrefs().getString(KEY_BASEMAP_SOURCE, null);
        }
        for (SourceOption option : SOURCE_OPTIONS) {
            if (option.id.equals(id)) {
                return option;
            }
        }
        return SOURCE_OPTIONS[0];
    }

    void onMapFragmentStart(MapFragment map) {
        MapConfigurator cftor = configuratorsByMap.get(map);
        if (cftor != null) {
            OnSharedPreferenceChangeListener listener = (prefs, key) -> {
                if (cftor.getPrefKeys().contains(key)) {
                    map.applyConfig(cftor.buildConfig(prefs));
                }
            };
            SharedPreferences prefs = PrefUtils.getSharedPrefs();
            map.applyConfig(cftor.buildConfig(prefs));
            prefs.registerOnSharedPreferenceChangeListener(listener);
            listenersByMap.put(map, listener);
        }
    }

    void onMapFragmentStop(MapFragment map) {
        OnSharedPreferenceChangeListener listener = listenersByMap.get(map);
        if (listener != null) {
            SharedPreferences prefs = PrefUtils.getSharedPrefs();
            prefs.unregisterOnSharedPreferenceChangeListener(listener);
            listenersByMap.remove(map);
        }
    }

    private static class SourceOption {
        private final String id;  // preference value to store
        private final int labelId;  // string resource ID
        private final MapConfigurator cftor;

        private SourceOption(String id, int labelId, MapConfigurator cftor) {
            this.id = id;
            this.labelId = labelId;
            this.cftor = cftor;
        }
    }
}
