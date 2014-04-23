import 'infinite-linked-list-entry.dart';
import 'dart:html';

class PageShow extends InfiniteLinkedListEntry {
  Duration duration;

  // location of page
  String url;

  IFrameElement element;

  toString() => 'duration: $duration, url: $url';
}
