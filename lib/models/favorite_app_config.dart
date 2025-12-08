import 'dart:typed_data';

class FavoriteAppConfig {
  final String? packageName;
  final String? appName;
  final Uint8List? appIcon;
  final bool isLarge;

  const FavoriteAppConfig({
    this.packageName,
    this.appName,
    this.appIcon,
    this.isLarge = false,
  });

  bool get isConfigured => packageName != null && appName != null;

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'appIcon': appIcon?.toList(),
      'isLarge': isLarge,
    };
  }

  factory FavoriteAppConfig.fromJson(Map<String, dynamic> json) {
    return FavoriteAppConfig(
      packageName: json['packageName'] as String?,
      appName: json['appName'] as String?,
      appIcon: json['appIcon'] != null
          ? Uint8List.fromList(List<int>.from(json['appIcon']))
          : null,
      isLarge: json['isLarge'] as bool? ?? false,
    );
  }

  factory FavoriteAppConfig.empty() {
    return const FavoriteAppConfig();
  }

  FavoriteAppConfig copyWith({
    String? packageName,
    String? appName,
    Uint8List? appIcon,
    bool? isLarge,
  }) {
    return FavoriteAppConfig(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      appIcon: appIcon ?? this.appIcon,
      isLarge: isLarge ?? this.isLarge,
    );
  }
}
