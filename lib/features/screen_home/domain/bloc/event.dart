abstract class HomeScreenEvent {}

class HomeOpened extends HomeScreenEvent {}

/// Не совсем понятно, нужно ли чистить файлы в очереди.
/// Если мы их отправляем на сервер, то да, но в задании сказано, что только
/// нужно показать сообщение.
class SaveFiles extends HomeScreenEvent {}

class ResetFiles extends HomeScreenEvent {}

class NavigateToFiles extends HomeScreenEvent {}
