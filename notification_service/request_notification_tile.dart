import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:magic_image/magic_image.dart';

import '../../../generated/assets.gen.dart';
import '../../../generated/locales.g.dart';
import '../../components/simple_white_container.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_style.dart';
import 'notification_service.dart';

class RequestNotificationTile extends StatefulWidget {
  const RequestNotificationTile({super.key, this.margin});

  final EdgeInsets? margin;

  @override
  State<RequestNotificationTile> createState() =>
      _RequestNotificationTileState();
}

class _RequestNotificationTileState extends State<RequestNotificationTile>
    with WidgetsBindingObserver {
  ValueNotifier<bool> get isPermissionAllowed =>
      NotificationService.isPermissionAllowed;

  ValueNotifier<bool> get isNotificationTileDismissed =>
      NotificationService.isNotificationTileDismissed;

  bool get showTile =>
      !isNotificationTileDismissed.value && !isPermissionAllowed.value;

  late final mergedListenable = Listenable.merge([
    isPermissionAllowed,
    isNotificationTileDismissed,
  ]);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationService.requestPermission(checkOnly: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    NotificationService.requestPermission(checkOnly: true);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: mergedListenable,
      builder: (context, child) {
        log(
          'Permission ${isPermissionAllowed.value}',
          name: 'Notification_Tile',
        );
        log(
          'Dismissed ${isNotificationTileDismissed.value}',
          name: 'Notification_Tile',
        );
        log('showTile $showTile', name: 'Notification_Tile');
        return showTile
            ? Container(
                margin: widget.margin,
                padding: const .all(12),
                decoration: BoxDecoration(
                  border: .all(color: AppColors.piccolo),
                  color: AppColors.piccolo.withAlpha((12 / 100 * 255).toInt()),
                  borderRadius: .circular(8),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    MagicImage(Assets.images.info, squareDimension: 32),
                    Expanded(
                      child: Column(
                        spacing: 12,
                        crossAxisAlignment: .start,
                        children: [
                          Text(LocaleKeys.enableNotificationMessage.tr),
                          SimpleWhiteContainer(
                            onTap: () {
                              NotificationService.requestPermission(
                                showSettings: true,
                              );
                            },
                            bgColor: Colors.transparent,
                            padding: .zero,
                            child: Text(
                              'ENABLE',
                              style: AppTextStyle.f16w400Piccolo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SimpleWhiteContainer(
                      padding: .zero,
                      onTap: () {
                        isNotificationTileDismissed.value = true;
                      },
                      bgColor: Colors.transparent,
                      child: MagicImage(
                        Assets.images.close,
                        squareDimension: 32,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}
