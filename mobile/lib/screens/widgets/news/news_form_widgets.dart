import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

/// Campo de texto con label uppercase rosado e ícono.
class NewsFormField extends StatelessWidget {
  const NewsFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.hint,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(height: 5),
        _buildField(),
      ],
    );
  }

  Widget _buildLabel() {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.fieldLabel,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildField() {
    return TextFormField(
      controller: controller,
        enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: AppColors.fieldText,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        hintText: hint ?? label,
        hintStyle: TextStyle(
          color: AppColors.fieldText.withOpacity(0.35),
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, size: 20, color: AppColors.fieldIcon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.fieldBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.fieldFocused, width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent, fontSize: 11,
        ),
      ),
    );
  }
}

/// Dropdown con label uppercase rosado e ícono.
class NewsFormDropdown<T> extends StatelessWidget {
  const NewsFormDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 5),

        DropdownButtonFormField<T>(
          value: value,
          items: items,

          // 👇 SI ESTÁ DESHABILITADO NO PERMITE CAMBIAR
          onChanged: enabled ? onChanged : null,

          style: TextStyle(
            color: enabled
                ? AppColors.fieldText
                : Colors.grey,
            fontSize: 13,
          ),

          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled
                ? AppColors.fieldIcon
                : Colors.grey,
          ),

          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 20,
              color: enabled
                  ? AppColors.fieldIcon
                  : Colors.grey,
            ),

            filled: true,

            fillColor: enabled
                ? Colors.white
                : Colors.grey.shade100,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.fieldBorder,
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.fieldFocused,
                width: 1.5,
              ),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
/// Selector de imagen con fondo rosado punteado.
class NewsImagePicker extends StatelessWidget {
  const NewsImagePicker({
    super.key,
    required this.onTap,
    this.imageName,
    this.label = 'Seleccionar imagen',
  });

  final VoidCallback onTap;
  final String? imageName;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'IMAGEN',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.fieldBorder,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.image_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    imageName ?? label,
                    style: TextStyle(
                      fontSize: 13,
                      color: imageName != null
                          ? AppColors.fieldText
                          : AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (imageName != null)
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: Color(0xFF2E7D32),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Botón principal del formulario con efecto shine.
class NewsSubmitButton extends StatelessWidget {
  const NewsSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}