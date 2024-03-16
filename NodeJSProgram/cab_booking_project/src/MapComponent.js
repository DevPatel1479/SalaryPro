import React, { useEffect, useRef } from 'react';

function MapComponent() {
    const mapRef = useRef(null);

    useEffect(() => {
        let map;
        const initMap = () => {
            if (window.H && !mapRef.current) {
                const platform = new window.H.service.Platform({
                    apikey: 'Q1r25zwTmasSlZr62SRP91JsUtR5Q6G6-8dj_g_mcuI'
                });
                const defaultLayers = platform.createDefaultLayers();
                map = new window.H.Map(document.getElementById('map'), defaultLayers.vector.normal.map, {
                    center: { lat: 23.0225, lng: 72.5714 }, // Ahmedabad, India coordinates
                    zoom: 14
                });

                map.addEventListener('mapviewchangeend', () => {
                    const marker = new window.H.map.Marker({ lat: 23.0225, lng: 72.5714 }); // Marker for Ahmedabad
                    map.addObject(marker);
                });

                mapRef.current = map;
            } else {
                console.error('HERE Maps API not loaded or map already initialized.');
            }
        };

        if (!window.H) {
            const script = document.createElement('script');
            script.src = 'https://js.api.here.com/v3/3.1/mapsjs-core.js';
            script.async = true;
            script.onload = initMap;
            script.onerror = () => console.error('Failed to load HERE Maps API script.');
            document.body.appendChild(script);
        } else {
            initMap();
        }

        return () => {
            // Clean up
            if (map) {
                map.dispose();
                mapRef.current = null;
            }
        };
    }, []);

    return <div id="map" style={{ width: '100vw', height: '100vh', position: 'fixed', top: 0, left: 0 }} />;
}

export default MapComponent;
