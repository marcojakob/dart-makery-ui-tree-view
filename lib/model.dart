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
  
  /// A reference to the parent item or null if it is the root.
  TreeItem _parent = null;
  
  /// The children of this item.
  ObservableList<TreeItem> _children = toObservable([]);
  
  /**
   * Constructor.
   * 
   * Note: For root items the [parent] is null.
   */ 
  TreeItem(String this.type, {T this.data, GetNameFunc this.getNameFunc,
      TreeItem parent: null, bool this.isLeaf: true}) {
    
    this.parent = parent;
    
    // Whenever the children list changes, the isLeaf property is set 
    // automatically. 
    _children.changes.listen((List<ChangeRecord> changes) {
      isLeaf = children.isEmpty;
      
      // Notify the children getter about the change.
      // TODO: Maybe add non-null as old value?
      notifyPropertyChange(#children, null, _children);
    });
  }
  
  /**
   * The children of this item as an unmodifiable list. The children can only
   * be modified by setting the children's parent. 
   * Whenever the children are changed this property is notified.
   */
  List<TreeItem> get children => new UnmodifiableListView(_children);
  
  /**
   * Returns the parent.
   */
  @observable
  TreeItem get parent => parent;
  
  /**
   * Sets the parent. Also removes this item from the old parent's children and 
   * adds it to the new parent's children.
   */
  set parent(TreeItem newParent) {
    // Remove itself from the old parent's children.
    if (_parent != null) {
      _parent._children.remove(this);
    }
    
    // Add itself to the new parent's children.
    if (newParent != null && !newParent._children.contains(this)) {
      newParent._children.add(this);
    }
    
    _parent = newParent;
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