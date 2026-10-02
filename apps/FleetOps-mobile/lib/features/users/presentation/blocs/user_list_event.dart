abstract class UserListEvent {}

class LoadUsers extends UserListEvent {}

class ChangePage extends UserListEvent {
  final int page;
  ChangePage(this.page);
}