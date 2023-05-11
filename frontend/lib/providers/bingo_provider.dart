import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

class BingoProvider extends ApiProvider {
  //* public
  Future<DynamicMap> readBingoDetail(int bingoId) => _readBingoDetail(bingoId);
  FutureInt createOwnBingo(FormData bingoData) => _createOwnBingo(bingoData);

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
}
