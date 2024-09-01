package org.odk.collect.android.geo;

import org.odk.collect.android.application.Collect;
import java.io.Serializable;

/**
 * A serializable definition of a Web Map Service in terms of its URL structure
 * and the parameters for fetching tiles from it.
 */
class WebMapService implements Serializable {
    public final String cacheName;
    public final int minZoomLevel;
    public final int maxZoomLevel;
    public final int tileSize;
    public final String copyright;
    public final String[] urlTemplates;

    WebMapService(String cacheName, int minZoomLevel, int maxZoomLevel,
        int tileSize, String copyright, String... urlTemplates) {
        this.cacheName = cacheName;
        this.minZoomLevel = minZoomLevel;
        this.maxZoomLevel = maxZoomLevel;
        this.tileSize = tileSize;
        this.copyright = copyright;
        this.urlTemplates = urlTemplates;
    }

    @Deprecated WebMapService(int cacheNameStringId, int minZoomLevel,
        int maxZoomLevel, int tileSize, String copyright, String... urlTemplates) {
        this(Collect.getInstance().getString(cacheNameStringId),
            minZoomLevel, maxZoomLevel, tileSize, copyright, urlTemplates);
    }

    private String getExtension(String urlTemplate) {
        String[] parts = urlTemplate.split("/");
        String lastPart = parts[parts.length - 1];
        if (lastPart.contains(".")) {
            String[] subparts = lastPart.split("\\.");
            return "." + subparts[subparts.length - 1];
        }
        return "";
    }
}
