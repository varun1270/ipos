import 'package:flutter/material.dart';

class OnboardingButton extends StatefulWidget {

  final VoidCallback onPressed;
  final String text;
  final Color color;

  const OnboardingButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  State<OnboardingButton> createState() =>
      _OnboardingButtonState();
}

class _OnboardingButtonState
    extends State<OnboardingButton> {

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        widget.onPressed();
      },

      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },

      child: AnimatedScale(

        duration:
            const Duration(milliseconds: 120),

        scale: isPressed ? 0.96 : 1,

        child: Container(

          height: 62,

          decoration: BoxDecoration(
            color: widget.color,

            borderRadius:
                BorderRadius.circular(22),
          ),

          child: Center(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Text(
                  widget.text,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}