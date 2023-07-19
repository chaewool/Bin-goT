import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

class BingoProvider extends ApiProvider {
  //* public
  FutureDynamicMap readBingoDetail(int bingoId) => _readBingoDetail(bingoId);
  // FutureInt createOwnBingo(FormData bingoData) => _createOwnBingo(bingoData);
  FutureDynamicMap editOwnBingo(int bingoId, FormData bingoData) =>
      _editOwnBingo(bingoId, bingoData);
  FutureDynamicMap deleteOwnBingo(int bingoId) => _deleteOwnBingo(bingoId);

  FutureDynamicMap makeCompleteMessage(int groupId, FormData completeData) =>
      _makeCompleteMessage(groupId, completeData);
  //* detail
  FutureDynamicMap _readBingoDetail(int bingoId) async {
    try {
      final response = await dioWithToken().get(bingoDetailUrl(bingoId));
      print('response: $response');

      return response.data;
      // return BingoDetailModel.fromJson(response.data);
    } catch (error) {
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      print(error);
      throw Error();
    }
  }

  //* create
  // FutureInt _createOwnBingo(FormData bingoData) async {
  //   try {
  //     final dioWithForm = dioWithToken();
  //     dioWithForm.options.contentType = 'multipart/form-data';
  //     print(createBingoUrl);
  //     final response = await dioWithForm.post(createBingoUrl, data: bingoData);
  //     print(response);
  //     if (response.statusCode == 200) {
  //       return response.data['board_id'];
  //     }
  //     throw Error();
  //   } catch (error) {
  //     print(error);
  //     throw Error();
  //   }
  // }

  //* update
  FutureDynamicMap _editOwnBingo(int bingoId, FormData bingoData) async {
    try {
      await dioWithTokenForm().put(editBingoUrl(bingoId), data: bingoData);

      return {};
    } catch (error) {
      print(error);
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      throw Error();
    }
  }

  //* create chat
  FutureDynamicMap _makeCompleteMessage(
      int groupId, FormData completeData) async {
    try {
      final response = await dioWithTokenForm()
          .post(groupReviewCreateUrl(groupId), data: completeData);

      return response.data;
    } catch (error) {
      print(error);
      if (error.toString().contains('401')) {
        return {'statusCode': 401};
      }
      throw Error();
    }
  }

  //* delete
  FutureDynamicMap _deleteOwnBingo(int bingoId) =>
      deleteApi(deleteBingoUrl(bingoId));
}
