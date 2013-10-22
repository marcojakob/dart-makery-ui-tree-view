library example;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

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
    
    TreeItem item0 = new TreeItem(TYPE_FOLDER, data: 'Item 0');
    TreeItem item1 = new TreeItem(TYPE_FOLDER, data: 'Item 1');
    TreeItem item2 = new TreeItem(TYPE_FOLDER, data: 'Item 2');
    root.children.addAll([item0, item1, item2]);
    
    TreeItem item00 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0');
    TreeItem item01 = new TreeItem(TYPE_FOLDER, data: 'Item 0.1');
    item0.children.addAll([item00, item01]);
    
    TreeItem item10 = new TreeItem(TYPE_FOLDER, data: 'Item 1.0');
    TreeItem item11 = new TreeItem(TYPE_FOLDER, data: 'Item 1.1');
    item1.children.addAll([item10, item11]);
    
    TreeItem item000 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0.0');
    TreeItem item001 = new TreeItem(TYPE_FOLDER, data: 'Item 0.0.1');
    item00.children.addAll([item000, item001]);
    
    TreeItem item010 = new TreeItem(TYPE_FOLDER, data: 'Item 0.1.0');
    item01.children.addAll([item010]);
    
    TreeItem item100 = new TreeItem(TYPE_FOLDER, data: 'Item 1.0.0');
    item10.children.addAll([item100]);
    
    // Large Tree test!
//    for (int i = 0; i < 1000; i++) {
//      item0.children.add(new TreeItem(TYPE_FOLDER, data: 'Item a$i'));
//    }
    
    return root;
  }
  
  TreeItem get documentRoot {
    TreeItem documentRoot = new TreeItem(TYPE_FOLDER);
    
    TreeItem countries = new TreeItem(TYPE_FOLDER, data: new Folder('Countries'), getNameFunc: FOLDER_NAME_FUNC);
    TreeItem cities = new TreeItem(TYPE_FOLDER, data: new Folder('Cities'), getNameFunc: FOLDER_NAME_FUNC);
    TreeItem islands = new TreeItem(TYPE_FOLDER, data: new Folder('Islands'), getNameFunc: FOLDER_NAME_FUNC);
    documentRoot.children.addAll([countries, cities, islands]);
    
    TreeItem europe = new TreeItem(TYPE_FOLDER, data: new Folder('Europe'), getNameFunc: FOLDER_NAME_FUNC);
    TreeItem asia = new TreeItem(TYPE_FOLDER, data: new Folder('Asia'), getNameFunc: FOLDER_NAME_FUNC);
    countries.children.addAll([europe, asia]);
    
    // Countries
    TreeItem spain = new TreeItem(TYPE_DOCUMENT, data: new Document('Spain.doc'), getNameFunc: DOCUMENT_NAME_FUNC);
    TreeItem italy = new TreeItem(TYPE_DOCUMENT, data: new Document('Italy.doc'), getNameFunc: DOCUMENT_NAME_FUNC);
    TreeItem china = new TreeItem(TYPE_DOCUMENT, data: new Document('China.pdf'), getNameFunc: DOCUMENT_NAME_FUNC);
    europe.children.addAll([spain, italy]);
    asia.children.addAll([china]);
    
    // Cities
    TreeItem zurich = new TreeItem(TYPE_IMAGE, data: new Document('zurich.jpg'), getNameFunc: DOCUMENT_NAME_FUNC);
    TreeItem bern = new TreeItem(TYPE_IMAGE, data: new Document('bern.jpg'), getNameFunc: DOCUMENT_NAME_FUNC);
    TreeItem geneva = new TreeItem(TYPE_IMAGE, data: new Document('geneva.png'), getNameFunc: DOCUMENT_NAME_FUNC);
    cities.children.addAll([zurich, bern, geneva]);
    
    // Islands
    TreeItem largeIslands = new TreeItem(TYPE_DOCUMENT, data: new Document('Large Islands'), getNameFunc: DOCUMENT_NAME_FUNC);
    TreeItem smallIslands = new TreeItem(TYPE_DOCUMENT, data: new Document('Small Islands'), getNameFunc: DOCUMENT_NAME_FUNC);
    TreeItem madagascar = new TreeItem(TYPE_FOLDER, data: new Folder('Madagascar'), getNameFunc: FOLDER_NAME_FUNC);
    TreeItem java = new TreeItem(TYPE_FOLDER, data: new Folder('Java'), getNameFunc: FOLDER_NAME_FUNC);
    TreeItem ibiza = new TreeItem(TYPE_DOCUMENT, data: new Document('Ibiza'), getNameFunc: DOCUMENT_NAME_FUNC);
    TreeItem corfu = new TreeItem(TYPE_DOCUMENT, data: new Document('Corfu'), getNameFunc: DOCUMENT_NAME_FUNC);
    islands.children.addAll([largeIslands, smallIslands]);
    largeIslands.children.addAll([madagascar, java]);
    smallIslands.children.addAll([ibiza, corfu]);
    
    return documentRoot;
  }
  
  LazyFetcher lazyFetcher = new LazyFetcher();
  
  TreeItem get lazyRoot {
    TreeItem lazyRoot = new TreeItem(TYPE_FOLDER);
    
    TreeItem item0 = new TreeItem(TYPE_FOLDER, data: 'Item 0', isLeaf: false);
    TreeItem item1 = new TreeItem(TYPE_FOLDER, data: 'Item 1', isLeaf: false);
    TreeItem item2 = new TreeItem(TYPE_FOLDER, data: 'Item 2', isLeaf: true);
    
    lazyRoot.children.addAll([item0, item1, item2]);
    
    // Set no parent item for the following items. This will be done only when
    // requested.
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
    new Future.delayed(const Duration(seconds:1), () {
      completer.complete(lazyTree[parent]);
    });
    
    return completer.future;
  }
}
