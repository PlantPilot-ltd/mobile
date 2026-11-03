part of '/core_ui.dart';

class CoreUiButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  final Color color;
  final Color? backgroundColor;
  final Color? borderColor;

  const CoreUiButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.color,
    this.backgroundColor,
    this.borderColor,
  });

  const CoreUiButton.filledPrimary({
    super.key,
    required this.title,
    required this.onTap,
  }) : color = CoreUIColors.background,
       backgroundColor = CoreUIColors.primary,
       borderColor = null;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: _BorderDecoration(
        borderColor: borderColor,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              highlightColor: borderColor?.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: CoreUIFonts.sfUIText,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BorderDecoration extends StatelessWidget {
  final Color? borderColor;
  final Widget child;

  const _BorderDecoration({this.borderColor, required this.child});

  @override
  Widget build(BuildContext context) {
    if (borderColor == null) return child;
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(12),
        dashPattern: [9, 6],
        strokeWidth: 2,
        color: borderColor!,
      ),
      child: child,
    );
  }
}
