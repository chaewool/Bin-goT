import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

class BingoProvider extends ApiProvider {
  //* public
  Future<DynamicMap> readBingoDetail(int bingoId) => _readBingoDetail(bingoId);
  FutureInt createOwnBingo(FormData bingoData) => _createOwnBingo(bingoData);
  FutureDynamicMap editOwnBingo(int bingoId, FormData bingoData) =>
      _editOwnBingo(bingoId, bingoData);
  FutureDynamicMap deleteOwnBingo(int bingoId) => _deleteOwnBingo(bingoId);

  //* detail
  Future<DynamicMap> _readBingoDetail(int bingoId) async {
    try {
      final response = await dioWithToken().get(
        bingoDetailUrl(bingoId),
      );
      print('response: $response');
      switch (response.statusCode) {
        case 200:
          return response.data;
        // return BingoDetailModel.fromJson(response.data);
        default:
          throw Error();
      }
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* create
  FutureInt _createOwnBingo(FormData bingoData) async {
    try {
      final dioWithForm = dioWithToken();
      dioWithForm.options.contentType = 'multipart/form-data';
      final response = await dioWithForm.post(createBingoUrl, data: bingoData);
      print(response);
      if (response.statusCode == 200) {
        return response.data['board_id'];
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* update
  Future<DynamicMap> _editOwnBingo(int bingoId, FormData bingoData) async {
    try {
      final dioWithForm = dioWithToken();
      dioWithForm.options.contentType = 'multipart/form-data';
      final response =
          await dioWithForm.put(editBingoUrl(bingoId), data: bingoData);
      if (response.statusCode == 200) {
        return {};
      }
      throw Error();
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* delete
  FutureDynamicMap _deleteOwnBingo(int bingoId) async {
    try {
      final response = await deleteApi(deleteBingoUrl(bingoId));
      return {};
    } catch (error) {
      print(error);
      throw Error();
    }
  }
}
