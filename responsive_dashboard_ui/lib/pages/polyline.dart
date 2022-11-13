import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:responsive_dashboard_ui/widgets/drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_dashboard_ui/style/style.dart';
import 'package:responsive_dashboard_ui/style/colors.dart';
import 'package:responsive_dashboard_ui/config/size_config.dart';
import 'package:responsive_dashboard_ui/config/responsive.dart';

import 'package:responsive_dashboard_ui/pages/zoombuttons_plugin_option.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class PolylinePage extends StatefulWidget {
  static const String route = '/polyline';

  const PolylinePage({Key? key}) : super(key: key);

  @override
  State<PolylinePage> createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {
  List<LatLng> tappedPoints = [
    LatLng(55.5, -0.09),
    LatLng(54.3498, -6.2603),
    LatLng(52.8566, 2.3522),
  ];

  late Future<List<Polyline>> polylines;

  Future<List<Polyline>> getPolylines() async {
    final polyLines = [
      Polyline(
        points: [
          LatLng(50.5, -0.09),
          LatLng(51.3498, -6.2603),
          LatLng(53.8566, 2.3522),
        ],
        strokeWidth: 4,
        color: Colors.amber,
      ),
    ];
    await Future<void>.delayed(const Duration(seconds: 3));
    return polyLines;
  }

  @override
  void initState() {
    polylines = getPolylines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final points = <LatLng>[
      LatLng(51.5, -0.09),
      LatLng(53.3498, -6.2603),
      LatLng(48.8566, 2.3522),
    ];

    final pointsGradient = <LatLng>[
      LatLng(55.5, -0.09),
      LatLng(54.3498, -6.2603),
      LatLng(52.8566, 2.3522),
    ];

    final markers = tappedPoints.map((latlng) {
      return Marker(
        width: 180,
        height: 180,
        point: latlng,
        builder: (ctx) => const FlutterLogo(),
      );
    }).toList();

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Expanded(
//         Flexible(
//           child: SizedBox(
//             height: SizeConfig.screenHeight,
//             // Column(
//             //   crossAxisAlignment: CrossAxisAlignment.start,
//             //   children: [
//             //     Flexible(
//             child: FlutterMap(
//               options: MapOptions(
//                 center: LatLng(51.5, -0.09),
//                 zoom: 5,
//                 onTap: (tapPosition, point) {
//                   setState(() {
//                     debugPrint('onTap');
//                     polylines = getPolylines();
//                   });
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'dev.fleaflet.flutter_map.example',
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         PrimaryText(
    //           text: 'Balance',
    //           size: Responsive.isDesktop(context) ? 16 : 14,
    //           color: AppColors.secondary,
    //         ),
    //         PrimaryText(
    //           text: '\$1500',
    //           size: Responsive.isDesktop(context) ? 30 : 22,
    //           fontWeight: FontWeight.w800,
    //         ),
    //       ],
    //     ),
    //     PrimaryText(
    //       text: 'Past 30 Days',
    //       size: Responsive.isDesktop(context) ? 16 : 14,
    //       color: AppColors.secondary,
    //     )
    //   ],
    // ),

    return Expanded(
        // flex: 1,
        child: SizedBox(
            height: 200,
            // SizeConfig.screenHeight,
            child: FutureBuilder<List<Polyline>>(
              future: polylines,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Polyline>> snapshot) {
                debugPrint('snapshot: ${snapshot.hasData}');
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(top: 8, bottom: 8),
                      //   child: Text('Polylines'),
                      // ),
                      Flexible(
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(51.5, -0.09),
                            zoom: 5,
                            // onTap: _handleTap,
                            onTap: (tapPosition, point) {
                              setState(() {
                                debugPrint('onTap');
                                polylines = getPolylines();
                                // tappedPoints
                              });
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'dev.fleaflet.flutter_map.example',
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                    points: points,
                                    strokeWidth: 4,
                                    color: Colors.purple),
                              ],
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: pointsGradient,
                                  strokeWidth: 4,
                                  gradientColors: [
                                    const Color(0xffE40203),
                                    const Color(0xffFEED00),
                                    const Color(0xff007E2D),
                                  ],
                                ),
                              ],
                            ),
                            PolylineLayer(
                              polylines: snapshot.data!,
                              polylineCulling: true,
                            ),
                            const FlutterMapZoomButtons(
                              minZoom: 4,
                              maxZoom: 19,
                              mini: true,
                              padding: 10,
                              alignment: Alignment.bottomLeft,
                            ),
                            MarkerLayer(markers: markers),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const Text(
                    'Getting map data...\n\nTap on map when complete to refresh map data.');
              },
            )));
  }
}







//     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Column(children: [
//         FutureBuilder<List<Polyline>>(
//           future: polylines,
//           builder:
//               (BuildContext context, AsyncSnapshot<List<Polyline>> snapshot) {
//             debugPrint('snapshot: ${snapshot.hasData}');
//             if (snapshot.hasData) {
//               return Column(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(top: 8, bottom: 8),
//                     child: Text('Polylines'),
//                   ),
//                   Flexible(
//                     child: FlutterMap(
//                       options: MapOptions(
//                         center: LatLng(51.5, -0.09),
//                         zoom: 5,
//                         onTap: (tapPosition, point) {
//                           setState(() {
//                             debugPrint('onTap');
//                             polylines = getPolylines();
//                           });
//                         },
//                       ),
//                       children: [
//                         TileLayer(
//                           urlTemplate:
//                               'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                           userAgentPackageName:
//                               'dev.fleaflet.flutter_map.example',
//                         ),
//                         PolylineLayer(
//                           polylines: [
//                             Polyline(
//                                 points: points,
//                                 strokeWidth: 4,
//                                 color: Colors.purple),
//                           ],
//                         ),
//                         PolylineLayer(
//                           polylines: [
//                             Polyline(
//                               points: pointsGradient,
//                               strokeWidth: 4,
//                               gradientColors: [
//                                 const Color(0xffE40203),
//                                 const Color(0xffFEED00),
//                                 const Color(0xff007E2D),
//                               ],
//                             ),
//                           ],
//                         ),
//                         PolylineLayer(
//                           polylines: snapshot.data!,
//                           polylineCulling: true,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return const Text(
//                 'Getting map data...\n\nTap on map when complete to refresh map data.');
//           },
//         ),
//       ])
//     ]);
//   }
// }
