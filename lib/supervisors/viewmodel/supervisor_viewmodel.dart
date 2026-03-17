import 'package:flutter/material.dart';
import '../data/supervisor_service.dart';
import '../model/supervisor_model.dart';

class SupervisorViewModel extends ChangeNotifier {

  final SupervisorService _service = SupervisorService();

  List<SupervisorModel> supervisors = [];

  String filter = "all";

  Future<void> loadSupervisors() async {

    supervisors = await _service.getSupervisors();

    notifyListeners();
  }

  void addSupervisor(SupervisorModel supervisor) {

    supervisors.add(supervisor);

    notifyListeners();
  }

  void editSupervisor(int index , SupervisorModel s){

    supervisors[index] = s;

    notifyListeners();
  }

  void changeFilter(String f){

    filter = f;

    notifyListeners();
  }

  List<SupervisorModel> get filtered{

    if(filter == "sweeping"){

      return supervisors.where((e)=>e.type=="sweeping").toList();
    }

    if(filter == "lifting"){

      return supervisors.where((e)=>e.type=="lifting").toList();
    }

    return supervisors;
  }

  int get sweepingCount =>
      supervisors.where((e)=>e.type=="sweeping").length;

  int get liftingCount =>
      supervisors.where((e)=>e.type=="lifting").length;

}