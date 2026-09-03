import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/settings_view_model.dart';

class SettingsPanelOverlay extends StatelessWidget {
  const SettingsPanelOverlay({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            height: double.infinity,
            color: const Color(0xFFF6F3F1),
            child: SafeArea(
              child: Consumer<SettingsViewModel>(
                builder: (context, settingsViewModel, _) {
                  final settings = settingsViewModel.settings;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'SETTINGS',
                                style: TextStyle(
                                  color: Color(0xFF8C8580),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onClose,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            const _SectionTitle('Timer'),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _StepperField(
                                    label: 'Pomodoro',
                                    value: settings.pomodoroMinutes,
                                    min: 1,
                                    max: 180,
                                    onChanged: (value) => settingsViewModel.update(
                                      pomodoroMinutes: value,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StepperField(
                                    label: 'Short Break',
                                    value: settings.shortBreakMinutes,
                                    min: 1,
                                    max: 60,
                                    onChanged: (value) => settingsViewModel.update(
                                      shortBreakMinutes: value,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StepperField(
                                    label: 'Long Break',
                                    value: settings.longBreakMinutes,
                                    min: 1,
                                    max: 90,
                                    onChanged: (value) => settingsViewModel.update(
                                      longBreakMinutes: value,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _SwitchTile(
                              title: 'Auto Start Breaks',
                              value: settings.autoStartBreaks,
                              onChanged: (value) => settingsViewModel.update(
                                autoStartBreaks: value,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SwitchTile(
                              title: 'Auto Start Pomodoros',
                              value: settings.autoStartPomodoros,
                              onChanged: (value) => settingsViewModel.update(
                                autoStartPomodoros: value,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _StepperField(
                              label: 'Long Break Interval',
                              value: settings.longBreakInterval,
                              min: 2,
                              max: 12,
                              onChanged: (value) => settingsViewModel.update(
                                longBreakInterval: value,
                              ),
                            ),
                            const SizedBox(height: 28),
                            const _SectionTitle('About This MVP'),
                            const SizedBox(height: 12),
                            const Text(
                              'This first version focuses on the timer, task list, and functional local settings. Report, sign in, and advanced sound or theme controls stay out of scope for now.',
                              style: TextStyle(
                                color: Color(0xFF5A544F),
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF8C8580),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2A2624),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF8BC34A),
        ),
      ],
    );
  }
}

class _StepperField extends StatelessWidget {
  const _StepperField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8C8580),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFECE7E3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Color(0xFF2A2624),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MiniStepButton(
                      onPressed: value > min ? () => onChanged(value - 1) : null,
                      icon: Icons.remove,
                    ),
                    const SizedBox(width: 8),
                    _MiniStepButton(
                      onPressed: value < max ? () => onChanged(value + 1) : null,
                      icon: Icons.add,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStepButton extends StatelessWidget {
  const _MiniStepButton({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled ? const Color(0xFFD9D2CD) : const Color(0xFFE7E1DD),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isEnabled ? const Color(0xFF2A2624) : const Color(0xFFB5ACA7),
        ),
      ),
    );
  }
}
