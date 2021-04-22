# ShoppingList

The simplest application for creating a shopping list. 

# App Description
The application supports the function of creating shopping lists with different priorities. In addition, every list can contain numerous items for shopping with detailed information, like category, description, and photo. Every shopping item can be editing or deleting by swiping left. All information about shopping lists, items, and their details are persistently stored. A user can marked items in the shopping list as bought. All bought items are displayed at the bottom of the list.  

# Project Details

<strong>User Interface</strong>

  There are three main View Controllers:
  * ShoppingListsViewController: Displaying all shopping lists in Table View.
  * ShoppingItemsViewController: Displaying all shopping items for choosing the shopping list in Table View.
  * ShoppingItemDetailsViewController: Displaying details for a shopping item.
  
  And two modal View Controllers:
  * New Shopping List View Controller: For creating a new shopping list. 
  * New Shopping Item View Controller: For creating a new shopping item, also this View Controller is used to display information for editing the shopping item.
 
 <strong>Persistence</strong>
 
Shopping Lists, Shopping Items, their details, and photos are stored in Core Data. The application's data model includes two entities(ShoppingList, ShoppingItem) with the one-to-many relationship.

# User Interface

<strong>Shopping Lists Controllers</strong>

On the left swipe, a list can be deleted. On the right swipe, the priority of the list can be change. The button at the bottom of the controller open the modal controller for adding a new list. Each cell contains the name,  count of items in the shopping list, and created date.

<strong>New Shopping List Controller</strong>

The controller contains a text field for entering a name for the list and a picker view for choosing the priority. The save button is enabled in case of adding at least one character to the name text field.
 
<strong>Shopping Items Controller</strong>

The controller contains a table view with the added shopping items for the chosen shopping list, sorted by created date. All bought items at the bottom of the list and the cell looks like unavailable. Each cell contains the name of the item, its category, and photo if this information is available. Each cell contains the switch for marking items as bought. If a user marks it as bought, this item moves to the bottom part to others bought objects. The label at the bottom of the controllers informs how many items are bought and the total items on the shopping list. On the left swipe, an item can be deleted or editing.

<strong>New Shopping Item Controller</strong>

The controller contains the text fields to enter the name of item and details(like quantity, notes, etc), picker view for choosing a category, and image view for adding the photo to the item. The save button is enabled in case of adding at least one character to the name text field. If a user tap on the image view alert is shown with different options: photo from the library, photo from the camera (this option is available only if the device has a camera) and delete chosen photo. 

<strong>Shopping Item Details Controller</strong>

The controller contains all possible information about an item(name, category, details, photo).
 
 
 








