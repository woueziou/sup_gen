// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pubspec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pubspec _$PubspecFromJson(Map json) => $checkedCreate(
      'Pubspec',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['name', 'sup_gen_option'],
        );
        final val = Pubspec(
          packageName: $checkedConvert('name', (v) => v as String),
          supGenOption: $checkedConvert(
              'sup_gen_option', (v) => SupGen.fromJson(v as Map)),
        );
        return val;
      },
      fieldKeyMap: const {
        'packageName': 'name',
        'supGenOption': 'sup_gen_option'
      },
    );

SupGen _$SupGenFromJson(Map json) => $checkedCreate(
      'SupGen',
      json,
      ($checkedConvert) {
        final val = SupGen(
          enable: $checkedConvert('enable', (v) => v as bool),
          schema: $checkedConvert('schema', (v) => v as String),
          useSsl: $checkedConvert('use_ssl', (v) => v as bool?),
          output: $checkedConvert('output', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'useSsl': 'use_ssl'},
    );
