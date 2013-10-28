library example;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

// TODO: Use package: notation when fixed.
import 'packages/tree_view/tree_view.dart';

const String TYPE_FOLDER = 'folder';
const String TYPE_DOCUMENT = 'document';
const String TYPE_IMAGE = 'jpeg';

@CustomTag('tree-view-example')
class TreeViewExampleElement extends PolymerElement {
  
  /// Let styles defined in the author's document "bleed" trough to the shadow DOM.
  bool get applyAuthorStyles => true;
  
  TreeViewExampleElement.created() : super.created() {
  }
  
  void enteredView() {
    super.enteredView();
    
    shadowRoot.querySelectorAll('tree-view').forEach((Element element) {
      TreeViewElement treeView = element.xtag;
      
      treeView.onExpanded.listen((CustomEvent event) {
        print('Expanded node: ${event.detail}');
      });
      
      treeView.onCollapsed.listen((CustomEvent event) {
        print('Collapsed node: ${event.detail}');
      });
      
      treeView.onSelected.listen((CustomEvent event) {
        print('Selected node: ${event.detail}');
      });
      
      treeView.onDeselected.listen((CustomEvent event) {
        print('Deselected node: ${event.detail}');
      });
    });
  }
  
  TreeItem get stringRoot {
    TreeItem root = new TreeItem(TYPE_FOLDER);
    
    TreeItem item0 = new TreeItem(TYPE_FOLDER, data: 'Item 0', parent: root);
    TreeItem item1 = new TreeItem(TYPE_FOLDER, data: 'Item 1', parent: root);
    TreeItem item2 = new TreeItem(TYPE_FOLDER, data: 'Item 2', parent: root);
    
    TreeItem item00 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0', parent: item0);
    TreeItem item01 = new TreeItem(TYPE_FOLDER, data: 'Item 0.1', parent: item0);
    
    TreeItem item10 = new TreeItem(TYPE_FOLDER, data: 'Item 1.0', parent: item1);
    TreeItem item11 = new TreeItem(TYPE_FOLDER, data: 'Item 1.1', parent: item1);
    
    TreeItem item000 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0.0', parent: item00);
    TreeItem item001 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0.1', parent: item00);
    
    TreeItem item010 = new TreeItem(TYPE_FOLDER, data: 'Item 0.1.0', parent: item01);
    
    TreeItem item100 = new TreeItem(TYPE_FOLDER, data: 'Item 1.0.0', parent: item10);
    
    // Large Tree test!
//    for (int i = 0; i < 1000; i++) {
//      new TreeItem(TYPE_FOLDER, data: 'Item a$i', parent: item0);
//    }
    
    return root;
  }
  
