import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'custom_cached_image.dart';

class CartAnimationUtil {
  static void runFlyToCartAnimation(
    BuildContext startContext,
    GlobalKey endKey,
    String imageUrl,
  ) {
    final RenderBox? startBox = startContext.findRenderObject() as RenderBox?;
    final RenderBox? endBox =
        endKey.currentContext?.findRenderObject() as RenderBox?;

    if (startBox == null || endBox == null) return;

    final startOffset = startBox.localToGlobal(Offset.zero);
    final endOffset = endBox.localToGlobal(Offset.zero);

    final startSize = startBox.size;
    final endSize = endBox.size;

    final overlayState = Overlay.of(startContext);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 0,
          top: 0,
          child:
              Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: CustomCachedImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorIconSize: 40,
                      ),
                    ),
                  )
                  .animate(onComplete: (controller) => overlayEntry.remove())
                  .custom(
                    duration:
                        700.ms, // Đã tăng từ 600ms lên 1000ms để bay chậm hơn
                    curve: Curves.easeInOutCubic,
                    builder: (context, value, child) {
                      // Quadratic bezier curve: P = (1-t)^2 P0 + 2(1-t)t P1 + t^2 P2
                      final p0 = startOffset;
                      final p2 = endOffset;
                      // Control point for the arc (slightly higher than the start point)
                      final p1 = Offset(p0.dx, min(p0.dy, p2.dy) - 100);

                      final t = value;
                      final currentX =
                          pow(1 - t, 2) * p0.dx +
                          2 * (1 - t) * t * p1.dx +
                          pow(t, 2) * p2.dx;
                      final currentY =
                          pow(1 - t, 2) * p0.dy +
                          2 * (1 - t) * t * p1.dy +
                          pow(t, 2) * p2.dy;

                      final currentWidth =
                          lerpDouble(startSize.width, endSize.width, t) ??
                          endSize.width;
                      final currentHeight =
                          lerpDouble(startSize.height, endSize.height, t) ??
                          endSize.height;

                      return Transform.translate(
                        offset: Offset(
                          currentX.toDouble(),
                          currentY.toDouble(),
                        ),
                        child: SizedBox(
                          width: currentWidth,
                          height: currentHeight,
                          child: Opacity(
                            opacity:
                                1.0 -
                                (t * 0.3), // Slightly fade out near the end
                            child: child,
                          ),
                        ),
                      );
                    },
                  ),
        );
      },
    );

    overlayState.insert(overlayEntry);
  }
}
