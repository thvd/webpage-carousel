import 'dart:html';
import 'dart:async';
import 'dart:collection';
import 'infinite-linked-list-entry.dart';
import 'dart:convert';

class PageShow extends InfiniteLinkedListEntry {
  Duration duration;
  
  // location of page
  String url;
  
  IFrameElement element;
  
  toString() => 'url: $url';
}

LinkedList<PageShow> arr = new LinkedList<PageShow>();
PageShow activeShow;

void main() {
  
  // get data from json file
  HttpRequest.getString('data.json').then((String dataStr) {
    Map<String, List<Map<String, dynamic>>> data = JSON.decode(dataStr);
    
    data['pageshows'].forEach((Map<String, dynamic> pageShow) {
      int seconds = pageShow['duration'];
      
      arr.add(new PageShow()
        ..duration = new Duration(seconds: seconds)
        ..url = pageShow['url']);
    });
    
    // init
    arr.forEach((PageShow pShow) {
      pShow.element = (document.createElement('iframe') as IFrameElement)
          ..seamless = true
          ..style.display = 'none'
          ..src = pShow.url;
      
      document.body.children.add(pShow.element);
    });
    
    _next();
    
    window.onResize.listen(handleResize);
    handleResize(null);
  });
}


void handleResize(Event e) {
  var innerHeight = '${window.innerHeight}px';
  var innerWidth = '${window.innerWidth}px';
  
  arr.forEach((PageShow pageShow) {
    pageShow.element.height = innerHeight;
    pageShow.element.width = innerWidth;
  });
}

void _next() {
  if (activeShow == null) {
    // first time, start
    activeShow = arr.first;
  } else {
    // continue
    activeShow.element.style.display = 'none';
    activeShow = activeShow.next;
  }
  
  activeShow.element.style.display = 'block';
  
  new Timer(activeShow.duration, _next);
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
