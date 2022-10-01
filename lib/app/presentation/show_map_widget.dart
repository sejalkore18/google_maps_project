import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_project/app/data/get_data.dart';
import 'package:google_maps_project/app/domain/entities/region_entity.dart';
import 'package:google_maps_project/app/presentation/show_pollution_index_widget.dart';
import 'package:google_maps_project/utils/keys.dart';

class ShowMapWidget extends StatefulWidget {
  const ShowMapWidget({Key? key}) : super(key: key);

  @override
  State<ShowMapWidget> createState() => _ShowMapWidgetState();
}

class _ShowMapWidgetState extends State<ShowMapWidget> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Set<Marker> getMakerSet({required List<RegionEntity> regionEntityList}) {
    List<Marker> markerList = [];

    for (int i = 0; i < regionEntityList.length; i++) {
      markerList.add(
        Marker(
            markerId: MarkerId(regionEntityList[i].name),
            position: regionEntityList[i].latLng,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  ShowPollutionIndexWidget(
                    pollutionIndicesEntity:
                        regionEntityList[i].pollutionIndicesEntity,
                  ),
                  regionEntityList[i].latLng);
            }),
      );
    }

    return markerList.toSet();
  }

  CameraPosition getInitialCameraPosition(
      {required List<RegionEntity> regionEntityList}) {
    CameraPosition cameraPosition = const CameraPosition(
      target: LatLng(0, 0),
      zoom: 0,
    );

    for (int i = 0; i < regionEntityList.length; i++) {
      if (regionEntityList[i].name == Keys.keyNameCentral) {
        cameraPosition = CameraPosition(
          target: regionEntityList[i].latLng,
          zoom: 11,
        );
      }
    }

    return cameraPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Singapore Map'),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<RegionEntity> regionEntityList =
                    snapshot.data as List<RegionEntity>;

                return Stack(
                  children: [
                    GoogleMap(
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      mapType: MapType.hybrid,
                      markers: getMakerSet(regionEntityList: regionEntityList),
                      initialCameraPosition: getInitialCameraPosition(
                          regionEntityList: regionEntityList),
                      onMapCreated: (GoogleMapController controller) {
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: 200,
                      width: 150,
                      offset: 50,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                log('${snapshot.error}');
                return const Center(
                  child: Text('Error Occured :('),
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
