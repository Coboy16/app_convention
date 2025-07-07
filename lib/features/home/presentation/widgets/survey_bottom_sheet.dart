import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/dashboard_entity.dart';
import '/core/core.dart';

class SurveyBottomSheet extends StatefulWidget {
  final SurveyEntity survey;
  final Function(Map<String, dynamic>) onSubmit;

  const SurveyBottomSheet({
    super.key,
    required this.survey,
    required this.onSubmit,
  });

  @override
  State<SurveyBottomSheet> createState() => _SurveyBottomSheetState();
}

class _SurveyBottomSheetState extends State<SurveyBottomSheet> {
  final Map<String, dynamic> _responses = {};
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.inputBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.clipboardList,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.survey.title, style: AppTextStyles.h3),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.survey.questions.length} preguntas',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.survey.description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Progress indicator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: LinearProgressIndicator(
              value:
                  ((_currentQuestionIndex + 1) /
                  widget.survey.questions.length),
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pregunta ${_currentQuestionIndex + 1} de ${widget.survey.questions.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${((_currentQuestionIndex + 1) / widget.survey.questions.length * 100).round()}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Questions
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentQuestionIndex = index;
                });
              },
              itemCount: widget.survey.questions.length,
              itemBuilder: (context, index) {
                final question = widget.survey.questions[index];
                return _buildQuestionPage(question);
              },
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Anterior'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: _currentQuestionIndex > 0 ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleNextOrSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.surface,
                              ),
                            ),
                          )
                        : Text(
                            _currentQuestionIndex ==
                                    widget.survey.questions.length - 1
                                ? 'Enviar'
                                : 'Siguiente',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(SurveyQuestionEntity question) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (question.isRequired) ...[
                const Text(
                  '*',
                  style: TextStyle(color: AppColors.error, fontSize: 18),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(child: Text(question.question, style: AppTextStyles.h4)),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildQuestionInput(question)),
        ],
      ),
    );
  }

  Widget _buildQuestionInput(SurveyQuestionEntity question) {
    switch (question.type) {
      case QuestionType.singleChoice:
        return _buildSingleChoice(question);
      case QuestionType.multipleChoice:
        return _buildMultipleChoice(question);
      case QuestionType.text:
        return _buildTextInput(question);
      case QuestionType.rating:
        return _buildRatingInput(question);
    }
  }

  Widget _buildSingleChoice(SurveyQuestionEntity question) {
    return Column(
      children: question.options.map((option) {
        final isSelected = _responses[question.id] == option;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _responses[question.id] = option;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.inputBorder.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.inputBorder,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: AppTextStyles.body1.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoice(SurveyQuestionEntity question) {
    final selectedOptions = _responses[question.id] as List<String>? ?? [];

    return Column(
      children: question.options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                final currentSelected = List<String>.from(selectedOptions);
                if (isSelected) {
                  currentSelected.remove(option);
                } else {
                  currentSelected.add(option);
                }
                _responses[question.id] = currentSelected;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.inputBorder.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.inputBorder,
                        width: 2,
                      ),
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            LucideIcons.check,
                            color: AppColors.surface,
                            size: 12,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: AppTextStyles.body1.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextInput(SurveyQuestionEntity question) {
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Escribe tu respuesta aquí...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surfaceVariant.withOpacity(0.3),
      ),
      onChanged: (value) {
        _responses[question.id] = value;
      },
    );
  }

  Widget _buildRatingInput(SurveyQuestionEntity question) {
    final rating = _responses[question.id] as int? ?? 0;

    return Column(
      children: [
        Text(
          'Califica del 1 al 5',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = rating >= value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _responses[question.id] = value;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.warning.withOpacity(0.1)
                      : AppColors.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.warning
                        : AppColors.inputBorder.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(
                  LucideIcons.star,
                  color: isSelected
                      ? AppColors.warning
                      : AppColors.textTertiary,
                  size: 24,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Muy malo',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Excelente',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNextOrSubmit() {
    final currentQuestion = widget.survey.questions[_currentQuestionIndex];

    // Validar respuesta requerida
    if (currentQuestion.isRequired &&
        (!_responses.containsKey(currentQuestion.id) ||
            _responses[currentQuestion.id] == null ||
            (_responses[currentQuestion.id] is String &&
                (_responses[currentQuestion.id] as String).trim().isEmpty) ||
            (_responses[currentQuestion.id] is List &&
                (_responses[currentQuestion.id] as List).isEmpty))) {
      ToastUtils.showError(
        context: context,
        message: 'Esta pregunta es obligatoria',
      );
      return;
    }

    if (_currentQuestionIndex < widget.survey.questions.length - 1) {
      // Ir a la siguiente pregunta
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Enviar encuesta
      _submitSurvey();
    }
  }

  void _submitSurvey() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Validar todas las preguntas requeridas
      for (final question in widget.survey.questions) {
        if (question.isRequired &&
            (!_responses.containsKey(question.id) ||
                _responses[question.id] == null ||
                (_responses[question.id] is String &&
                    (_responses[question.id] as String).trim().isEmpty) ||
                (_responses[question.id] is List &&
                    (_responses[question.id] as List).isEmpty))) {
          ToastUtils.showError(
            context: context,
            message: 'Por favor completa todas las preguntas requeridas',
          );
          setState(() {
            _isSubmitting = false;
          });
          return;
        }
      }

      // Simular delay de envío
      await Future.delayed(const Duration(seconds: 1));

      widget.onSubmit(_responses);
      Navigator.pop(context);
    } catch (e) {
      ToastUtils.showError(
        context: context,
        message: 'Error al enviar la encuesta',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
