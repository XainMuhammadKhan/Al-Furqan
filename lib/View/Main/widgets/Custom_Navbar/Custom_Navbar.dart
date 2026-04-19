import 'package:alfurqan/View/Main/widgets/Inactive_Items/Inactive_Item.dart';
import 'package:alfurqan/ViewModel/controller/main/main_controller.dart';
import 'package:alfurqan/resources/Utilities/colors/App_Colors.dart';
import 'package:alfurqan/resources/Utilities/images/App_Images.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final MainController controller;

  const CustomNavBar({required this.controller});

  static const icons = [
    AppImages.Home,
    AppImages.Quran,
    AppImages.Audio,
    AppImages.Prayer,
  ];
  static const labels = ['Home', 'Quran', 'Audio', 'Prayer'];
  static const itemCount = 4;

  @override
  State<CustomNavBar> createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar>
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final AnimationController _bumpCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _labelFadeAnim;
  int _currentIndex = 0;
  bool _disposed = false;

  void _onIndexChanged() {
    if (_disposed) return;
    final newIndex = widget.controller.currentIndex.value;
    if (newIndex != _currentIndex && mounted) {
      _slideCtrl.animateTo(
        newIndex.toDouble(),
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 350),
      );
      _bumpCtrl.forward(from: 0);
      setState(() => _currentIndex = newIndex);
    }
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.controller.currentIndex.value;

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: _currentIndex.toDouble(),
      lowerBound: 0,
      upperBound: (CustomNavBar.itemCount - 1).toDouble(),
    );

    _bumpCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.7,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_bumpCtrl);

    _labelFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bumpCtrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    widget.controller.currentIndex.listen((_) => _onIndexChanged());

    _bumpCtrl.forward();
  }

  @override
  void dispose() {
    _disposed = true;
    _slideCtrl.dispose();
    _bumpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 85 + bottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Gradient navbar background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 68 + bottomPadding,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [AppColors.splashGrad1, AppColors.splashGrad2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 12,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pattern image limited to navbar area with reduced opacity
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        AppImages.geometricPatternGold,
                        fit: BoxFit.cover,
                        // alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Icons row on top of the pattern
                  Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Row(
                      children: List.generate(
                        CustomNavBar.itemCount,
                        (i) => Expanded(
                          child: GestureDetector(
                            onTap: () => widget.controller.changeIndex(i),
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedOpacity(
                              opacity: _currentIndex == i ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: InactiveItem(
                                icon: CustomNavBar.icons[i],
                                label: CustomNavBar.labels[i],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Animated sliding bump
          AnimatedBuilder(
            animation: Listenable.merge([_slideCtrl, _bumpCtrl]),
            builder: (context, _) {
              final slideVal = _slideCtrl.value;
              final screenWidth = MediaQuery.of(context).size.width;
              final itemWidth = screenWidth / CustomNavBar.itemCount;

              // Maps each index to the CENTER of its tab slot
              final bumpLeft =
                  (slideVal * itemWidth) +
                  (itemWidth / 2) -
                  29; // 29 = half of 58px bump

              return Positioned(
                bottom: 10 + bottomPadding,
                left: bumpLeft,
                child: GestureDetector(
                  onTap: () => widget.controller.changeIndex(_currentIndex),
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.splashGrad2,
                                AppColors.splashGrad1,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              CustomNavBar.icons[_currentIndex],
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Opacity(
                          opacity: _labelFadeAnim.value,
                          child: Text(
                            CustomNavBar.labels[_currentIndex],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
