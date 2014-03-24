import 'dart:io';

void main(List<String> args) {
    
  File outputFile = new File('web/sideproject_website_rotator.html');
  File indexFile = new File('build/web/index.html')
    ..createSync(recursive: true);
  
  outputFile.copySync(indexFile.path);
  
  indexFile.writeAsStringSync(outputFile.readAsStringSync(), mode: FileMode.WRITE);
  
  new Directory('web/').listSync().forEach((FileSystemEntity entity) {
    if (entity.statSync().type == FileSystemEntityType.FILE && entity.path.endsWith('.json')) {
      
      File f = entity as File;
      String contents = f.readAsStringSync();
      
      indexFile.writeAsStringSync('<script type="json/data" id="${f.path}">$contents</script>', mode: FileMode.APPEND);
    }
  });
}
