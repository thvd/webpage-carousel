import 'dart:html';
import 'dart:async';
import 'dart:collection';

class PageShow extends LinkedListEntry {
  Duration duration;
  
  // location of page
  String url;
}

LinkedList<PageShow> arr = new LinkedList<PageShow>()
      ..add(new PageShow()
          ..duration = const Duration(seconds: 15)
          ..url = 'http://theverge.com')
      ..add(new PageShow()
          ..duration = const Duration(seconds: 10)
          ..url = 'http://tweakers.net');

IFrameElement iframe;
IFrameElement cache;

void main() {
  iframe = querySelector('#rotate-frame');
  cache = querySelector('#rotate-frame-cache');
  
  _next(arr.first);
}

void _next(PageShow pageShow) {
  
  // Load url
  
  // When loaded, try to load next webpage in cache element
  
  if (pageShow.previous != null && iframe.src != '') {
    pageShow.previous.url = iframe.src;
  }
  
  _setUrl(cache, pageShow.url);
  
  cache.addEventListener('onload', (Event e) {
    PageShow next = pageShow.next == null 
          ? pageShow.list.first
          : pageShow.next;
      
    new Timer(next.duration, () => _next(next));
  });
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

