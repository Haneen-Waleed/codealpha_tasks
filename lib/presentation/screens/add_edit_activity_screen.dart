import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/activity.dart';
import '../../state/fitness_provider.dart';

/// Handles both creating a new activity and editing an existing one.
/// Pass `existingActivity` to switch the screen into edit mode.
class AddEditActivityScreen extends StatefulWidget {
  final Activity? existingActivity;

  const AddEditActivityScreen({super.key, this.existingActivity});

  @override
  State<AddEditActivityScreen> createState() => _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends State<AddEditActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedType;
  late TextEditingController _durationController;
  late TextEditingController _caloriesController;
  late TextEditingController _stepsController;
  late TextEditingController _notesController;
  late DateTime _selectedDateTime;

  bool _isSaving = false;

  bool get _isEditing => widget.existingActivity != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingActivity;
    _selectedType = existing?.type ?? WorkoutTypes.all.first;
    _durationController =
        TextEditingController(text: existing?.durationMinutes.toString() ?? '');
    _caloriesController =
        TextEditingController(text: existing?.caloriesBurned.toString() ?? '');
    _stepsController = TextEditingController(
      text: existing != null && existing.steps > 0 ? existing.steps.toString() : '',
    );
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _selectedDateTime = existing?.dateTime ?? DateTime.now();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _stepsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:  ColorScheme.dark(
              primary: AppColors.neon,
              onPrimary: AppColors.card,
              surface: AppColors.card,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:  ColorScheme.dark(
              primary: AppColors.neon,
              onPrimary: AppColors.card,
              surface: AppColors.card,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.card,
      hintText: hintText,
      hintStyle:  TextStyle(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:  BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:  BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.neon),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final activity = Activity(
      id: widget.existingActivity?.id,
      type: _selectedType,
      durationMinutes: int.parse(_durationController.text.trim()),
      caloriesBurned: int.parse(_caloriesController.text.trim()),
      steps: _stepsController.text.trim().isEmpty
          ? 0
          : int.parse(_stepsController.text.trim()),
      dateTime: _selectedDateTime,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final provider = context.read<FitnessProvider>();
    final success = _isEditing
        ? await provider.editActivity(activity)
        : await provider.addActivity(activity);

    if (!mounted) return;
    setState(() => _isSaving = false);

    final feedback = provider.consumeFeedback();
    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.card,
          content: Text(
            feedback ?? 'Saved.',
            style:  TextStyle(color: AppColors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.card,
          content: Text(
            feedback ?? 'Could not save. Please try again.',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showSteps = WorkoutTypes.stepRelevant.contains(_selectedType) ||
        _stepsController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: Text(_isEditing ? 'Edit Activity' : 'Add Activity'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'Workout type',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: AppColors.card,
                style:  TextStyle(color: AppColors.white),
                decoration: _inputDecoration(),
                items: WorkoutTypes.all
                    .map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t, style:  TextStyle(color: AppColors.white)),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedType = value);
                },
                validator: (value) => ActivityValidator.validateType(value),
              ),
              const SizedBox(height: 18),

              Text(
                'Duration (minutes)',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _durationController,
                style:  TextStyle(color: AppColors.white),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(hintText: 'e.g. 30'),
                validator: ActivityValidator.validateDuration,
              ),
              const SizedBox(height: 18),

              Text(
                'Calories burned',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _caloriesController,
                style:  TextStyle(color: AppColors.white),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(hintText: 'e.g. 250'),
                validator: ActivityValidator.validateCalories,
              ),
              const SizedBox(height: 18),

              if (showSteps) ...[
                Text(
                  'Steps (optional)',
                  style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _stepsController,
                  style:  TextStyle(color: AppColors.white),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration(hintText: 'e.g. 4000'),
                  validator: ActivityValidator.validateSteps,
                ),
                const SizedBox(height: 18),
              ],

              Text(
                'Date & time',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 18, color: AppColors.neon),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('EEE, MMM d, yyyy · h:mm a')
                            .format(_selectedDateTime),
                        style: AppTextStyles.body.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Text(
                'Notes (optional)',
                style: AppTextStyles.bodyMuted.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                style:  TextStyle(color: AppColors.white),
                maxLines: 3,
                maxLength: 200,
                decoration: _inputDecoration(
                  hintText: 'Anything worth remembering about this session',
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: AppColors.bg,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ?  SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.bg,
                  ),
                )
                    : Text(
                  _isEditing ? 'Save Changes' : 'Save Activity',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}