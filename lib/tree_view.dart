library makery_ui_tree_view.tree_view;

import 'package:polymer/polymer.dart';
import 'dart:html' show CustomEvent, Element, EventStreamProvider;
import 'dart:async';
import 'dart:collection';

export 'tree_item.dart';

part 'data.dart';
part 'model.dart';

@CustomTag('tree-view-element')
class TreeViewElement extends PolymerElement {
  
  static const String SELECTION_SINGLE = 'single';
  static const String SELECTION_MULTIPLE = 'multiple';
  
  @published bool animate = false;
  @published String selection = 'single';
  
  /// Returns true if multi-selection is allowed.
  bool get isMultipleSelection => selection == SELECTION_MULTIPLE;

  /// The root tree item.
  @published TreeItem root;
  
  /// Class used to fetch child items.
  @published TreeDataFetcher fetcher = new DefaultTreeDataFetcher();

  /// All currently selected items.
  List<TreeItem> selectedItems = [];
  
  /// Let styles defined in the author's document "bleed" trough to the shadow DOM.
  bool get applyAuthorStyles => true;
  
  // Just a reference to this, used in the template. TODO: Remove if possible.
  TreeViewElement get instance => this;
  
  static const EventStreamProvider<CustomEvent> _EXPANDED_EVENT = const EventStreamProvider<CustomEvent>('itemexpanded');
  static const EventStreamProvider<CustomEvent> _COLLAPSED_EVENT = const EventStreamProvider<CustomEvent>('itemcollapsed');
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('itemselected');
  static const EventStreamProvider<CustomEvent> _DESELECTED_EVENT = const EventStreamProvider<CustomEvent>('itemdeselected');
  
  TreeViewElement.created() : super.created() {
  }
  
  /**
   * Returns the Stream of events fired when an item is expanded.
   * The [CustomEvent]s detail attribute contains the [TreeItem].
   */
  Stream<CustomEvent> get onItemExpanded => _EXPANDED_EVENT.forTarget(this);
  
  /**
   * Returns the Stream of events fired when an item is collapsed.
   * The [CustomEvent]s detail attribute contains the [TreeItem].
   */
  Stream<CustomEvent> get onItemCollapsed => _COLLAPSED_EVENT.forTarget(this);
  
  /**
   * Returns the Stream of events fired when an item is selected.
   * The [CustomEvent]s detail attribute contains the [TreeItem].
   */
  Stream<CustomEvent> get onItemSelected => _SELECTED_EVENT.forTarget(this);
  
  /**
   * Returns Stream of events fired when an item's selection is removed.
   * The [CustomEvent]s detail attribute contains the [TreeItem].
   */
  Stream<CustomEvent> get onItemDeselected => _DESELECTED_EVENT.forTarget(this);
  
  void dispatchExpandedEvent(Element element, TreeItem item) {
    fire('itemexpanded', detail: item);
  }
  
  void dispatchCollapsedEvent(Element element, TreeItem item) {
    fire('itemcollapsed', detail: item);
  }
  
  void dispatchSelectedEvent(Element element, TreeItem item) {
    fire('itemselected', detail: item);
  }
  
  void dispatchDeselectedEvent(Element element, TreeItem item) {
    fire('itemdeselected', detail: item);
  }
  
  /**
   * Ensures that the [item] is visible by expanding all its parents.
   */
  void ensureVisible(TreeItem item) {
    if (item.parent != null) {
      item.parent.expanded = true;
      // Recursive call to get all parents.
      ensureVisible(item.parent);
    }
  }
  
  /**
   * Deselects all items. No events are fired.
   */
  void clearSelection() {
    selectedItems.forEach((el) => el.selected = false);
  }
  
  /**
   * Selects all items of the tree that satisfy the predicate [test]. All 
   * previously selected items are deselected. The tree is expanded so that all 
   * selected items are shown. No events are fired.
   * 
   * The returned list contains all items that were selected.
   */
  List<TreeItem> selectWhere(bool test(TreeItem item)) {
    clearSelection();
    
    // Find the items in the tree.
    List<TreeItem> foundItems = findItems(test);
    foundItems.forEach((TreeItem item) {
      item.selected = true;
      ensureVisible(item);
    });
    
    return foundItems;
  }
  
  /**
   * Returns all items satisfying the predicate [test].
   */
  List<TreeItem> findItems(bool test(TreeItem item)) {
    // [root] must have been initialized.
    assert(root != null);
    
    List<TreeItem> result = [];
    
    // First test if root satisfies the test.
    if (test(root)) {
      result.add(root);
    }
    _findItemsInChildren(root, test, result);
    return result;
  }
  
  /**
   * Recursively searches the children of [parent] to find the items that 
   * satisfy the predicate [test] and adds them to [result]. 
   */
  void _findItemsInChildren(TreeItem parent, bool test(TreeItem item), 
                            List<TreeItem> result) {
    parent.children.forEach((TreeItem child) {
      if (test(child)) {
        result.add(child);
      }
      _findItemsInChildren(child, test, result);
    });
  }
}