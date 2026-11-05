import 'dart:async';

import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';

class WishFulfillmentListener extends StatefulWidget {
  const WishFulfillmentListener({required this.fulfilledWishes, required this.child, super.key});

  final Stream<List<Wish>> fulfilledWishes;
  final Widget child;

  @override
  State<WishFulfillmentListener> createState() => _WishFulfillmentListenerState();
}

class _WishFulfillmentListenerState extends State<WishFulfillmentListener> {
  StreamSubscription<List<Wish>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.fulfilledWishes.listen(_announce);
  }

  void _announce(List<Wish> fulfilled) {
    if (!mounted) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final message = fulfilled.length == 1 ? l10n.wishFulfilled(fulfilled.single.displayTitle(l10n)) : l10n.wishesFulfilled(fulfilled.length);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
