import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:equatable/equatable.dart';

enum CopyEditorStatus { editing, saving, saved, failed, deleting, deleted }

typedef CopySaleDraft = ({int priceCents, DateTime soldOn, TradeChannel? channel});

class CopyEditorState extends Equatable {
  const CopyEditorState({
    required this.parts,
    required this.edition,
    required this.priceText,
    required this.location,
    required this.conditions,
    this.tracksSealing = false,
    this.isOpened = false,
    this.purchasedOn,
    this.purchaseChannel,
    this.priceError = false,
    this.status = CopyEditorStatus.editing,
    this.isLastCopy = false,
    this.deletion,
  });

  final List<String> parts;
  final String edition;
  final String priceText;
  final String location;
  final Map<String, ItemCondition> conditions;
  final bool tracksSealing;
  final bool isOpened;
  final DateTime? purchasedOn;
  final TradeChannel? purchaseChannel;
  final bool priceError;
  final CopyEditorStatus status;
  final bool isLastCopy;
  final CopyDeletion? deletion;

  CopyEditorState copyWith({
    String? edition,
    String? priceText,
    String? location,
    Map<String, ItemCondition>? conditions,
    bool? isOpened,
    DateTime? Function()? purchasedOn,
    TradeChannel? Function()? purchaseChannel,
    bool? priceError,
    CopyEditorStatus? status,
    bool? isLastCopy,
    CopyDeletion? deletion,
  }) {
    return CopyEditorState(
      parts: parts,
      edition: edition ?? this.edition,
      priceText: priceText ?? this.priceText,
      location: location ?? this.location,
      conditions: conditions ?? this.conditions,
      tracksSealing: tracksSealing,
      isOpened: isOpened ?? this.isOpened,
      purchasedOn: purchasedOn == null ? this.purchasedOn : purchasedOn(),
      purchaseChannel: purchaseChannel == null ? this.purchaseChannel : purchaseChannel(),
      priceError: priceError ?? false,
      status: status ?? CopyEditorStatus.editing,
      isLastCopy: isLastCopy ?? this.isLastCopy,
      deletion: deletion ?? this.deletion,
    );
  }

  @override
  List<Object?> get props => [parts, edition, priceText, location, conditions, tracksSealing, isOpened, purchasedOn, purchaseChannel, priceError, status, isLastCopy, deletion];
}
