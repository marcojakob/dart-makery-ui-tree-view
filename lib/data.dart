part of tree_view;

/**
 * Used to (lazy) fetch child items of a parent.
 */
abstract class TreeDataFetcher {
  
  /**
   * Returns a Future that will receive the child items of [parent]. 
   */
  Future<List<TreeItem>> fetchChildren(TreeItem parent);
}

/** 
 * Default implementation to fetch items. This function is used when all items
 * are already loaded.
 */
class DefaultTreeDataFetcher extends TreeDataFetcher {
  
  Future<List<TreeItem>> fetchChildren(TreeItem parent) {
    Completer completer = new Completer();
    
    completer.complete(parent.children);
    
    return completer.future;
  }
}