library example;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

import 'package:makery_ui_tree_view/tree_view.dart';

@CustomTag('example-element')
class TreeViewExampleElement extends PolymerElement {
  
  /// Let styles defined in the author's document "bleed" trough to the shadow DOM.
  bool get applyAuthorStyles => true;
  
  TreeViewExampleElement.created() : super.created() {
  }
  
  void enteredView() {
    super.enteredView();
    
    shadowRoot.querySelectorAll('tree-view-element').forEach((TreeViewElement treeView) {
      
      treeView.onItemExpanded.listen((CustomEvent event) {
        print('Expanded node: ${event.detail}');
      });
      
      treeView.onItemCollapsed.listen((CustomEvent event) {
        print('Collapsed node: ${event.detail}');
      });
      
      treeView.onItemSelected.listen((CustomEvent event) {
        print('Selected node: ${event.detail}');
      });
      
      treeView.onItemDeselected.listen((CustomEvent event) {
        print('Deselected node: ${event.detail}');
      });
    });
  }
  
  TreeItem get stringRoot {
    TreeItem root = new FolderTreeItem('');
    
    TreeItem item0 = new FolderTreeItem('Item 0', parent: root);
    TreeItem item1 = new FolderTreeItem('Item 1', parent: root);
    TreeItem item2 = new FolderTreeItem('Item 2', parent: root);
    
    TreeItem item00 = new FolderTreeItem('Item 0.0', parent: item0);
    TreeItem item01 = new FolderTreeItem('Item 0.1', parent: item0);
    
    TreeItem item10 = new FolderTreeItem('Item 1.0', parent: item1);
    TreeItem item11 = new FolderTreeItem('Item 1.1', parent: item1);
    
    TreeItem item000 = new FolderTreeItem('Item 0.0.0', parent: item00);
    TreeItem item001 = new FolderTreeItem('Item 0.0.1', parent: item00);
    
    TreeItem item010 = new FolderTreeItem('Item 0.1.0', parent: item01);
    
    TreeItem item100 = new FolderTreeItem('Item 1.0.0', parent: item10);
    
    // Large Tree test!
//    for (int i = 0; i < 1000; i++) {
//      new FolderTreeItem('Item a$i', parent: item0);
//    }
    
    return root;
  }
  
  TreeItem get documentRoot {
    TreeItem documentRoot = new FolderTreeItem('');
    
    TreeItem countries = new FolderTreeItem('Countries', parent: documentRoot);
    TreeItem cities = new FolderTreeItem('Cities', parent: documentRoot);
    TreeItem islands = new FolderTreeItem('Islands', parent: documentRoot);
    
    TreeItem europe = new FolderTreeItem('Europe', parent: countries);
    TreeItem asia = new FolderTreeItem('Asia', parent: countries);
    
    // Countries
    TreeItem spain = new DocumentTreeItem(new Document('Spain.doc'), europe);
    TreeItem italy = new DocumentTreeItem(new Document('Italy.doc'), europe);
    TreeItem china = new DocumentTreeItem(new Document('China.pdf'), asia);
    
    // Cities
    TreeItem zurich = new DocumentTreeItem(new Document('zurich.jpg'), cities);
    TreeItem bern = new DocumentTreeItem(new Document('bern.jpg'), cities);
    TreeItem geneva = new DocumentTreeItem(new Document('geneva.png'), cities);
    
    // Islands
    TreeItem largeIslands = new FolderTreeItem('Large Islands', parent: islands);
    TreeItem smallIslands = new FolderTreeItem('Small Islands', parent: islands);
    TreeItem madagascar = new FolderTreeItem('Madagascar', parent: largeIslands);
    TreeItem java = new FolderTreeItem('Java', parent: largeIslands);
    TreeItem ibiza = new DocumentTreeItem(new Document('Ibiza'), smallIslands);
    TreeItem corfu = new DocumentTreeItem(new Document('Corfu'), smallIslands);
    
    return documentRoot;
  }
  
