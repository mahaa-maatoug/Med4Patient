import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Ordonnance.dart';


class OrdonnanceService extends GetxService {



  final String baseUrl = 'http://10.0.2.2:3000/prescription';

  Future<List<Ordonnance>> getAllOrdonnances() async {
  final response = await http.get(
  Uri.parse('$baseUrl/getAll'), // Updated endpoint
  headers: await _getHeaders(),
  );
  if (response.statusCode == 200) {
  return (json.decode(response.body) as List)
      .map((item) => Ordonnance.fromJson(item))
      .toList();
  } else {
  throw Exception('Failed to load ordonnances: ${response.statusCode}');
  }
  }

  Future<Ordonnance> createOrdonnanceWithFiles({
  required List<File> files,
  String? note,
  }) async {
  try {
  var request = http.MultipartRequest(
  'POST',
  Uri.parse('$baseUrl/add'), // Updated endpoint
  );

  // Add files with the correct field name 'storagePath'
  for (var file in files) {
  request.files.add(await http.MultipartFile.fromPath(
  'storagePath',
  file.path,
  contentType: MediaType('application', 'octet-stream'),
  ));
  }

  // Add form fields
  request.fields.addAll({
  'prescriptionStatus': PrescriptionStatus.UPLOADED.toString().split('.').last,
  if (note != null) 'note': note,
  });

  // Add headers
  request.headers.addAll(await _getHeaders());

  final response = await request.send();
  final responseData = await response.stream.bytesToString();

  if (response.statusCode == 201) {
  return Ordonnance.fromJson(json.decode(responseData));
  } else {
  throw Exception('Failed to create ordonnance: ${response.statusCode} - $responseData');
  }
  } catch (e) {
  throw Exception('Failed to upload files: ${e.toString()}');
  }
  }

  Future<Ordonnance> getOrdonnanceById(String id) async {
  final response = await http.get(
  Uri.parse('$baseUrl/getById/$id'), // Updated endpoint
  headers: await _getHeaders(),
  );
  if (response.statusCode == 200) {
  return Ordonnance.fromJson(json.decode(response.body));
  } else {
  throw Exception('Failed to get ordonnance: ${response.statusCode}');
  }
  }

  Future<Ordonnance> updateOrdonnance({
  required String id,
  String? note,
  PrescriptionStatus? prescriptionStatus,
  }) async {
  final response = await http.put(
  Uri.parse('$baseUrl/update/$id'), // Updated endpoint
  headers: await _getHeaders(),
  body: json.encode({
  if (note != null) 'note': note,
  if (prescriptionStatus != null)
  'prescriptionStatus': prescriptionStatus.toString().split('.').last,
  }),
  );

  if (response.statusCode == 200) {
  return Ordonnance.fromJson(json.decode(response.body));
  } else {
  throw Exception('Failed to update ordonnance: ${response.statusCode}');
  }
  }

  Future<void> deleteOrdonnance(String id) async {
  final response = await http.delete(
  Uri.parse('$baseUrl/delete/$id'), // Updated endpoint (fixed missing / before id)
  headers: await _getHeaders(),
  );
  if (response.statusCode != 200) {
  throw Exception('Failed to delete ordonnance: ${response.statusCode}');
  }
  }

  Future<void> downloadFile(String filename) async {
  final response = await http.get(
  Uri.parse('$baseUrl/download/$filename'), // Updated endpoint
  headers: await _getHeaders(),
  );

  if (response.statusCode == 200) {
  // Handle file download
  // You might want to use the download manager or save to device storage
  } else {
  throw Exception('Failed to download file: ${response.statusCode}');
  }
  }

  Future<Map<String, String>> _getHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  return {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
  };
  }
  Future<List<Ordonnance>> getPrescriptionHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final formattedStart = _formatDate(startDate);
    final formattedEnd = _formatDate(endDate);

    final response = await http.get(
      Uri.parse('$baseUrl/history?startDate=$formattedStart&endDate=$formattedEnd'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ordonnance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load prescription history: ${response.statusCode}');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  }