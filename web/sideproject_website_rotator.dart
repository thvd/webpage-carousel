import 'dart:html';
import 'dart:async';
import 'dart:collection';
import 'infinite-linked-list-entry.dart';

class PageShow extends InfiniteLinkedListEntry {
  Duration duration;
  
  // location of page
  String url;
  
  IFrameElement element;
  
  toString() => 'url: $url';
}

LinkedList<PageShow> arr = new LinkedList<PageShow>()
      ..add(new PageShow()
          ..duration = const Duration(seconds: 15)
          ..url = 'http://***/counter.php')
      ..add(new PageShow()
          ..duration = const Duration(seconds: 30)
          ..url = 'http://***/zabbix')
      ..add(new PageShow()
          ..duration = const Duration(seconds: 10)
          ..url = 'jenkins.company.com');

PageShow activeShow = arr.first;

void main() {
  arr.forEach((PageShow pShow){
    pShow.element = (document.createElement('iframe') as IFrameElement)
        ..seamless = true
        ..style.display = 'none'
        ..src = pShow.url;
    
    document.body.children.add(pShow.element);
  });
  
  _next(activeShow);
  
  window.onResize.listen(handleResize);
  handleResize(null);
}

void handleResize(Event e) {
  var innerHeight = '${window.innerHeight}px';
  var innerWidth = '${window.innerWidth}px';
  
  arr.forEach((PageShow pageShow) {
    pageShow.element.height = innerHeight;
    pageShow.element.width = innerWidth;
  });
}

void _next(PageShow pageShow) {
  activeShow.element.style.display = 'none';
  activeShow = pageShow;
  activeShow.element.style.display = 'block';
  
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

