import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
 
/// Botón principal con gradiente rosado oscuro y efecto shine.
class LoginButton extends StatefulWidget {
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });
 
  final VoidCallback onPressed;
  final bool isLoading;
 
  @override
  State<LoginButton> createState() => _LoginButtonState();
}
 
class _LoginButtonState extends State<LoginButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shine;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
 
    _shine = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _shine,
        builder: (context, _) => _buildButton(context),
      ),
    );
  }
 
  Widget _buildButton(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.32),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (!widget.isLoading) _buildShine(context),
            _buildContent(),
          ],
        ),
      ),
    );
  }
 
  Widget _buildShine(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned.fill(
      child: Transform.translate(
        offset: Offset(_shine.value * screenWidth, 0),
        child: FractionallySizedBox(
          widthFactor: 0.4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.14),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _buildContent() {
    return Center(
      child: widget.isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text(
              'Iniciar sesión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
 