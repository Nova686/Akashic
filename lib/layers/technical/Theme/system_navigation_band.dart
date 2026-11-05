import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final ValueNotifier<int> _immersiveScreenCount = ValueNotifier(0);

void _changeImmersiveScreenCount(int change) {
  SchedulerBinding.instance.addPostFrameCallback((_) => _immersiveScreenCount.value += change);
  SchedulerBinding.instance.ensureVisualUpdate();
}

class SystemNavigationBand extends StatelessWidget {
  const SystemNavigationBand({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bandHeight = MediaQuery.viewPaddingOf(context).bottom;
    final theme = Theme.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: _immersiveScreenCount,
      child: child,
      builder: (context, immersiveScreens, content) => Stack(
        children: [
          ?content,
          if (bandHeight > 0 && immersiveScreens == 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: bandHeight,
              child: IgnorePointer(child: ColoredBox(color: theme.navigationBarTheme.backgroundColor ?? theme.colorScheme.surfaceContainer)),
            ),
        ],
      ),
    );
  }
}

class ImmersiveSystemBars extends StatefulWidget {
  const ImmersiveSystemBars({required this.child, super.key});

  final Widget child;

  @override
  State<ImmersiveSystemBars> createState() => _ImmersiveSystemBarsState();
}

class _ImmersiveSystemBarsState extends State<ImmersiveSystemBars> {
  bool _isCounted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isShown = TickerMode.valuesOf(context).enabled;
    if (isShown != _isCounted) {
      _isCounted = isShown;
      _changeImmersiveScreenCount(isShown ? 1 : -1);
    }
  }

  @override
  void dispose() {
    if (_isCounted) {
      _changeImmersiveScreenCount(-1);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
