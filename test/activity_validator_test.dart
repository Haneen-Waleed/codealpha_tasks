import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/data/models/activity.dart';

void main() {
  group('ActivityValidator.validateDuration', () {
    test('rejects empty input', () {
      expect(ActivityValidator.validateDuration(''), isNotNull);
      expect(ActivityValidator.validateDuration(null), isNotNull);
    });

    test('rejects non-numeric input', () {
      expect(ActivityValidator.validateDuration('abc'), isNotNull);
    });

    test('rejects zero and negative values', () {
      expect(ActivityValidator.validateDuration('0'), isNotNull);
      expect(ActivityValidator.validateDuration('-5'), isNotNull);
    });

    test('rejects unrealistically large values', () {
      expect(ActivityValidator.validateDuration('5000'), isNotNull);
    });

    test('accepts a normal value', () {
      expect(ActivityValidator.validateDuration('30'), isNull);
    });
  });

  group('ActivityValidator.validateCalories', () {
    test('rejects empty and negative input', () {
      expect(ActivityValidator.validateCalories(''), isNotNull);
      expect(ActivityValidator.validateCalories('-10'), isNotNull);
    });

    test('accepts zero (e.g. a stretching session)', () {
      expect(ActivityValidator.validateCalories('0'), isNull);
    });

    test('accepts a normal value', () {
      expect(ActivityValidator.validateCalories('300'), isNull);
    });
  });

  group('ActivityValidator.validateSteps', () {
    test('is optional — empty is valid', () {
      expect(ActivityValidator.validateSteps(''), isNull);
      expect(ActivityValidator.validateSteps(null), isNull);
    });

    test('rejects negative and non-numeric values when provided', () {
      expect(ActivityValidator.validateSteps('-1'), isNotNull);
      expect(ActivityValidator.validateSteps('abc'), isNotNull);
    });

    test('accepts a normal value', () {
      expect(ActivityValidator.validateSteps('5000'), isNull);
    });
  });

  group('ActivityValidator.validateType', () {
    test('rejects empty selection', () {
      expect(ActivityValidator.validateType(''), isNotNull);
      expect(ActivityValidator.validateType(null), isNotNull);
    });

    test('accepts a selected type', () {
      expect(ActivityValidator.validateType('Running'), isNull);
    });
  });
}
