import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

class BingoProvider extends ApiProvider {
  //* public
  FutureDynamicMap readBingoDetail(int groupId, int bingoId) =>
      _readBingoDetail(groupId, bingoId);
  // FutureInt createOwnBingo(FormData bingoData) => _createOwnBingo(bingoData);
  FutureDynamicMap editOwnBingo(int groupId, int bingoId, FormData bingoData) =>
      _editOwnBingo(groupId, bingoId, bingoData);
  // FutureDynamicMap deleteOwnBingo(int bingoId) => _deleteOwnBingo(bingoId);

  FutureDynamicMap makeCompleteMessage(int groupId, FormData completeData) =>
      _makeCompleteMessage(groupId, completeData);
  //* detail
  FutureDynamicMap _readBingoDetail(int groupId, int bingoId) async {
    try {
      final response =
          await dioWithToken().get(bingoDetailUrl(groupId, bingoId));
      print('response: $response');

      return response.data;
      // return BingoDetailModel.fromJson(response.data);
    } catch (error) {
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
  FutureDynamicMap _editOwnBingo(
      int groupId, int bingoId, FormData bingoData) async {
    try {
      await dioWithTokenForm()
          .put(editBingoUrl(groupId, bingoId), data: bingoData);

      return {};
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* create chat
  FutureDynamicMap _makeCompleteMessage(
      int groupId, FormData completeData) async {
    try {
      final response = await dioWithTokenForm()
          .post(groupReviewCreateUrl(groupId), data: completeData);
      print('------------ response => $response');
      return response.data;
    } catch (error) {
      print(error);
      throw Error();
    }
  }

  //* delete
  // FutureDynamicMap _deleteOwnBingo(int bingoId) =>
  //     deleteApi(deleteBingoUrl(bingoId));
}
