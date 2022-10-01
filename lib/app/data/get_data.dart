import 'dart:convert' as convert;
import 'dart:developer';
import 'package:google_maps_project/app/domain/entities/region_entity.dart';
import 'package:google_maps_project/utils/parse_functions.dart';
import 'package:http/http.dart' as http;

Future<List<RegionEntity>> getData() async {
  Map<String, dynamic> jsonResponse = {};
  List<RegionEntity> regionData = [];
  var response =
      await http.get(Uri.parse('https://api.data.gov.sg/v1/environment/psi'));

  if (response.statusCode == 200) {
    jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    regionData = parseToRegionData(response: jsonResponse);
  } else {
    log('Request failed with status: ${response.statusCode}.');
  }
  return regionData;

}