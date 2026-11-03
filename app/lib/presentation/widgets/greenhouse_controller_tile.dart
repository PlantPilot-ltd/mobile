import 'package:app/entities/index.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class GreenhouseControllerTile extends StatelessWidget {
  static Size sizeFor(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.6;
    return Size(width, width / 0.56);
  }

  final GreenhouseEntity controller;
  final VoidCallback? onTap;

  const GreenhouseControllerTile({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = sizeFor(context);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          /// Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: 0.61,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: ColoredBox(
                  color: CoreUIColors.secondaryBackground,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: onTap),
                  ),
                ),
              ),
            ),
          ),

          /// Plants images
          for (final (index, plant) in controller.plants.indexed)
            Positioned(
              top: 0,
              bottom: 97,
              right: 24.0 * index,
              width: size.width * 0.78,
              child: IgnorePointer(
                child: Image.network(plant.image, fit: BoxFit.contain),
              ),
            ),

          Positioned(
            left: 16,
            bottom: 20,
            right: 16,
            child: IgnorePointer(
              child: Column(
                children: [
                  /// Sensors values
                  const Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CoreUiSmallInfoBlock.himidity(himidity: 96),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CoreUiSmallInfoBlock.light(light: 96),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CoreUiSmallInfoBlock.temperature(
                            temperature: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// Controller name
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            controller.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              color: CoreUIColors.text,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      /// Connection status icon
                      // TODO: Implement connection status
                      const Icon(
                        CoreUIIcons.bluetooth,
                        size: 27,
                        color: CoreUIColors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
