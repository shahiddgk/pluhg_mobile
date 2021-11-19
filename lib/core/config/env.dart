import 'secrets.dart';

enum BuildFlavor { prod, dev }

BuildEnvironment get env => _env!;
BuildEnvironment? _env;

class BuildEnvironment implements Secret {
  final BuildFlavor flavor;
  final Uri? baseUri;

  factory BuildEnvironment.factory({
    BuildFlavor? flavor,
    Uri? uri,
  }) =>
      BuildEnvironment._(
        flavor: flavor!,
        baseUri: uri,
      );

  BuildEnvironment._({
    this.flavor = BuildFlavor.dev,
    this.baseUri,
  });
}
