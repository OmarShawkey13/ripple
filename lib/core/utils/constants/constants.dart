import 'package:ripple/core/utils/constants/translations.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';

TranslationModel appTranslation() =>
    themeCubit.translationModel ?? TranslationModel.fromJson({});
