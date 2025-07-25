import 'package:deliveryboy/generated/l10n.dart';
import 'package:deliveryboy/src/elements/CircularLoadingWidget.dart';
import 'package:deliveryboy/src/helpers/helper.dart';
import 'package:deliveryboy/src/models/order.dart';
import 'package:deliveryboy/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:state_extended/state_extended.dart';

import 'package:deliveryboy/src/controllers/map_controller.dart';

class MapWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MapWidget({Key? key, required this.routeArgument, required this.parentScaffoldKey}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends AppStateX<MapWidget> {
  MapController? _con;

  _MapWidgetState() : super(controller: MapController()) {
    _con = controller as MapController?;
  }

  @override
  void initState() {
    _con!.currentOrder = widget.routeArgument.param as Order;
    if (_con!.currentOrder?.deliveryAddress?.latitude != null) {
      _con!.getOrderLocation();
      _con!.getDirectionSteps();
    } else {
      _con!.getCurrentLocation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _con!.currentOrder?.deliveryAddress?.latitude == null
            ? new IconButton(
                icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
                onPressed: () => widget.parentScaffoldKey.currentState!.openDrawer(),
              )
            : IconButton(icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor), onPressed: () => Navigator.of(context).pop()),
        title: Text(S.of(context).delivery_addresses, style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(letterSpacing: 1.3))),
        actions: [IconButton(icon: Icon(Icons.my_location, color: Theme.of(context).hintColor), onPressed: () => _con!.goCurrentLocation())],
      ),
      body: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          _con!.cameraPosition == null
              ? CircularLoadingWidget(height: 0)
              : GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _con!.cameraPosition!,
                  markers: Set.from(_con!.allMarkers),
                  onMapCreated: (GoogleMapController controller) => _con!.mapController.complete(controller),
                  onCameraMove: (CameraPosition cameraPosition) => _con!.cameraPosition = cameraPosition,
                  onCameraIdle: () => _con!.getOrdersOfArea(),
                  polylines: _con!.polylines,
                ),
          Container(
            height: 95,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.9),
              boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withValues(alpha: 0.1), blurRadius: 5, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _con!.currentOrder?.orderStatus?.id == '5'
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withValues(alpha: 0.2)),
                        child: Icon(Icons.check, color: Colors.green, size: 32),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                        child: Icon(Icons.update, color: Theme.of(context).hintColor.withValues(alpha: 0.8), size: 30),
                      ),
                SizedBox(width: 15),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              S.of(context).order_id + "#${_con!.currentOrder!.id}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              _con!.currentOrder?.payment?.method ?? S.of(context).cash_on_delivery,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(DateFormat('yyyy-MM-dd HH:mm').format(_con!.currentOrder!.dateTime!), style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Helper.getPrice(
                            Helper.getTotalOrdersPrice(_con!.currentOrder!),
                            context,
                            style: Theme.of(context).textTheme.headlineMedium!,
                          ),
                          Text(
                            '${S.of(context).items}: ${(_con?.currentOrder?.foodOrders.length ?? 0).toString()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
