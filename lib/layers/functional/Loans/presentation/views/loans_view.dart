import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Loans/presentation/cubit/loans_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

typedef LoanTerms = ({String borrower, DateTime? dueOn, bool remindsAtDue, bool followsUp});

Future<LoanTerms?> askLoanTerms(BuildContext context, {DateTime Function()? now}) => showModalBottomSheet<LoanTerms>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _LoanSheet(today: (now ?? DateTime.now)()),
    );

class _LoanSheet extends StatefulWidget {
  const _LoanSheet({required this.today});

  final DateTime today;

  @override
  State<_LoanSheet> createState() => _LoanSheetState();
}

class _LoanSheetState extends State<_LoanSheet> {
  final TextEditingController _borrower = TextEditingController();
  late DateTime? _dueOn = DateTime(widget.today.year, widget.today.month, widget.today.day + 14);
  bool _remindsAtDue = true;
  bool _followsUp = true;

  @override
  void dispose() {
    _borrower.dispose();
    super.dispose();
  }

  DateTime _inDays(int days) => DateTime(widget.today.year, widget.today.month, widget.today.day + days);

  void _submit() {
    if (_borrower.text.trim().isEmpty) {
      return;
    }
    Navigator.of(context).pop((borrower: _borrower.text.trim(), dueOn: _dueOn, remindsAtDue: _remindsAtDue, followsUp: _followsUp));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shortcuts = [(l10n.loanInOneWeek, 7), (l10n.loanInTwoWeeks, 14), (l10n.loanInOneMonth, 30)];
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 16 + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.lendCopy, style: AkashicTypography.displayTitle(size: 24)),
            const SizedBox(height: 12),
            TextField(
              controller: _borrower,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(labelText: l10n.borrowerName),
            ),
            const SizedBox(height: 14),
            Text(l10n.loanReturnBy, style: AkashicTypography.body(size: 14, weight: FontWeight.w800)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (label, days) in shortcuts)
                  ChoiceChip(label: Text(label), selected: _dueOn == _inDays(days), onSelected: (_) => setState(() => _dueOn = _inDays(days))),
                ChoiceChip(label: Text(l10n.loanNoDate), selected: _dueOn == null, onSelected: (_) => setState(() => _dueOn = null)),
                ActionChip(
                  avatar: const Icon(Icons.event, size: 16),
                  label: Text(_dueOn == null || shortcuts.any((shortcut) => _inDays(shortcut.$2) == _dueOn) ? l10n.loanPickDate : DateFormat.yMMMd(l10n.localeName).format(_dueOn!)),
                  onPressed: () async {
                    final picked = await showDatePicker(context: context, initialDate: _dueOn ?? _inDays(14), firstDate: widget.today, lastDate: _inDays(730));
                    if (picked != null) {
                      setState(() => _dueOn = picked);
                    }
                  },
                ),
              ],
            ),
            if (_dueOn case final due?)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(l10n.loanDueOn(DateFormat.yMMMMEEEEd(l10n.localeName).format(due)), style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: AkashicColors.teal)),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _remindsAtDue && _dueOn != null,
              onChanged: _dueOn == null ? null : (value) => setState(() => _remindsAtDue = value),
              title: Text(l10n.loanRemindAtDue, style: AkashicTypography.body(weight: FontWeight.w700)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _followsUp && _dueOn != null,
              onChanged: _dueOn == null ? null : (value) => setState(() => _followsUp = value),
              title: Text(l10n.loanFollowUp, style: AkashicTypography.body(weight: FontWeight.w700)),
              subtitle: Text(l10n.loanFollowUpHelp),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _submit, child: Text(l10n.lendCopy)),
          ],
        ),
      ),
    );
  }
}

class LoansView extends StatelessWidget {
  const LoansView({required this.onOpenItem, super.key});

  final ValueChanged<String> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loansCubit = context.read<LoansCubit>();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return BlocBuilder<LoansCubit, LoansState>(
      builder: (context, state) {
        final ordered = [
          ...state.visibleLoans.where((loan) => loan.daysLateOn(today) != null),
          ...state.visibleLoans.where((loan) => loan.daysLateOn(today) == null),
        ];
        return Scaffold(
          appBar: AppBar(title: Text(l10n.loans, style: AkashicTypography.displayTitle(size: 26))),
          body: state.isLoading
              ? const AkashicLoader()
              : state.loans.isEmpty
                  ? Center(child: AkashicEmptyState(message: l10n.noLoans))
                  : ListView(
                      padding: safeListPadding(context),
                      children: [
                        TextField(
                          onChanged: loansCubit.search,
                          decoration: InputDecoration(hintText: l10n.searchLoans, prefixIcon: const Icon(Icons.search)),
                        ),
                        const SizedBox(height: 8),
                        if (state.visibleLoans.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(l10n.noLoanMatches, textAlign: TextAlign.center, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
                          ),
                        for (final (index, loan) in ordered.indexed) ...[
                          if (index == 0 || (ordered[index - 1].daysLateOn(today) != null) != (loan.daysLateOn(today) != null))
                            Padding(
                              padding: const EdgeInsets.only(top: 14, bottom: 2),
                              child: Row(
                                children: [
                                  if (loan.daysLateOn(today) != null) ...[const Icon(Icons.schedule, size: 16, color: AkashicColors.coral), const SizedBox(width: 6)],
                                  Text(
                                    (loan.daysLateOn(today) != null ? l10n.loansLate : l10n.loansOngoing).toUpperCase(),
                                    style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: loan.daysLateOn(today) != null ? AkashicColors.coral : AkashicColors.textSoft, letterSpacing: 1.1),
                                  ),
                                ],
                              ),
                            ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              resolveDisplayTitle(loan.itemTitles, state.preferredLanguages) ?? l10n.untitled,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AkashicTypography.body(size: 15, weight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              switch ((loan.daysLateOn(today), loan.dueOn)) {
                                (final days?, _) => l10n.loanLateBy(loan.borrower, days),
                                (null, final due?) => l10n.loanDueBy(loan.borrower, DateFormat.yMMMd(l10n.localeName).format(due)),
                                _ => l10n.lentToSince(loan.borrower, DateFormat.yMMMd(l10n.localeName).format(loan.since)),
                              },
                              style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: loan.daysLateOn(today) != null ? AkashicColors.coral : AkashicColors.teal),
                            ),
                            trailing: TextButton(onPressed: () => loansCubit.markReturned(loan.copyId), child: Text(l10n.returnCopy)),
                            onTap: () => onOpenItem(loan.itemId),
                          ),
                        ],
                      ],
                    ),
        );
      },
    );
  }
}
