# CabifyTest

# Overview
In this project two ViewControllers were needed:
- HomeViewController, where the user can add and remove products from the Cart
- CheckoutViewController, where the user can see the final price as well as the discount applied.

The project uses Swift 5, Xcode 14.2, Combine, UIKit, MVVM-C as these are the ones I'm most familliar with. But I enjoy learning and quickly can grasp any tech used by the team.

# Demo:
I recorded a quick video showing the whole app:


https://user-images.githubusercontent.com/48156392/217957097-489edac4-01ea-4a10-b5e9-46a994c5719b.mp4



# Discounts

As was written in the Considerations section of the challenge Github the discounts will be changed. Preparing for the future, I created a Gist,
simillar to the one provided for fetching the products provided in the test readme, where I fetch the Discounts. The Gist can be seen [here](https://gist.githubusercontent.com/pmrmoura/83a724e28ec78cac9ea930068681c78b/raw/b4966a5d64b6482605c21217ef03e13c6f5ee72d/Discounts.json).
I modeled the Discount to be easily changed and that new ways of discounting can be added.

For example, let's suppose the in the near future the Marketing team wants to created a 3 for 1 discount for the "MUG". We can add in the Gist Json a new Discount like this:

>  {
      "numberOfPiecesNeeded": 3,
      "productCode": "MUG",
      "discountReceived": 7.5,
      "discountType": "oneForFree"
  }
  
  The logic of this modeling is simple. **numberOfPiecesNeeded** is the number of times the user has to add that product to the Cart so that it receives the
  **discountReceived**. Also, the **discountType** property is used for doing the logic inside the Cart class in the App. And finally the **productCode** is used
  for knowing what is the product.
  
A idea to make this even easier to use is by integrating it into a Backoffice system where Marketing teams can easily add and remove discounts from the app.
  
  
# Cart

With the Single Responsability Principle in mind, I created a separate class "Cart" responsible for all the operations(adding, removing, calculatingPrices). Also in the Cart is where the Discounts are applied.
