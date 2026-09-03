import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../settings/presentation/widgets/settings_panel.dart';
import '../../tasks/presentation/widgets/tasks_section.dart';
import '../../tasks/viewmodels/tasks_view_model.dart';
import '../../timer/presentation/widgets/timer_card.dart';
import '../../timer/viewmodels/timer_view_model.dart';
import '../viewmodels/app_shell_view_model.dart';
import 'widgets/top_bar.dart';

class PomodoroHomePage extends StatelessWidget {
  const PomodoroHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<TimerViewModel, AppShellViewModel, TasksViewModel>(
      builder: (context, timerViewModel, shellViewModel, tasksViewModel, _) {
        final backgroundColor =
            Color(timerViewModel.mode.backgroundColorValue);

        return Title(
          color: backgroundColor,
          title: timerViewModel.windowTitle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            color: backgroundColor,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final horizontalPadding =
                            constraints.maxWidth < AppLayout.mobileBreakpoint
                                ? AppLayout.mobileHorizontalPadding
                                : AppLayout.desktopHorizontalPadding;

                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 14,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: AppLayout.maxContentWidth,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TopBar(
                                    onSettingsPressed:
                                        shellViewModel.openSettings,
                                  ),
                                  const SizedBox(height: 34),
                                  TimerCard(
                                    activeTaskTitle:
                                        tasksViewModel.activeTask?.title,
                                  ),
                                  const SizedBox(height: 28),
                                  const TasksSection(),
                                  const SizedBox(height: 48),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (shellViewModel.isSettingsOpen)
                    SettingsPanelOverlay(
                      onClose: shellViewModel.closeSettings,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
