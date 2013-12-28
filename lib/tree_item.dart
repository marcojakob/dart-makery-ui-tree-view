library tree_item;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:animation/animation.dart';

import 'tree_view.dart';

@CustomTag('tree-item')
class TreeItemElement extends PolymerElement {

  /// The model [TreeItem] represented by this element.
  @published TreeItem item;
  
  /// A reference to the [TreeViewElement] this item belongs to.
  @published TreeViewElement treeView; 
  
  /// True if the item is loading its children.
  @observable bool loading = false;
  
  /// Let styles defined in the author's document "bleed" trough to the shadow DOM.
  bool get applyAuthorStyles => true;
  
  Animation _animation;
  bool _animationRunning = false;
  
  TreeItemElement.created() : super.created() {
  }
  
  void enteredView() {
    super.enteredView();
    
    // Update style when something changes.
    onPropertyChange(item, #isLeaf, () {
      _updateItemToggle();
    });
    onPropertyChange(item, #expanded, () {
      _updateItemToggle();
      _updateItemIcon();
      _updateItemChildren();
    });
    onPropertyChange(item, #selected, () {
      _updateItemLabel();
      // Keep track of selected items.
      if (item.selected) {
        if (!treeView.selectedItems.contains(item)) {
          treeView.selectedItems.add(item);
        }
      } else {
        treeView.selectedItems.remove(item);
      }
    });
    onPropertyChange(this, #loading, () {
      _updateItemIcon();
    });
    
    // Update all for the first time.
    _updateItemToggle();
    _updateItemIcon();
    _updateItemLabel();
    _updateItemChildren();
  }
  
  void _updateItemToggle() {
    Element itemToggle = shadowRoot.querySelector('.tree-item-toggle');
    updateCssClass(itemToggle, 'tree-icon-toggle', !item.isLeaf && !item.expanded);
    updateCssClass(itemToggle, 'tree-icon-toggle-expanded', !item.isLeaf && item.expanded);
  }
  
  void _updateItemIcon() {
    Element itemIcon = shadowRoot.querySelector('.tree-item-icon');
    updateCssClass(itemIcon, 'tree-icon-type-${item.type}', !loading && !item.expanded);
    updateCssClass(itemIcon, 'tree-icon-type-${item.type}-expanded', !loading && item.expanded);
    updateCssClass(itemIcon, 'tree-icon-loading', loading);
  }
  
  void _updateItemLabel() {
    Element itemLabel = shadowRoot.querySelector('.tree-item-label');
    updateCssClass(itemLabel, 'tree-item-selected', item.selected);
  }
  
  void _updateItemChildren() {
    Element itemChildren = shadowRoot.querySelector('.tree-item-children');
    updateCssClass(itemChildren, 'tree-item-expanded', item.expanded);
  }
  
  /**
   * Toggles this [item] between expanded and collapsed.
   */
  void toggle(MouseEvent event, var detail, Element target) {
    if (!item.isLeaf && !loading) {
      if (item.expanded) {
        _collapse();
      } else {
        _expand();
      }
    }
  }
  
  /**
   * Expands this [item].
   */
  void _expand() {
    treeView.dispatchExpandedEvent(this, item);
    
    if (item.children.isEmpty) {
      loading = true;
      
      treeView.fetcher.fetchChildren(item).then((List<TreeItem> childItems) {

        if (childItems == null || childItems.isEmpty) {
          // No child items found --> is a leaf!
          item.isLeaf = true;
          return;
        }
        
        // Set parent of all child items.
        childItems.forEach((TreeItem childItem) {
          childItem.parent = item;
        });
        
        if (treeView.animate) {
          // Add animation to the event queue to leave time for items to be
          // added first.
          new Future(_animateExpand);
        } else {
          item.expanded = true;
          loading = false;
        }
        
      }).catchError((Object error) => print('An error occured: $error'));
    } else {
      if (treeView.animate) {
        _animateExpand();
      } else {
        item.expanded = true;
      }
    }
  }
  
  /**
   * Collapses this item.
   */
  void _collapse() {
    treeView.dispatchCollapsedEvent(this, item);
    
    if (treeView.animate) {
      _animateCollapse();
    } else {
      item.expanded = false;
    }
  }
  
  /**
   * Animates the expansion of child items.
   */
  void _animateExpand() {
    UListElement childContainer = shadowRoot.querySelector('.tree-item-children');
    childContainer.style.display = 'block';
    // Use client height as start height if an animation is running.
    int startHeight = _animationRunning ? childContainer.clientHeight : 0;
    
    // Get the target height.
    childContainer.style.height = 'auto';
    int targetHeight = childContainer.clientHeight;
    
    childContainer.style.height = '${startHeight}px';
    
    Map<String, Object> animationProperties = <String, Object>{
      'height': targetHeight
    };
    
    if (_animation != null) {
      _animation.stop();
    }
    
    _animationRunning = true;
    _animation = animate(childContainer, duration: 500, properties: animationProperties);
    _animation.onComplete.listen((_) {
      _animationRunning = false;
      childContainer.style.removeProperty('height');
      childContainer.style.removeProperty('display');
    });
    item.expanded = true;
    loading = false;
  }
  
  /**
   * Animates collapsing the child items.
   */
  void _animateCollapse() {
    UListElement childContainer = shadowRoot.querySelector('.tree-item-children');
    childContainer.style.display = 'block';
    Map<String, Object> animationProperties = <String, Object>{
      'height': 0
    };
    
    if (_animation != null) {
      _animation.stop();
    }
    
    _animationRunning = true;
    _animation = animate(childContainer, duration: 500, properties: animationProperties);
    _animation.onComplete.listen((_) {
      _animationRunning = false;
      childContainer.style.removeProperty('height');
      childContainer.style.removeProperty('display');
    });
    item.expanded = false;
  }
  
  
  
  /**
   * Called when the selection of this item is changed with a click.
   */
  void select(MouseEvent event, var detail, Element target) {
    var selectedElements = treeView.selectedItems;
    
    if (treeView.isMultipleSelection && event.ctrlKey) {
      if (treeView.selectedItems.contains(item)) {
        item.selected = false;
        treeView.dispatchDeselectedEvent(this, item);
      } else {
        item.selected = true;
        treeView.dispatchSelectedEvent(this, item);
      }
    } else {
      treeView.selectedItems.forEach((el) => el.selected = false);
      item.selected = true;
      treeView.dispatchSelectedEvent(this, item);
    }
  }
}