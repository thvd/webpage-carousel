import 'dart:html';
import 'dart:async';
import 'dart:collection';
import 'infinite-linked-list-entry.dart';

class PageShow extends InfiniteLinkedListEntry {
  Duration duration;
  
  // location of page
  String url;
}

LinkedList<PageShow> arr = new LinkedList<PageShow>()
      ..add(new PageShow()
          ..duration = const Duration(seconds: 15)
          ..url = 'http://10.20.1.198/counter.php')
      ..add(new PageShow()
          ..duration = const Duration(seconds: 10)
          ..url = 'http://10.20.1.198/zabbix');

IFrameElement iframe;

void main() {
  iframe = querySelector('#rotate-frame');
  
  _next(arr.first);
  
  window.onResize.listen(handleResize);
  handleResize(null);
}

void handleResize(Event e) {
  iframe.height = '${window.innerHeight}px';
  iframe.width = '${window.innerWidth}px';
}

void _next(PageShow pageShow) {
  
  if (pageShow.previous != null && iframe.src != '') {
    pageShow.previous.url = iframe.src;
  }
  
  _setUrl(iframe, pageShow.url);
  
  PageShow next = pageShow.next;
    
  new Timer(next.duration, () => _next(next));
}


_setUrl(IFrameElement _iframe, String url) {
  try {
    _iframe.src = url;
   } catch (e) {
     print('******error-');
     print(e);
     print('-error******');
   }
}

