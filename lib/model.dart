part of makery_ui_tree_view.tree_view;

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
  Set<TreeItem> _children = new Set();
  
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
  }
  
  /**
   * The name to be displayed for this item.
   */
  @observable
  String get name;
  
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
      _parent._removeChild(this);
    }
    
    // Add itself to the new parent's children.
    if (newParent != null) {
      newParent._addChild(this);
    }
    
    _parent = newParent;
  }
  
  /**
   * The children of this item as an unmodifiable list. The children can only
   * be modified from the outside by setting the children's parent. 
   * 
   * Whenever the underlying list changes this property is notified.
   */
  @observable
  List<TreeItem> get children => new UnmodifiableListView(_children);

  /**
   * Adds the [child] and notifies that the [children] have changed.
   */
  void _addChild(TreeItem child) {
    _children.add(child);
    isLeaf = children.isEmpty;
    
    // TODO: Should we add something as old value?
    notifyPropertyChange(#children, null, children);
  }
  
  /**
   * Removes the [child] and notifies that the [children] have changed.
   */
  void _removeChild(TreeItem child) {
    _children.remove(child);
    isLeaf = children.isEmpty;
    
    // TODO: Should we add something as old value?
    notifyPropertyChange(#children, null, children);
  }
  
  
  /**
   * CSS classes used for the (collapsed) toggle icon.
   */
  List<String> get toggleIconStyles;
  
  /**
   * CSS classes used for the expanded toggle icon.
   */
  List<String> get toggleIconExpandedStyles;
  
  /**
   * CSS classes used for the (collapsed) item icon.
   */
  List<String> get itemIconStyles;
  
  /**
   * CSS classes used for the expanded item icon.
   */
  List<String> get itemIconExpandedStyles;
  
  /**
   * CSS classes used for the loading item icon.
   */
  List<String> get itemIconLoadingStyles;
}