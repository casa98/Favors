abstract class Result<T> {
  const Result();
  T? get value;
  Exception? get error;
}

class Success<T> extends Result<T> {
  final T _value;
  const Success(this._value);
  T get value => _value;
  Exception? get error => null;
}

class Failure<T> extends Result<T> {
  final Exception _exception;
  const Failure(this._exception);
  T? get value => null;
  Exception get error => _exception;
}
