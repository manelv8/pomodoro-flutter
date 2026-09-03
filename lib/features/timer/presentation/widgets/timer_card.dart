import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/pomodoro_mode.dart';
import '../../viewmodels/timer_view_model.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({
    super.key,
    this.activeTaskTitle,
  });

  final String? activeTaskTitle;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(
      builder: (context, timerViewModel, _) {
        final isCompact =
            MediaQuery.sizeOf(context).width < AppLayout.mobileBreakpoint;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.timerCardMaxWidth,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 18 : 32,
                  vertical: isCompact ? 20 : 24,
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: PomodoroMode.values
                          .map(
                            (mode) => _ModeChip(
                              label: mode.label,
                              isSelected: timerViewModel.mode == mode,
                              onTap: () => timerViewModel.setMode(mode),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: isCompact ? 26 : 34),
                    Text(
                      formatClock(timerViewModel.remainingSeconds),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: isCompact ? 88 : 124,
                            height: 0.9,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: isCompact ? 26 : 30),
                    SizedBox(
                      width: isCompact ? 220 : 260,
                      child: FilledButton(
                        onPressed: timerViewModel.toggleRunning,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFBA4949),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          timerViewModel.isRunning ? 'PAUSE' : 'START',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '#${timerViewModel.currentRound}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activeTaskTitle ?? 'Time to focus',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: timerViewModel.resetCurrentMode,
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                      child: const Text('Reset Timer'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.black.withValues(alpha: 0.16) : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
