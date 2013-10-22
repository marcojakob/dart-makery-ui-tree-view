part of tree_view;

/**
 * Function used to retrieve the name from the data object.
 */
typedef String GetNameFunc(data);

/**
 * View-model for hierarchical tree items.
 * 
 * [isLeaf] is used to indicate whether the item has children even though they
 * may not be loaded yet. In that case [isLeaf] is false and [children] is 
 * empty.
 * 
 * After the first change to [children] it is assumed that all children are 
 * loaded. Whenever the [children] list changes, [isLeaf] is updated 
 * accordingly. 
 */
class TreeItem<T> extends Observable {
  
  /// The type used for rendering with corresponding tree item template.
  String type;
  
  /// The data represented by this item. 
  @observable T data;
  
  /// The function used to retrieve the display name from the [data].
  /// If null, toString() is used.
  @observable GetNameFunc getNameFunc;
  
  /// A TreeItem is a leaf if it has no children. A leaf can not be expanded.
  @observable bool isLeaf;
  
  /// The children of this item.
  final ObservableList<TreeItem> children = toObservable([]);
  
  /**
   * Constructor.
   * 
   * Note: For root items the [parent] is null.
   */ 
  TreeItem(String this.type, {T this.data, bool this.isLeaf: true, 
      GetNameFunc this.getNameFunc}) {
    
    // Whenever the children list changes, the isLeaf property is set automatically.
    children.changes.listen((List<ChangeRecord> changes) {
      isLeaf = children.isEmpty;
    });
  }
  
  /**
   * Returns the name used for displaying the item.
   */
  String get name {
    if (getNameFunc != null) {
      return getNameFunc(data);
    } else {
      return data.toString();
    }
  }
}