import 'dart:collection';

class InfiniteLinkedListEntry<E extends LinkedListEntry<E>>
    extends LinkedListEntry<E> {
  /**
   * Return the succeeding element in the list.
   */
  E get next {
    if (list.isEmpty) {
      return null;
    }
    return super.next == null ? list.first : super.next;
  }

  /**
   * Return the preceeding element in the list.
   */
  E get previous {
    if (list.isEmpty) {
      return null;
    }
    return super.previous == null ? list.last : super.previous;
  }
}
