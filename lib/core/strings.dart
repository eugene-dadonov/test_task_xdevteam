// Представим, что это динамическая локализация на 208 языков.
class AppLocalization {
  static const titleHome = "Главная";
  static const titleFiles = "Файлы";

  static const titleStatusWaiting = "В ожидании";
  static const titleStatusUploading = "Загружается";
  static const titleStatusUploaded = "Загружено";

  static const titleFilesUploaded = "Файлы загружены";

  static const errorWhileChoosingFile = "Произошла ошибка при выборе файла";
  static const errorWhileLoadingInfo = "Произошла ошибка при сборе данных";
  static const errorUnknownException = "Произошла неизвестная ошибка, наши специалисты выясняют причины";

  static const titleNoFiles = "Файлов нет";
  static String titleLoadedFilesCount({required int count}) =>
      "Кол-во файлов: $count";

  static String titleLoadedAndActiveFilesCount({required int activeCount ,required int allCount}) =>
      "Осталось загрузить: $activeCount, Кол-во файлов: $allCount";

  static const buttonSave = "Сохранить";
  static const buttonReset = "Сбросить";

}
