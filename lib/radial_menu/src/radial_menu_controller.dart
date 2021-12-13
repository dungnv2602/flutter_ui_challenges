part of radial_menu;

class RadialMenuController extends ChangeNotifier {
  final AnimationController _progress;
  RadialMenuState _state;
  RadialMenuItem _activeItem;

  RadialMenuController({
    @required TickerProvider vsync,
    @required RadialMenuState state,
  })  : assert(vsync != null),
        assert(state != null),
        _state = state,
        _progress = AnimationController(vsync: vsync) {
    _progress
      ..addListener(notifyListeners)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _onTransitionCompleted();
          }
        },
      );
  }

  void _onTransitionCompleted() {
    switch (_state) {
      case RadialMenuState.closing:
        _state = RadialMenuState.closed;
        break;
      case RadialMenuState.expanding:
        _state = RadialMenuState.expanded;
        break;
      case RadialMenuState.collapsing:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.opening:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.activating:
        _state = RadialMenuState.dissipating;
        // if done animation of activating state => fire animation of dissipating state
        _forward(500);
        break;
      case RadialMenuState.dissipating:
        _state = RadialMenuState.open;
        // trigger _activeItem.onPressed() after animation
        _activeItem.onPressed();
        _activeItem = null;
        break;
      case RadialMenuState.expanded:
      case RadialMenuState.closed:
      case RadialMenuState.open:
        throw Exception('Invalid state during a transition: $_state');
    }

    notifyListeners();
  }

  void open(int milliseconds) {
    if (state == RadialMenuState.closed) {
      _state = RadialMenuState.opening;
      _forward(milliseconds);
    }
  }

  void close() {
    if (state == RadialMenuState.open) {
      _state = RadialMenuState.closing;
      _forward(250);
    }
  }

  void expand() {
    if (state == RadialMenuState.open) {
      _state = RadialMenuState.expanding;
      _forward(500);
    }
  }

  void collapse() {
    if (state == RadialMenuState.expanded) {
      _state = RadialMenuState.collapsing;
      _forward(250);
    }
  }

  void activate(RadialMenuItem activeItem) {
    if (state == RadialMenuState.expanded) {
      // register active item for later use
      _activeItem = activeItem;
      // fire animation
      _state = RadialMenuState.activating;
      _forward(500);
    }
  }

  void _forward(int milliseconds) {
    _progress
      ..duration = Duration(milliseconds: milliseconds)
      ..forward(from: 0);
    notifyListeners();
  }

  RadialMenuState get state => _state;

  double get progress => _progress.value;

  RadialMenuItem get activeItem => _activeItem;
}

enum RadialMenuState {
  closed,
  closing,
  opening,
  open,
  expanding,
  collapsing,
  expanded,
  activating,
  dissipating,
}