  LazyFetcher lazyFetcher = new LazyFetcher();
  
  TreeItem get lazyRoot {
    TreeItem lazyRoot = new FolderTreeItem('');
    
    TreeItem item0 = new FolderTreeItem('Item 0', parent: lazyRoot, isLeaf: false);
    TreeItem item1 = new FolderTreeItem('Item 1', parent: lazyRoot, isLeaf: false);
    TreeItem item2 = new FolderTreeItem('Item 2', parent: lazyRoot, isLeaf: true);
    
    // Set no parent item for the following items. This will be done only when requested.
    TreeItem item00 = new FolderTreeItem('Item 0.0', isLeaf: false);
    TreeItem item01 = new FolderTreeItem('Item 0.1', isLeaf: false);
    
    TreeItem item10 = new FolderTreeItem('Item 1.0', isLeaf: false);
    TreeItem item11 = new FolderTreeItem('Item 1.1', isLeaf: true);
    
    TreeItem item000 = new FolderTreeItem('Item 0.0.0', isLeaf: true);
    TreeItem item001 = new FolderTreeItem('Item 0.0.1', isLeaf: true);
    
    TreeItem item010 = new FolderTreeItem('Item 0.1.0', isLeaf: true);
    
    TreeItem item100 = new FolderTreeItem('Item 1.0.0', isLeaf: true);
    
    lazyFetcher.lazyTree[item0] = [item00, item01];
    lazyFetcher.lazyTree[item1] = [item10, item11];
    lazyFetcher.lazyTree[item00] = [item000, item001];
    lazyFetcher.lazyTree[item01] = [item010];
    lazyFetcher.lazyTree[item10] = [item100];
    
    return lazyRoot;
  }
  
  /// Selects the china element in the document tree.
  void selectChina(Event event, var detail, Element target) {
    TreeViewElement tree = $['icons-multiple-selection'];
    tree.selectWhere((TreeItem item) => item.name == 'China.pdf');
  }
  
  /// Selects all documents in the document tree.
  void selectDocuments(Event event, var detail, Element target) {
    TreeViewElement tree = $['icons-multiple-selection'];
    tree.selectWhere((TreeItem item) => item is DocumentTreeItem);
  }
}

class Document {
  String documentName;
  Document(String this.documentName);
}

/**
 * Defines a [TreeItem] for [Document]s.
 */
class DocumentTreeItem extends TreeItem<Document> {
  
  DocumentTreeItem(Document data, TreeItem parent) : 
    super(data, parent: parent, isLeaf: true);
  
  @observable
  String get name => data.documentName; 
  
  List<String> get toggleIconStyles => ['fa', 'fa-caret-right'];
  List<String> get toggleIconExpandedStyles => ['fa', 'fa-caret-down'];

  List<String> get itemIconStyles => ['fa', 'fa-file-o'];
  List<String> get itemIconExpandedStyles => ['fa', 'fa-file-o'];
  List<String> get itemIconLoadingStyles => ['fa', 'fa-spinner', 'fa-spin'];
}

/**
 * Defines a [TreeItem] for folders.
 */
class FolderTreeItem extends TreeItem<String> {
  
  FolderTreeItem(String data, {TreeItem parent: null, bool isLeaf: true}) : 
    super(data, parent: parent, isLeaf: isLeaf);
  
  @observable
  String get name => data; 
  
  List<String> get toggleIconStyles => ['fa', 'fa-caret-right'];
  List<String> get toggleIconExpandedStyles => ['fa', 'fa-caret-down'];

  List<String> get itemIconStyles => ['fa', 'fa-folder'];
  List<String> get itemIconExpandedStyles => ['fa', 'fa-folder-open'];
  List<String> get itemIconLoadingStyles => ['fa', 'fa-spinner', 'fa-spin'];
}

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
