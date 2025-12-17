import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:location/location.dart' as loc;
import 'package:map_location_picker/map_location_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUPlacePicker extends StatefulWidget {
  /// Padding around the map
  final EdgeInsets padding;

  /// Compass for the map (default: true)
  final bool compassEnabled;

  /// Lite mode for the map (default: false)
  final bool liteModeEnabled;

  /// API key for the map & places
  final String apiKey;

  /// GPS accuracy for the map
  final LocationAccuracy desiredAccuracy;

  /// GeoCoding base url
  final String? geoCodingBaseUrl;

  /// GeoCoding http client
  final Client? geoCodingHttpClient;

  /// GeoCoding api headers
  final Map<String, String>? geoCodingApiHeaders;

  /// GeoCoding location type
  final List<String> locationType;

  /// GeoCoding result type
  final List<String> resultType;

  /// Map minimum zoom level & maximum zoom level
  final MinMaxZoomPreference minMaxZoomPreference;

  /// Top card margin
  final EdgeInsetsGeometry topCardMargin;

  /// Top card color
  final Color? topCardColor;

  /// Top card shape
  final ShapeBorder topCardShape;

  /// Top card text field border radius
  final BorderRadiusGeometry borderRadius;

  /// Top card text field hint text
  final String searchHintText;

  /// Bottom card shape
  final ShapeBorder bottomCardShape;

  /// Bottom card margin
  final EdgeInsetsGeometry bottomCardMargin;

  /// Bottom card icon
  final Icon bottomCardIcon;

  /// Bottom card tooltip
  final String bottomCardTooltip;

  /// Bottom card color
  final Color? bottomCardColor;

  /// On location permission callback
  final bool hasLocationPermission;

  /// detect location button click callback
  final Function()? getLocation;

  /// On Suggestion Selected callback
  final Function(PlacesDetailsResponse?)? onSuggestionSelected;

  /// On Next Page callback
  final Function(GeocodingResult?)? onNext;

  /// When tap on map decode address callback function
  final Function(GeocodingResult?, {bool? isFromSearch})? onDecodeAddress;

  /// Show back button (default: true)
  final bool hideBackButton;

  /// Popup route on next press (default: false)
  final bool popOnNextButtonTaped;

  /// Back button replacement when [hideBackButton] is false and [backButton] is not null
  final Widget? backButton;

  /// Show more suggestions
  final bool hideMoreOptions;

  /// Dialog title
  final String dialogTitle;

  /// httpClient is used to make network requests.
  final Client? placesHttpClient;

  /// apiHeader is used to add headers to the request.
  final Map<String, String>? placesApiHeaders;

  /// baseUrl is used to build the url for the request.
  final String? placesBaseUrl;

  /// Session token for Google Places API
  final String? sessionToken;

  /// Offset for pagination of results
  /// offset: int,
  final num? offset;

  /// Origin location for calculating distance from results
  /// origin: Location(lat: -33.852, lng: 151.211),
  final Location? origin;

  /// currentLatLng init location for camera position
  /// currentLatLng: Location(lat: 40.7128, lng: 74.0060),
  final LatLng? currentLatLng;

  /// Location bounds for restricting results to a radius around a location
  /// location: Location(lat: 40.741895, lng: -73.989308)
  final Location? location;

  /// Radius for restricting results to a radius around a location
  /// radius: Radius in meters
  final num? radius;

  /// Language code for Places API results
  /// language: 'en',
  final String? language;

  /// Types for restricting results to a set of place types
  final List<String> types;

  /// Components set results to be restricted to a specific area
  /// components: [Component(Component.country, "us")]
  final List<Component> components;

  /// Bounds for restricting results to a set of bounds
  final bool strictbounds;

  /// Region for restricting results to a set of regions
  /// region: "us"
  final String? region;

  /// List of fields to be returned by the Google Maps Places API.
  /// Refer to the Google Documentation here for a list of valid values: https://developers.google.com/maps/documentation/places/web-service/details
  final List<String> fields;

  /// Map type (default: MapType.normal)
  final MapType mapType;

  /// Hide top search bar (default: false)
  final bool hideSearchBar;

  /// Search text field controller
  final TextEditingController? searchController;

  /// Add your own custom markers
  final Map<String, LatLng>? additionalMarkers;

  /// Add your own custom markers icon
  final String? assetsMarkerIcon;

  /// Safe area parameters (default: true)
  final bool bottom;
  final bool left;
  final bool maintainBottomViewPadding;
  final EdgeInsets minimum;
  final bool right;
  final bool top;

  /// hide location button and map type button (default: false)
  final bool hideLocationButton;
  final bool hideMapTypeButton;

  /// hide bottom card (default: false)
  final bool hideBottomCard;

  /// Focus node for the search text field
  final FocusNode? focusNode;

  /// Tooltip for the FAB button.
  final String fabTooltip;

  /// FAB icon
  final IconData fabIcon;

  /// Minimum number of characters to trigger the autocomplete
  /// Defaults to 0
  final int minCharsForSuggestions;

  /// Map styles, you can style a map to be dark or light, see more at
  /// [https://stackoverflow.com/questions/49953913/flutter-styled-map] and see here to create a json
  /// styling and load it from assets as a string [https://mapstyle.withgoogle.com]
  final String? mapStyle;

  /// Enables or disables showing 3D buildings where available
  final bool buildingsEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  /// Circles to be placed on the map.
  final Set<Circle> circles;

  /// Identifier that's associated with a specific cloud-based map style.
  ///
  /// See https://developers.google.com/maps/documentation/get-map-id
  /// for more details.
  final String? cloudMapId;

  /// True if 45 degree imagery should be enabled. Web only.
  final bool fortyFiveDegreeImageryEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// Enables or disables the indoor view from the map
  final bool indoorViewEnabled;

  /// The layout direction to use for the embedded view.
  ///
  /// If this is null, the ambient [Directionality] is used instead. If there is
  /// no ambient [Directionality], [TextDirection.ltr] is used.
  final TextDirection? layoutDirection;

  /// True if the map should show a toolbar when you interact with the map. Android only.
  final bool mapToolbarEnabled;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  final VoidCallback? onCameraMoveStarted;

  /// Called every time a [GoogleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// Tile overlays to be placed on the map.
  final Set<TileOverlay> tileOverlays;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// Enables or disables the traffic layer of the map
  final bool trafficEnabled;

  /// This setting controls how the API handles gestures on the map. Web only.
  ///
  /// See [WebGestureHandling] for more details.
  final WebGestureHandling? webGestureHandling;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  final InputDecoration? decoration;

  final Widget? Function(
      BuildContext context,
      GeocodingResult? result,
      String address,
      )? bottomCardBuilder;

  /// Duration for search debounce in milliseconds
  final Duration debounceDuration;

  const UFUPlacePicker({
    super.key,
    this.desiredAccuracy = LocationAccuracy.high,
    required this.apiKey,
    this.geoCodingBaseUrl,
    this.geoCodingHttpClient,
    this.geoCodingApiHeaders,
    this.language,
    this.locationType = const [],
    this.resultType = const [],
    this.minMaxZoomPreference = const MinMaxZoomPreference(0, 16),
    this.padding = const EdgeInsets.all(0),
    this.compassEnabled = true,
    this.liteModeEnabled = false,
    this.topCardMargin = const EdgeInsets.all(8),
    this.topCardColor,
    this.topCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.searchHintText = "Start typing to search",
    this.bottomCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.bottomCardMargin = const EdgeInsets.fromLTRB(8, 8, 8, 16),
    this.bottomCardIcon = const Icon(Icons.send),
    this.bottomCardTooltip = "Continue with this location",
    this.bottomCardColor,
    this.hasLocationPermission = true,
    this.getLocation,
    this.onSuggestionSelected,
    this.onNext,
    this.currentLatLng = const LatLng(40.741895, -73.989308),
    this.hideBackButton = false,
    this.popOnNextButtonTaped = false,
    this.backButton,
    this.hideMoreOptions = false,
    this.dialogTitle = 'You can also use the following options',
    this.placesHttpClient,
    this.placesApiHeaders,
    this.placesBaseUrl,
    this.sessionToken,
    this.offset,
    this.origin,
    this.location,
    this.radius,
    this.region,
    this.fields = const [],
    this.types = const [],
    this.components = const [],
    this.strictbounds = false,
    this.mapType = MapType.normal,
    this.hideSearchBar = false,
    this.searchController,
    this.additionalMarkers,
    this.assetsMarkerIcon,
    this.bottom = true,
    this.left = true,
    this.maintainBottomViewPadding = false,
    this.minimum = EdgeInsets.zero,
    this.right = true,
    this.top = true,
    this.hideLocationButton = false,
    this.hideMapTypeButton = false,
    this.hideBottomCard = false,
    this.onDecodeAddress,
    this.focusNode,
    this.mapStyle,
    this.fabTooltip = 'My Location',
    this.fabIcon = Icons.my_location,
    this.minCharsForSuggestions = 0,
    this.buildingsEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.circles = const <Circle>{},
    this.cloudMapId,
    this.fortyFiveDegreeImageryEnabled = false,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.indoorViewEnabled = false,
    this.layoutDirection,
    this.mapToolbarEnabled = true,
    this.onCameraIdle,
    this.onCameraMoveStarted,
    this.onLongPress,
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.tileOverlays = const <TileOverlay>{},
    this.tiltGesturesEnabled = true,
    this.trafficEnabled = true,
    this.webGestureHandling,
    this.zoomGesturesEnabled = true,
    this.decoration,
    this.bottomCardBuilder,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<UFUPlacePicker> createState() => _UFUPlacePickerState();
}

class _UFUPlacePickerState extends State<UFUPlacePicker> {
  /// Map controller for movement & zoom
  final Completer<GoogleMapController> _controller = Completer();

  /// initial latitude & longitude
  late LatLng _initialPosition = const LatLng(40.741895, -73.989308);

  /// initial address text
  late String _address = "Tap on map to get address";

  /// Map type (default: MapType.normal)
  late MapType _mapType = MapType.normal;

  /// initial zoom level
  late double _zoom = 18.0;

  /// GeoCoding result for further use
  GeocodingResult? _geocodingResult;

  /// GeoCoding results list for further use
  late List<GeocodingResult> _geocodingResultList = [];

  /// Search text field controller
  late TextEditingController _searchController = TextEditingController();

  Set<Marker> markers = {};

  bool isFromSearch = false;

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: Navigator.of(context).userGestureInProgress,
      child: Scaffold(
        body: Stack(
          children: [
            /// Google map view
            GoogleMap(
              minMaxZoomPreference: widget.minMaxZoomPreference,
              onCameraMove: (CameraPosition position) {
                /// set zoom level
                _zoom = position.zoom;
              },
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: _zoom,
              ),
              onTap: (LatLng position) async {
                _initialPosition = position;
                final controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition()),
                );
                _decodeAddress(
                  Location(
                    lat: position.latitude,
                    lng: position.longitude,
                  ),
                );
                (await _controller.future).showMarkerInfoWindow(const MarkerId("one"));
                setState(() {});
              },
              onMapCreated: (GoogleMapController controller) =>
                  _controller.complete(controller),
              // markers: markers,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              padding: widget.padding,
              compassEnabled: widget.compassEnabled,
              liteModeEnabled: widget.liteModeEnabled,
              mapType: widget.mapType,
              style: widget.mapStyle,
              buildingsEnabled: widget.buildingsEnabled,
              cameraTargetBounds: widget.cameraTargetBounds,
              circles: widget.circles,
              cloudMapId: widget.cloudMapId,
              fortyFiveDegreeImageryEnabled: widget.fortyFiveDegreeImageryEnabled,
              gestureRecognizers: widget.gestureRecognizers,
              indoorViewEnabled: widget.indoorViewEnabled,
              layoutDirection: widget.layoutDirection,
              mapToolbarEnabled: widget.mapToolbarEnabled,
              onCameraIdle:() async {
                widget.onCameraIdle;
                final controller = await _controller.future;

                // Get visible region bounds
                final bounds = await controller.getVisibleRegion();

                // Calculate center LatLng
                final centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
                final centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
                final position = LatLng(centerLat, centerLng);

                if(_initialPosition != const LatLng(40.741895, -73.989308)) {
                  if(isFromSearch) {
                   setState(() => isFromSearch = false);
                  } else {
                    _decodeAddress(
                      Location(
                        lat: position.latitude,
                        lng: position.longitude,
                      ),
                    );
                    if(_searchController.text.trim().isNotEmpty) {
                      _searchController.text = "";
                    }
                  }
                }
              },
              onCameraMoveStarted: widget.onCameraMoveStarted,
              onLongPress: widget.onLongPress,
              polygons: widget.polygons,
              polylines: widget.polylines,
              rotateGesturesEnabled: widget.rotateGesturesEnabled,
              scrollGesturesEnabled: widget.scrollGesturesEnabled,
              tileOverlays: widget.tileOverlays,
              tiltGesturesEnabled: widget.tiltGesturesEnabled,
              trafficEnabled: widget.trafficEnabled,
              webGestureHandling: widget.webGestureHandling,
              zoomGesturesEnabled: widget.zoomGesturesEnabled,
            ),
            SafeArea( 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Search text field
                  if (!widget.hideSearchBar)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(widget.backButton != null)
                          widget.backButton!,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: CustomPlaceAutoComplete(
                              topCardMargin: EdgeInsets.zero,
                              topCardColor: Colors.white,
                              apiKey: widget.apiKey,
                              searchHintText: widget.searchHintText,
                              placesApiHeaders: widget.placesApiHeaders,
                              mounted: false,
                              hideBackButton: true,
                              hideOnUnfocus: false,
                              initialValue: null,
                              controller: _searchController,
                              showClearButton: true,
                              left: true,
                              decoration: widget.decoration,
                              suffixIcon: Icon(Icons.search, size: 18, color: AppTheme.themeColors.secondaryText),
                              onGetDetailsByPlaceId: (p0, {Prediction? searchedPlace}) => saveCurrentLocation(p0?.result, searchedItem: searchedPlace),
                              // onSelected: (data) => saveCurrentLocation(null, searchedItem: data), //{print("====> ${data.toJson()}");},
                              emptyBuilder: (context) => _searchController.text.trim().isEmpty
                                  ? const SizedBox.shrink() : emptySearchResultBuilder(context),
                              itemBuilder: (context, content) => searchResultItem(context, content),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  if (!widget.hideMapTypeButton)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: null,
                        tooltip: 'Map Type',
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        child: PopupMenuButton(
                          initialValue: _mapType,
                          icon: Icon(
                            Icons.layers,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onSelected: (MapType mapType) {
                            setState(() {
                              _mapType = mapType;
                            });
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: MapType.normal,
                              child: Text('Normal'),
                            ),
                            PopupMenuItem(
                              value: MapType.hybrid,
                              child: Text('Hybrid'),
                            ),
                            PopupMenuItem(
                              value: MapType.satellite,
                              child: Text('Satellite'),
                            ),
                            PopupMenuItem(
                              value: MapType.terrain,
                              child: Text('Terrain'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!widget.hideLocationButton)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        tooltip: widget.fabTooltip,
                        backgroundColor: AppTheme.themeColors.base,
                        foregroundColor: AppTheme.themeColors.primary,
                        onPressed: () => fetchAndNavigateToCurrentLocation(),
                        child: Icon(widget.fabIcon),
                      ),
                    ),
                  if (!widget.hideBottomCard)
                    widget.bottomCardBuilder
                        ?.call(context, _geocodingResult, _address) ??
                        Card(
                          margin: widget.bottomCardMargin,
                          shape: widget.bottomCardShape,
                          color: widget.bottomCardColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(_address),
                                trailing: IconButton(
                                  tooltip: widget.bottomCardTooltip,
                                  icon: widget.bottomCardIcon,
                                  onPressed: () async {
                                    widget.onNext?.call(_geocodingResult);
                                    if (widget.popOnNextButtonTaped) {
                                      Navigator.pop(context, _geocodingResult);
                                    }
                                  },
                                ),
                              ),
                              if (!widget.hideMoreOptions &&
                                  _geocodingResultList.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(widget.dialogTitle),
                                        scrollable: true,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                          _geocodingResultList.map((element) {
                                            return ListTile(
                                              title: Text(
                                                  element.formattedAddress ?? ""),
                                              onTap: () {
                                                _address =
                                                    element.formattedAddress ??
                                                        "";
                                                _geocodingResult = element;
                                                setState(() {});
                                                Navigator.pop(context, element);
                                              },
                                            );
                                          }).toList(),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Chip(
                                    label: Text(
                                      "Tap to show ${(_geocodingResultList.length - 1)} more result options",
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Camera position moved to location
  CameraPosition cameraPosition() {
    return CameraPosition(
      target: _initialPosition,
      zoom: _zoom,
    );
  }

  @override
  void initState() {
    _initialPosition = widget.currentLatLng ?? _initialPosition;
    _mapType = widget.mapType;
    _searchController = widget.searchController ?? _searchController;
    // if (widget.currentLatLng != null) {
    //   _decodeAddress(
    //     Location(
    //       lat: _initialPosition.latitude,
    //       lng: _initialPosition.longitude,
    //     ),
    //   );
    // }

    fetchAndNavigateToCurrentLocation();

    super.initState();
  }

  void updateMarker(MarkerId markerId, LatLng newPosition) {
    // Remove the old marker
    markers.removeWhere((marker) => marker.markerId == markerId);

    // Add the updated marker
    markers.add(
      Marker(
        markerId: markerId,
        position: newPosition, // Updated position
      ),
    );

    // Trigger UI update
    setState(() {});
  }

  /// Decode address from latitude & longitude
  Future<void> _decodeAddress(Location location) async {
    try {
      final geocoding = GoogleMapsGeocoding(
        apiKey: widget.apiKey,
        baseUrl: widget.geoCodingBaseUrl,
        apiHeaders: widget.geoCodingApiHeaders,
        httpClient: widget.geoCodingHttpClient,
      );
      final response = await geocoding.searchByLocation(
        location,
        language: widget.language,
        locationType: widget.locationType,
        resultType: widget.resultType,
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        debugPrint(response.errorMessage);
        _address = response.status;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ??
                  "Address not found, something went wrong!"),
            ),
          );
        }
        return;
      }
      _address = response.results.first.formattedAddress ?? "";
      _geocodingResult = response.results.first;
      widget.onDecodeAddress?.call(_geocodingResult);
      if (response.results.length > 1) {
        _geocodingResultList = response.results;
      }
      if(_searchController.text.trim().isNotEmpty) {
        _searchController.text = "";
      }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  saveCurrentLocation(PlaceDetails? selectedPlace, {Prediction? searchedItem}) async {
    UFUtils.hideKeyboard();
    if (selectedPlace == null && searchedItem == null) return;

    Location sLocation = selectedPlace?.geometry?.location
        ?? _geocodingResult?.geometry.location
        ?? widget.location
        ?? Location(
          lat: _initialPosition.latitude,
          lng: _initialPosition.longitude,
        );

    if(searchedItem != null) {

      Map<String, dynamic> addressComponent = {"address_components": []};
      if(searchedItem.terms.isNotEmpty) {
        for (var element in selectedPlace!.addressComponents) {
          addressComponent["address_components"].add(element.toJson());
        }
      }

      _geocodingResult = GeocodingResult.fromJson({
        "geometry": {
          "location": {
            "lat": sLocation.lat,
            "lng": sLocation.lng,
          }
        },
        "place_id": searchedItem.placeId,
        'formatted_address': searchedItem.description,
        ...addressComponent
      });

      setState(() => isFromSearch = true);
    }

    (await _controller.future).animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(sLocation.lat, sLocation.lng),
          zoom: _zoom,
        )));

    widget.onDecodeAddress?.call(_geocodingResult);
  }

  Widget searchResultItem(BuildContext context, Prediction content) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: AppTheme.themeColors.base,
      // border: Border.all(color: AppTheme.themeColors.tertiary, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset("assets/images/ic_location_pin.png", color: Colors.black, height: 18, width: 18),
            const SizedBox(width: 12),
            Expanded(child: UFUText(
              text: content.terms.first.value,
              textAlign: TextAlign.start,
            ))
          ],
        ),
        const SizedBox(height: 5),
        UFUText(text: content.description ?? '',
          maxLine: 5,
          textSize: UFUTextSize.heading6,
          textAlign: TextAlign.start,
        )
      ],
    ),
  );

  Widget emptySearchResultBuilder(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppTheme.themeColors.tertiary, width: 1),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: UFUText(text: "No Address Found!"))
      ],
    ),
  );


  Future<void> fetchAndNavigateToCurrentLocation () async {
    /// call parent method
    if (widget.getLocation != null) {
      widget.getLocation!.call();
    }

    /// get current location
    if (widget.hasLocationPermission) {

      if (!(await UFUtils.permissionUtils.getLocationPermission())) {
        debugPrint("------> Permission denied ");
        bool? isLocationEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
        if(!isLocationEnabled) {
          debugPrint("------> Location service denied ");
          bool locationEnabled = await loc.Location().requestService();
          if(!locationEnabled) {
            bool? locEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
            if(!locEnabled) {
              Get.back();
              return;
            }
          }
        }  else {

        }
        Get.back();
        return;
      } else {
        bool? isLocationEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
        if(!isLocationEnabled) {
          debugPrint("------> Location service denied ");
          bool locationEnabled = await loc.Location().requestService();
          if(!locationEnabled) {
            bool? locEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
            if(!locEnabled) {
              Get.back();
              return;
            }
          }
        }
      }

      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: widget.desiredAccuracy,
      // );

      if (_initialPosition == const LatLng(40.741895, -73.989308)) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best, // Choose appropriate accuracy
          ),
        );
        _initialPosition = LatLng(position.latitude, position.longitude);
      }

      // Get the controller instance
      final controller = await _controller.future;

      // Animate camera to the updated/current location
      controller.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition()),
      );

      // Decode address from latitude & longitude
      // _decodeAddress(
      //   Location(
      //     lat: _initialPosition.latitude,
      //     lng: _initialPosition.longitude,
      //   ),
      // );

      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}