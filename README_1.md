# Little Shop of Orders, v2
BE Mod 2 Week 4/5 Group Project

## Background and Description

"Little Shop of Orders" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Merchant users can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will automatically set the order status to "shipped". Each user role will have access to some or all CRUD functionality for application models.

Students will be put into 3 or 4 person groups to complete the project.

## Learning Goals
- Advanced Rails routing (nested resources and namespacing)
- Advanced ActiveRecord for calculating statistics
- Average HTML/CSS layout and design for UX/UI
- Session management and use of POROs for shopping cart
- Authentication, Authorization, separation of user roles and permissions

## Requirements
- must use Rails 5.1.x
- must use PostgreSQL
- must use 'bcrypt' for authentication
- all controller and model code must be tested via feature tests and model tests, respectively
- must use good GitHub branching, team code reviews via GitHub comments, and use of a project planning tool like waffle.io
- must include a thorough README to describe their project

## Permitted
- use any gems we've used in class (pry, launchy, shoulda-matchers, etc)
- use FactoryBot to speed up your test development
- use "rails generators" to speed up your app development

## Not Permitted
- do not use JavaScript for pagination or sorting controls

## Permission
- if there is a specific gem you'd like to use in the project, please get permission from your instructors first

## Schema

You should use this schema:

![Imgur](https://i.imgur.com/kEcAZdw.png)

## User Stories

Your team may not be able to work on these stories in numeric order. Work together to determine the best starting place and work from there.

- [Little Shop v2 stories](stories.md)


## Rubric, Evaluations, and final Assessment

Each team will meet with an instructor at least two times before the project is due.

- At first team progress check-in, about 33% of the work is expected to be completed satisfactorily
- At second team progress check-in, about 66% of the work is expected to be completed satisfactorily
- Final submission will expect 100% completion

Each team will have a rubric uploaded to [https://github.com/turingschool/ruby-submissions](https://github.com/turingschool/ruby-submissions)


View the [Little Shop Rubric](LittleShopRubric.pdf)

## Explicit

GET    /                                                      welcome#index
GET    /login(.:format)                                       sessions#new
GET    /logout(.:format)                                      sessions#destroy
GET    /register(.:format)                                    users#new
GET    /profile(.:format)                                     users#show
GET    /profile/edit(.:format)                                users#edit
GET    /profile/orders(.:format)                              profile/orders#index
GET    /profile/orders/:id(.:format)                          profile/orders#show
GET    /cart(.:format)                                        cart#show
GET    /items(.:format)                                       items#index
GET    /items/:id(.:format)                                   items#show
GET    /dashboard(.:format)                                   merchants#show
GET    /dashboard/items(.:format)                             merchants/items#index
GET    /dashboard/items/new(.:format)                         merchants/items#new
GET    /dashboard/items/:id/edit(.:format)                    merchants/items#edit
GET    /dashboard/items/:id(.:format)                         merchants/items#show
GET    /dashboard/orders/:id(.:format)                        merchants/orders#show
GET    /merchants(.:format)                                   merchants#index
GET    /merchants/:id(.:format)                               merchants#show
GET    /admin/users/:user_id/orders(.:format)                 admin/orders#index
GET    /admin/users/:user_id/orders/:id(.:format)             admin/orders#show
GET    /admin/users(.:format)                                 admin/users#index
GET    /admin/users/:id/edit(.:format)                        admin/users#edit
GET    /admin/users/:id(.:format)                             admin/users#show
GET    /admin/merchants/:merchant_id/orders/:id(.:format)     admin/orders#merchant_show
GET    /admin/merchants/:merchant_id/items(.:format)          admin/items#index
GET    /admin/merchants/:merchant_id/items/new(.:format)      admin/items#new
GET    /admin/merchants/:merchant_id/items/:id/edit(.:format) admin/items#edit
GET    /admin/merchants/:id(.:format)                         admin/merchants#show
GET    /admin/dashboard(.:format)                             admin/dashboard#index

## Implicit

A request that will:
    - Create a user when the registration form is submitted
    - Update a user when the user edit form is submitted
    - Create a session when a user logs in
    - Create an order when a user 'checks out' their cart
    - Destroy an order from a user's profile page
    - Add an item to a cart
    - Add one more of an item that is already in a cart
    - Destroy a cart
    - Remove one of an item that is already in a cart
    - Remove all of an item that is already in a cart
    - Create an item when the merchant's new item form is submitted
    - Update an item when the merchant's edit item form is submitted
    - Destroy an item from the merchant's item dashboard
    - Enable an item from the merchant's item dashboard
    - Disable an item from the merchant's item dashboard
    - Create an item for a merchant, as an admin
    - Update an item for a merchant, as an admin
    - Enable a user, as an admin
    - Disable a user, as an admin
    - Upgrade a user, as an admin
    - Downgrade a merchant, as an admin
    - Enable a merchant, as an admin
    - Disable a merchant, as an admin
    - Update an order_item's status
