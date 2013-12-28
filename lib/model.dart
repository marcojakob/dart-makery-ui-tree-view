part of tree_view;

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
abstract class TreeItem<T> extends Observable {
  
  /// The data represented by this item. 
  @observable T data;
  
  /// A TreeItem is a leaf if it has no children. A leaf can not be expanded.
  @observable bool isLeaf;
  
  /// A reference to the parent item or null if it is the root.
  TreeItem _parent = null;
  
  /// The children of this item.
  ObservableList<TreeItem> _children = toObservable([]);
  
  /// True if the item's children are shown.
  @observable bool expanded = false;
  
  /// True if the item is selected.
  @observable bool selected = false;
  
  /**
   * Constructor. 
   * 
   * For root items the [parent] is null. The [isLeaf] property is only used
   * when children are lazy loaded. If [isLeaf] is set to false it indicates
   * that there are children to be loaded while [children] might still be empty.
   */ 
  TreeItem(T this.data, {TreeItem parent: null, bool this.isLeaf: true}) {
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
   * Returns the type used to determine the CSS class for icons. For example,
   * if the type is 'folder', the CSS class will be 'tree-icon-type-folder'.
   */
  String get type;
  
  /**
   * Returns the name to be displayed for this item.
   */
  String get name;
  
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
  TreeItem get parent => _parent;
  
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
}