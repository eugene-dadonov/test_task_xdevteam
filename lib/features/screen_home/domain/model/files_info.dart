class HomeScreenInfo {
  final bool isSaveAvailable;
  final bool isResetAvailable;
  final int filesCount;
  final int activeFilesCount;

  HomeScreenInfo({
    required this.isSaveAvailable,
    required this.isResetAvailable,
    required this.filesCount,
    required this.activeFilesCount,
  });

  HomeScreenInfo.noInfo()
      : filesCount = 0,
        activeFilesCount = 0,
        isSaveAvailable = false,
        isResetAvailable = false;
}