  TreeItem get documentRoot {
    TreeItem documentRoot = new TreeItem(TYPE_FOLDER);
    
    TreeItem countries = new TreeItem(TYPE_FOLDER, data: new Folder('Countries'), getNameFunc: FOLDER_NAME_FUNC, parent: documentRoot);
    TreeItem cities = new TreeItem(TYPE_FOLDER, data: new Folder('Cities'), getNameFunc: FOLDER_NAME_FUNC, parent: documentRoot);
    TreeItem islands = new TreeItem(TYPE_FOLDER, data: new Folder('Islands'), getNameFunc: FOLDER_NAME_FUNC, parent: documentRoot);
    
    TreeItem europe = new TreeItem(TYPE_FOLDER, data: new Folder('Europe'), getNameFunc: FOLDER_NAME_FUNC, parent: countries);
    TreeItem asia = new TreeItem(TYPE_FOLDER, data: new Folder('Asia'), getNameFunc: FOLDER_NAME_FUNC, parent: countries);
    
    // Countries
    TreeItem spain = new TreeItem(TYPE_DOCUMENT, data: new Document('Spain.doc'), getNameFunc: DOCUMENT_NAME_FUNC, parent: europe);
    TreeItem italy = new TreeItem(TYPE_DOCUMENT, data: new Document('Italy.doc'), getNameFunc: DOCUMENT_NAME_FUNC, parent: europe);
    TreeItem china = new TreeItem(TYPE_DOCUMENT, data: new Document('China.pdf'), getNameFunc: DOCUMENT_NAME_FUNC, parent: asia);
    
    // Cities
    TreeItem zurich = new TreeItem(TYPE_IMAGE, data: new Document('zurich.jpg'), getNameFunc: DOCUMENT_NAME_FUNC, parent: cities);
    TreeItem bern = new TreeItem(TYPE_IMAGE, data: new Document('bern.jpg'), getNameFunc: DOCUMENT_NAME_FUNC, parent: cities);
    TreeItem geneva = new TreeItem(TYPE_IMAGE, data: new Document('geneva.png'), getNameFunc: DOCUMENT_NAME_FUNC, parent: cities);
    
    // Islands
    TreeItem largeIslands = new TreeItem(TYPE_FOLDER, data: new Document('Large Islands'), getNameFunc: DOCUMENT_NAME_FUNC, parent: islands);
    TreeItem smallIslands = new TreeItem(TYPE_FOLDER, data: new Document('Small Islands'), getNameFunc: DOCUMENT_NAME_FUNC, parent: islands);
    TreeItem madagascar = new TreeItem(TYPE_DOCUMENT, data: new Folder('Madagascar'), getNameFunc: FOLDER_NAME_FUNC, parent: largeIslands);
    TreeItem java = new TreeItem(TYPE_DOCUMENT, data: new Folder('Java'), getNameFunc: FOLDER_NAME_FUNC, parent: largeIslands);
    TreeItem ibiza = new TreeItem(TYPE_DOCUMENT, data: new Document('Ibiza'), getNameFunc: DOCUMENT_NAME_FUNC, parent: smallIslands);
    TreeItem corfu = new TreeItem(TYPE_DOCUMENT, data: new Document('Corfu'), getNameFunc: DOCUMENT_NAME_FUNC, parent: smallIslands);
    
    return documentRoot;
  }
  
  LazyFetcher lazyFetcher = new LazyFetcher();
  
  TreeItem get lazyRoot {
    TreeItem lazyRoot = new TreeItem(TYPE_FOLDER);
    
    TreeItem item0 = new TreeItem(TYPE_FOLDER, data: 'Item 0', parent: lazyRoot, isLeaf: false);
    TreeItem item1 = new TreeItem(TYPE_FOLDER, data: 'Item 1', parent: lazyRoot, isLeaf: false);
    TreeItem item2 = new TreeItem(TYPE_FOLDER, data: 'Item 2', parent: lazyRoot, isLeaf: true);
    
    // Set no parent item for the following items. This will be done only when requested.
    TreeItem item00 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0', isLeaf: false);
    TreeItem item01 = new TreeItem(TYPE_FOLDER, data: 'Item 0.1', isLeaf: false);
    
    TreeItem item10 = new TreeItem(TYPE_FOLDER, data: 'Item 1.0', isLeaf: false);
    TreeItem item11 = new TreeItem(TYPE_FOLDER, data: 'Item 1.1', isLeaf: true);
    
    TreeItem item000 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0.0', isLeaf: true);
    TreeItem item001 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0.1', isLeaf: true);
    
    TreeItem item010 = new TreeItem(TYPE_FOLDER, data: 'Item 0.1.0', isLeaf: true);
    
    TreeItem item100 = new TreeItem(TYPE_FOLDER, data: 'Item 1.0.0', isLeaf: true);
    
    lazyFetcher.lazyTree[item0] = [item00, item01];
    lazyFetcher.lazyTree[item1] = [item10, item11];
    lazyFetcher.lazyTree[item00] = [item000, item001];
    lazyFetcher.lazyTree[item01] = [item010];
    lazyFetcher.lazyTree[item10] = [item100];
    
    return lazyRoot;
  }
}

class Document {
  String documentName;
  Document(String this.documentName);
}

class Folder {
  String folderName;
  Folder(String this.folderName);
}

final GetNameFunc DOCUMENT_NAME_FUNC = (Document doc) => doc.documentName;

final GetNameFunc FOLDER_NAME_FUNC = (Folder folder) => folder.folderName;

class LazyFetcher extends TreeDataFetcher {
  
  // Map with parent as key and children as value.
  Map<TreeItem, List<TreeItem>> lazyTree = {};
  
  Future<List<TreeItem>> fetchChildren(TreeItem parent) {
    Completer completer = new Completer();
    
    // Simulate a delay.
    new Future.delayed(const Duration(seconds: 1), () {
      completer.complete(lazyTree[parent]);
    });
    
    return completer.future;
  }
}
