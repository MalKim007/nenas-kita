import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nenas_kita/core/constants/enums.dart';
import 'package:nenas_kita/core/utils/firestore_converters.dart';

part 'buyer_request_model.freezed.dart';
part 'buyer_request_model.g.dart';

@freezed
class BuyerRequestModel with _$BuyerRequestModel {
  const factory BuyerRequestModel({
    required String id,
    required String buyerId,
    required String buyerName,
    String? buyerPhone,
    required ProductCategory category,
    String? variety,
    required double quantityKg,
    String? deliveryDistrict,
    @NullableTimestampConverter() DateTime? neededByDate,
    required RequestStatus status,
    String? fulfilledByFarmId,
    String? fulfilledByFarmName,
    @NullableTimestampConverter() DateTime? fulfilledAt,
    @TimestampConverter() required DateTime createdAt,
  }) = _BuyerRequestModel;

  factory BuyerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BuyerRequestModelFromJson(json);

  factory BuyerRequestModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BuyerRequestModel.fromJson({...data, 'id': doc.id});
  }
}

extension BuyerRequestModelExtension on BuyerRequestModel {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  /// Check if request is still open
  bool get isOpen => status == RequestStatus.open;

  /// Check if request is fulfilled
  bool get isFulfilled => status == RequestStatus.fulfilled;

  /// Check if request is urgent (needed within 3 days)
  bool get isUrgent =>
      neededByDate != null &&
      neededByDate!.difference(DateTime.now()).inDays <= 3 &&
      isOpen;

  /// Check if request deadline has passed
  bool get isExpired =>
      neededByDate != null && neededByDate!.isBefore(DateTime.now()) && isOpen;

  /// Days until needed
  int? get daysUntilNeeded =>
      neededByDate?.difference(DateTime.now()).inDays;
}
