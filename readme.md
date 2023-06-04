# 👍Good-To-Go
![main-image](https://user-images.githubusercontent.com/40076944/229564256-7ffb333e-ab28-427d-a7df-04273ba2904e.png)

<br/>

## 👍Introduction

The explosive growth of the food delivery and packaging culture around the world has led to a surge in the use of single-use plastics. While many people have recognized this problem and are trying to practice multi-container packaging to reduce the use of single-use plastics, there are a number of challenges to making this a consistent practice.  
First, you'll need to contact each restaurant directly or find their location information to see if they are a multi-use container restaurant. Even if you find a restaurant that does, it's difficult to determine what size and capacity of to-go containers you need for each item on the menu. Because of these problems, some people end up giving up on trying to pack their food. So, our ‘ta-bom’ team has developed the ‘Good-To-Go’ app to solve these problems and make zero-waste food packaging easy and convenient for everyone.  
Good-To-Go makes it easy for users to find restaurants that offer zero-waste packaging and provides information on the number of multi-serving containers needed for each menu item, eliminating the need for users to contact restaurants individually to determine container size and capacity. The app also includes reviews from other users, providing valuable insights to help users make informed packaging decisions. With ‘Good-To-Go’, users can easily order food from restaurants that offer zero-waste packaging, reducing their carbon footprint and contributing to a more sustainable planet.

<br/>

## 👍Our Goal

![main (0-00-39-26)_1](https://user-images.githubusercontent.com/40076944/229538678-83c7c796-66ce-4173-b5bc-05df624affff.png)

Our ta-bom team chose two UN Sustainable Development Goals: SDG 12: **Responsible Consumption and Production** and SDG13: **Climate Action**.  
'Good To Go' is a zero-waste food packaging application that promotes responsible consumption by reducing single-use plastics used to package food, and contributes to reducing greenhouse gas emissions, a major contributor to climate change, by reducing waste from food packaging.

<br/>

## 👍Project Architecture

![skill](https://user-images.githubusercontent.com/40076944/229573566-d66dc7b7-c248-4e37-b266-6dca472569c4.png)

<br/>

## 👍Demo Video

[![Video Label](https://user-images.githubusercontent.com/40076944/229560114-3908ec44-2a37-442e-bc05-60e214186122.png)](https://youtu.be/rREzuxvsreg)

<br/>

## 👍Feature
Good-To-Go consists of two apps: a consumer app that allows users to place orders with the restaurant, and a restaurant owner app that allows the restaurant to receive orders.
### Feature Overview(Customer App)
1. Google login
2. Set user location
3. Show Resturants near by user
4. Order food for packing
5. Write review
6. See the recap

 

### Detail Page Images


<img src = "https://user-images.githubusercontent.com/70003845/229250008-858daa39-2851-49c2-873a-5cf0fcf440d4.png" width = "50%">

![onboard](https://user-images.githubusercontent.com/70003845/229249958-1dca634a-7bbd-4ca8-959e-e7f8874dbd31.png)

<br/>
#### Login and see onboarding pages

  Our Good To Go app allows users to sign up and log in through Google login and our app uses an onboarding page to introduce first-time users to the app.

<br/>

![map](https://user-images.githubusercontent.com/70003845/229250214-bee55d6c-44ea-4f29-97e3-8a4374611f46.png)

#### Set user location

After going through the onboarding page, the user has to enter their location. The user can navigate to their current location via GPS, search for a location via the search bar, or move a pin on the map to set a precise address. After the location is set, a map appears showing the user's current location and restaurants near the user. You can click the restaurant icons on the map to see the names of the restaurants. Pull up the panel at the bottom of the screen to see a list of restaurants near the user. Users can also organize the restaurants by tapping on the food categories located at the top of the panel.

<br/>

![restrt](https://user-images.githubusercontent.com/70003845/229250897-efd668eb-2b75-4b3d-8541-0307b7a4f441.png)

#### Ordering the food for packing

A restaurant's detail page gives users information and reviews about the restaurant. When a user clicks on the food that they want to order, they'll see the size and number of to-go containers that they need to package the food.

<br/>

![container](https://user-images.githubusercontent.com/70003845/229251635-e2c26436-cf33-463b-b78f-6743c208e42c.png)

#### Read the description of reusable containers

The Good To Go app also provides descriptions of the capacities of the to-go containers you should bring. Tap the "?" button at the top to see a description and capacity for each multi-serving container. Once you've packed and ordered, you can view your order history.

<br/>

#### See the history of orders
  On the Orders page, users can check their current order status and past orders. Order statuses are categorized into three main categories: 'Order', 'Cooking', and 'GOOD TO GO. Users can write reviews for past orders.

 <br/>


![review](https://user-images.githubusercontent.com/70003845/229252041-04333560-8657-4610-b63e-de73d6a6ae68.png)

#### Write and read reviews
  On the Orders page, users can check their current order status and past orders. Order statuses are categorized into three main categories: 'Order', 'Cooking', and 'GOOD TO GO'. Users can write reviews for past orders.

 

#### See the recap
<img src = "https://user-images.githubusercontent.com/70003845/229255796-57ed6b0c-40ec-4858-9ba2-30bdf22b7277.png" width = "70%">
  The Recap page allows users to see their positive environmental impact. Users can see the total number of times they've packaged their food, as well as stats on the reusable containers they've used to pack it.

<br/>

<center><img src = "https://user-images.githubusercontent.com/70003845/229533549-b5ce7a99-b3b5-4ec2-aff0-a5504e3ff89a.png" width = "50%"></center>

#### Manage account
  Users can edit their profile and log out of the app from the Account page.

<br/>

### Feature Overview(Restaurant owner App)
1. Restaurant information
2. Managing orders
3. Accounts

### Detail Page Images


## 👍Execution Method
Here's how you can set up a testing environment.<br/>
1. Download the apk file [here](https://github.com/dsc-sookmyung/2023-ta-bom-SolutionChallenge/releases/tag/v1.0.0).  <br/>
2. Run the apk file on your phone or the emulator.<br/>
3. To ensure the best experience while testing our app, we recommend testing it in a Pixel 6 or higher environment. <br/>
4. **!!!!important!!!!** Currently, Good To Go's restaurant list consists of restaurants near our team's university, Sookmyung Women's University, so you can try Good To Go by entering `sookmyung women's univ Gwahaggwan` or `GXV8+VH2 Seoul` in the search bar when setting your location.<br/>
![image](https://github.com/dsc-sookmyung/2023-ta-bom-SolutionChallenge/assets/49427080/371aa0b3-6d03-45df-97c7-a4241527fe17)<br/>
**If you encounter any issues while setting up or running the project, please don't hesitate to contact us.** <br/>


<br/>

## 👍Contributors

<center><img src = "https://user-images.githubusercontent.com/70003845/229250287-011f014e-7ab2-413f-bbe8-196691d941bc.jpg"></center>

[Yun Jae-Eun](https://github.com/yunjaeeun44) : Back-end Developer  
[Kim Min-Jeong](https://github.com/MIN60) : Front-end Developer  
[Lee Yu-Jin](https://github.com/Ujaa) : Front-end Developer
