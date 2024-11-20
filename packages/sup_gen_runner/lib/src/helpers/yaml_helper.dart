

// loadPubspecConfigOrNull({
//   required File pubspecFile,
//   File? buildFile,
// }) {
//   final pubspec = loadYaml(pubspecFile.readAsStringSync());
//   if (pubspec == null) {
//     return null;
//   }
//   final buildConfig =
//       buildFile != null ? loadYaml(buildFile.readAsStringSync()) : null;
//   return {
//     'pubspec': pubspec,
//     'build': buildConfig,
//   };
// }
