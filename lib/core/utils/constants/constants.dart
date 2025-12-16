import 'package:ripple/core/utils/constants/translations.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

TranslationModel appTranslation() =>
    homeCubit.translationModel ?? TranslationModel.fromJson({});
