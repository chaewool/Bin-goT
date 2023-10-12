import 'package:bin_got/providers/api_provider.dart';
import 'package:bin_got/utilities/type_def_utils.dart';
import 'package:dio/dio.dart';

//? 빙고 api
class BingoProvider extends ApiProvider {
  //* public
  FutureDynamicMap readBingoDetail(int groupId, int bingoId) =>
      _readBingoDetail(groupId, bingoId);
  FutureDynamicMap editOwnBingo(int groupId, int bingoId, FormData bingoData) =>
      _editOwnBingo(groupId, bingoId, bingoData);

  FutureDynamicMap makeCompleteMessage(int groupId, FormData completeData) =>
      _makeCompleteMessage(groupId, completeData);

  //* detail
  FutureDynamicMap _readBingoDetail(int groupId, int bingoId) async {
    try {
      final response =
          await dioWithToken().get(bingoDetailUrl(groupId, bingoId));
      return response.data;
    } catch (error) {
      throw Error();
    }
  }

  //* update
  FutureDynamicMap _editOwnBingo(
      int groupId, int bingoId, FormData bingoData) async {
    try {
      await dioWithTokenForm()
          .put(editBingoUrl(groupId, bingoId), data: bingoData);
      return {};
    } catch (error) {
      throw Error();
    }
  }

  //* create chat
  FutureDynamicMap _makeCompleteMessage(
      int groupId, FormData completeData) async {
    try {
      print(groupReviewCreateUrl(groupId));
      final response = await dioWithTokenForm()
          .post(groupReviewCreateUrl(groupId), data: completeData);
      return response.data;
    } catch (error) {
      print(error);
      throw Error();
    }
  }
}
