import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/supervisor_model.dart';

class SupervisorService {

  Future<List<SupervisorModel>> getSupervisors() async {

    final response = await http.get(
      Uri.parse("API_LINK_HERE"),
    );

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);

      List list = data["supervisors"];

      return list
          .map((e)=>SupervisorModel.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load supervisors");
  }
}