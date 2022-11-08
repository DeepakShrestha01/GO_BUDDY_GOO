class Range<T1, T2> {
  T1 start;
  T2 end;

  Range({required this.start, required this.end}) {
    assert(T1.runtimeType == T2.runtimeType);
  }

  @override
  String toString() => 'Range(start: $start, end: $end)';

  Range copy() => Range(end: end, start: start);
}
