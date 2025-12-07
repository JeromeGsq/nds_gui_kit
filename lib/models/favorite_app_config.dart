import 'dart:typed_data';

class FavoriteAppConfig {
  final String? packageName;
  final String? appName;
  final Uint8List? appIcon;

  const FavoriteAppConfig({
    this.packageName,
    this.appName,
    this.appIcon,
  });

  bool get isConfigured => packageName != null && appName != null;

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'appIcon': appIcon?.toList(),
    };
  }

  factory FavoriteAppConfig.fromJson(Map<String, dynamic> json) {
    return FavoriteAppConfig(
      packageName: json['packageName'] as String?,
      appName: json['appName'] as String?,
      appIcon: json['appIcon'] != null
          ? Uint8List.fromList(List<int>.from(json['appIcon']))
          : null,
    );
  }

  factory FavoriteAppConfig.empty() {
    return const FavoriteAppConfig();
  }

  FavoriteAppConfig copyWith({
    String? packageName,
    String? appName,
    Uint8List? appIcon,
  }) {
    return FavoriteAppConfig(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      appIcon: appIcon ?? this.appIcon,
    );
  }
}

