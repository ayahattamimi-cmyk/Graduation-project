import 'package:dio/dio.dart';

class ContainerService {
  final Dio _dio;
  ContainerService(this._dio);

  // جلب كل الحاويات (المفرزة كمربعات من السيرفر)
  Future<Response> getAllContainers() async =>
      await _dio.get('/showAllContainers');

  Future<Response> createContainer(Map<String, dynamic> data) async =>
      await _dio.post('/createContainer', data: data);

  Future<Response> deleteContainer(int id) async =>
      await _dio.delete('/destroyContainer/$id');

  Future<Response> getStatistics() async => await _dio.get('/CountStatistics');

  Future<Response> updateContainer(int id, Map<String, dynamic> data) async {
    return await _dio.post('/updateContainer/$id', data: data);
  }
}
