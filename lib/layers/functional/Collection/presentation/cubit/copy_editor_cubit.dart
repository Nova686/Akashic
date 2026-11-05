import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/parse_price_to_cents.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_copy.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/copy_editor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CopyEditorCubit extends Cubit<CopyEditorState> {
  CopyEditorCubit(this._updateCopy, this._copy, {required List<String> parts, this._deleteCopy, this._sellCopy, bool tracksSealing = false})
      : super(CopyEditorState(
          parts: parts,
          edition: _copy.edition ?? '',
          priceText: _copy.pricePaidCents == null ? '' : _formatCents(_copy.pricePaidCents!),
          location: _copy.location ?? '',
          conditions: _copy.conditions,
          tracksSealing: tracksSealing,
          isOpened: _copy.isOpened,
          purchasedOn: _copy.purchasedOn,
          purchaseChannel: _copy.purchaseChannel,
        ));

  final UpdateCopy _updateCopy;
  final ItemCopy _copy;
  final DeleteCopy? _deleteCopy;
  final Future<CopyDeletion> Function(ItemCopy copy, CopySaleDraft sale)? _sellCopy;

  bool get canDelete => _deleteCopy != null;

  bool get canSell => _sellCopy != null;

  Future<void> start() async {
    final deleteCopy = _deleteCopy;
    if (deleteCopy == null) {
      return;
    }
    final isLastCopy = await deleteCopy.isLastCopy(_copy);
    if (!isClosed) {
      emit(state.copyWith(isLastCopy: isLastCopy, status: state.status));
    }
  }

  Future<void> delete() async {
    final deleteCopy = _deleteCopy;
    if (deleteCopy == null || state.status == CopyEditorStatus.deleting) {
      return;
    }
    emit(state.copyWith(status: CopyEditorStatus.deleting));
    final deletion = await deleteCopy(_copy);
    if (!isClosed) {
      emit(state.copyWith(status: CopyEditorStatus.deleted, deletion: deletion));
    }
  }

  Future<void> sell(CopySaleDraft sale) async {
    final sellCopy = _sellCopy;
    if (sellCopy == null || state.status == CopyEditorStatus.deleting) {
      return;
    }
    emit(state.copyWith(status: CopyEditorStatus.deleting));
    int? priceCents;
    try {
      priceCents = parsePriceToCents(state.priceText);
    } on InvalidPrice {
      priceCents = _copy.pricePaidCents;
    }
    final deletion = await sellCopy(_copyFromState(priceCents), sale);
    if (!isClosed) {
      emit(state.copyWith(status: CopyEditorStatus.deleted, deletion: deletion));
    }
  }

  static String _formatCents(int cents) {
    final units = cents ~/ 100;
    final remainder = cents % 100;
    return remainder == 0 ? '$units' : '$units,${remainder.toString().padLeft(2, '0')}';
  }

  void setEdition(String edition) => emit(state.copyWith(edition: edition));

  void setPriceText(String priceText) => emit(state.copyWith(priceText: priceText));

  void setLocation(String location) => emit(state.copyWith(location: location));

  void setOpened(bool isOpened) => emit(state.copyWith(isOpened: isOpened));

  void setPurchasedOn(DateTime? purchasedOn) => emit(state.copyWith(purchasedOn: () => purchasedOn));

  void setPurchaseChannel(TradeChannel? channel) => emit(state.copyWith(purchaseChannel: () => channel));

  void setCondition(String part, ItemCondition? condition) {
    final conditions = {...state.conditions};
    if (condition == null) {
      conditions.remove(part);
    } else {
      conditions[part] = condition;
    }
    emit(state.copyWith(conditions: conditions));
  }

  Future<void> save() async {
    final int? priceCents;
    try {
      priceCents = parsePriceToCents(state.priceText);
    } on InvalidPrice {
      emit(state.copyWith(priceError: true));
      return;
    }
    emit(state.copyWith(status: CopyEditorStatus.saving));
    try {
      await _updateCopy(_copyFromState(priceCents));
    } on Exception {
      if (!isClosed) {
        emit(state.copyWith(status: CopyEditorStatus.failed));
      }
      return;
    }
    if (!isClosed) {
      emit(state.copyWith(status: CopyEditorStatus.saved));
    }
  }

  ItemCopy _copyFromState(int? priceCents) => ItemCopy(
        id: _copy.id,
        itemId: _copy.itemId,
        edition: state.edition.trim().isEmpty ? null : state.edition.trim(),
        pricePaidCents: priceCents,
        location: state.location.trim().isEmpty ? null : state.location.trim(),
        conditions: state.conditions,
        barcode: _copy.barcode,
        externalEditionId: _copy.externalEditionId,
        loanedTo: _copy.loanedTo,
        loanedSince: _copy.loanedSince,
        isOpened: state.isOpened,
        purchasedOn: state.purchasedOn,
        purchaseChannel: state.purchaseChannel,
      );
}
