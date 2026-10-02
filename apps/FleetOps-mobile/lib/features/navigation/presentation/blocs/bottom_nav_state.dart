abstract class BottomNavState {
  final int index;
  const BottomNavState(this.index);
}

class BottomNavInitial extends BottomNavState {
  const BottomNavInitial() : super(0);
}

class BottomNavChanged extends BottomNavState {
  const BottomNavChanged(int index) : super(index);
}
