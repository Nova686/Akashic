import 'dart:async';

import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/build_discoveries.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/dismiss_suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_state.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoveriesCubit extends Cubit<DiscoveriesState> {
  DiscoveriesCubit({
    required this._buildDiscoveries,
    required this._dismissSuggestion,
    required this._wishes,
    required this._addWish,
    required this._languageCode,
    required this._preferredLanguages,
    DateTime Function()? now,
    this._staleAfter = const Duration(days: 7),
  })  : _now = now ?? DateTime.now,
        super(const DiscoveriesState());

  final BuildDiscoveries _buildDiscoveries;
  final DismissSuggestion _dismissSuggestion;
  final WishGateway _wishes;
  final AddWish _addWish;
  final String Function() _languageCode;
  final Future<PreferredLanguages> Function() _preferredLanguages;
  final DateTime Function() _now;
  final Duration _staleAfter;
  StreamSubscription<List<Wish>>? _wishesSubscription;
  StreamSubscription<Set<String>>? _ownedSubscription;

  Future<void> start() async {
    _wishesSubscription = _wishes.watchAll().listen((wishes) {
      if (!isClosed) {
        emit(state.copyWith(wishedIdentities: {
          for (final wish in wishes)
            if (wish.key.hasSourceIdentity) sourceIdentityOf(wish.key.sourceKey!, wish.key.externalWorkId!),
        }));
      }
    });
    _ownedSubscription = _buildDiscoveries.watchOwnedIdentities().listen((owned) {
      if (!isClosed) {
        emit(state.copyWith(ownedIdentities: owned));
      }
    });
    final cached = await _buildDiscoveries.cached();
    if (isClosed) {
      return;
    }
    emit(state.copyWith(discoveries: cached, isLoading: cached == null));
    if (cached == null || _now().difference(cached.computedAt) > _staleAfter) {
      await refresh();
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) {
      return;
    }
    emit(state.copyWith(isRefreshing: true));
    try {
      final discoveries = await _buildDiscoveries(languageCode: _languageCode(), preferredLanguages: await _preferredLanguages());
      if (!isClosed) {
        emit(state.copyWith(discoveries: discoveries, isOffline: false, typeFilter: () => _keptFilter(discoveries)));
      }
    } on DiscoveriesUnavailable {
      ErrorToasts.instance.show((l10n) => l10n.discoveriesFailedToast);
      if (!isClosed) {
        emit(state.copyWith(isOffline: true));
      }
    } on Exception catch (failure) {
      ErrorToasts.instance.showUnexpected(failure);
      if (!isClosed) {
        emit(state.copyWith(isOffline: true));
      }
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, isRefreshing: false));
      }
    }
  }

  CategoryType? _keptFilter(Discoveries discoveries) {
    final filter = state.typeFilter;
    return discoveries.groups.any((group) => group.categoryType == filter) ? filter : null;
  }

  void filterBy(CategoryType? type) => emit(state.copyWith(typeFilter: () => type));

  void search(String query) => emit(state.copyWith(query: query));

  void toggleHidesWished() => emit(state.copyWith(hidesWished: !state.hidesWished));

  void toggleRecentOnly() => emit(state.copyWith(recentOnly: !state.recentOnly));

  void resetFilters() => emit(state.copyWith(typeFilter: () => null, query: '', hidesWished: false, recentOnly: false));

  Future<void> dismiss(Suggestion suggestion) async {
    final current = state.discoveries;
    if (current != null) {
      emit(state.copyWith(discoveries: current.withoutSuggestion(suggestion)));
    }
    await _dismissSuggestion(suggestion);
  }

  Future<void> wish(SuggestionGroup group, Suggestion suggestion) async {
    if (state.isWished(suggestion)) {
      return;
    }
    emit(state.copyWith(wishedIdentities: {...state.wishedIdentities, suggestion.sourceIdentity}));
    await _addWish(WishDraft(
      categoryType: group.categoryType,
      title: suggestion.title,
      creator: suggestion.creator,
      imageUrl: suggestion.imageUrl,
      origin: WishOrigin.discovery,
      key: WishKey(sourceKey: suggestion.sourceKey, externalWorkId: suggestion.externalWorkId),
    ));
  }

  @override
  Future<void> close() async {
    await _wishesSubscription?.cancel();
    await _ownedSubscription?.cancel();
    return super.close();
  }
}
