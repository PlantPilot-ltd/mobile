import 'package:app/entities/index.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class PlantTile extends StatelessWidget {
  final PlantEntity plant;
  final VoidCallback? onTap;

  final Color _textColor;
  final Color _color;
  final LinearGradient _gradient;

  const PlantTile({super.key, required this.plant, this.onTap})
    : _textColor = CoreUIColors.text,
      _color = CoreUIColors.secondaryBackground,
      _gradient = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          CoreUIColors.secondaryBackground65,
          CoreUIColors.secondaryBackground0,
        ],
      );

  const PlantTile.selected({super.key, required this.plant, this.onTap})
    : _textColor = CoreUIColors.background,
      _color = CoreUIColors.primary,
      _gradient = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [CoreUIColors.primary65, CoreUIColors.primary0],
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              child: ColoredBox(
                color: _color,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap),
                ),
              ),
            ),
          ),
        ),

        /// Image
        Positioned(
          bottom: 12,
          right: 0,
          left: 0,
          child: IgnorePointer(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Image.network(
                    plant.image,
                    fit: BoxFit.contain,
                    width: constraints.maxWidth * 0.6,
                  ),
                );
              },
            ),
          ),
        ),

        /// Gradient background
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  gradient: _gradient,
                ),
              ),
            ),
          ),
        ),

        /// Name
        Positioned(
          left: 20,
          bottom: 20,
          right: 20,
          child: IgnorePointer(
            child: FittedBox(
              child: Text(
                plant.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                  color: _textColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
