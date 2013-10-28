library tree_view;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'dart:collection';

import 'tree_item.dart';
export 'tree_item.dart';

part 'data.dart';
part 'model.dart';

@CustomTag('tree-view')
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
  List<TreeItemElement> selectedItemElements = [];
  
  /// Let styles defined in the author's document "bleed" trough to the shadow DOM.
  bool get applyAuthorStyles => true;
  
  // Just a reference to this, used in the template. TODO: Remove if possible.
  TreeViewElement get instance => this;
  
  static const EventStreamProvider<CustomEvent> _EXPANDED_EVENT = const EventStreamProvider<CustomEvent>('expanded');
  static const EventStreamProvider<CustomEvent> _COLLAPSED_EVENT = const EventStreamProvider<CustomEvent>('collapsed');
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('selected');
  static const EventStreamProvider<CustomEvent> _DESELECTED_EVENT = const EventStreamProvider<CustomEvent>('deselected');
  
  TreeViewElement.created() : super.created() {
  }
  
  /**
   * Returns the Stream of events fired when an item is expanded.
   */
  Stream<Event> get onExpanded => _EXPANDED_EVENT.forTarget(this);
  
  /**
   * Returns the Stream of events fired when an item is collapsed.
   */
  Stream<Event> get onCollapsed => _COLLAPSED_EVENT.forTarget(this);
  
  /**
   * Returns the Stream of events fired when an item is selected.
   */
  Stream<Event> get onSelected => _SELECTED_EVENT.forTarget(this);
  
  /**
   * Returns Stream of events fired when an item's selection is removed.
   */
  Stream<Event> get onDeselected => _DESELECTED_EVENT.forTarget(this);
  
  void dispatchExpandedEvent(Element element, TreeItem item) {
    fire('expanded', detail: item);
  }
  
  void dispatchCollapsedEvent(Element element, TreeItem item) {
    fire('collapsed', detail: item);
  }
  
  void dispatchSelectedEvent(Element element, TreeItem item) {
    fire('selected', detail: item);
  }
  
  void dispatchDeselectedEvent(Element element, TreeItem item) {
    fire('deselected', detail: item);
  }
}