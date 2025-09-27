insert into categories(name, images) values ('Phone', 'uploads/phone.png');
insert into categories(name, images) values ('Laptop', 'uploads/laptop.png');

insert into users(fullname, email, password, phone) 
values ('User One', 'user1@example.com', '123456', '0900000001'),
       ('Admin', 'admin@example.com', 'admin123', '0900000002');

insert into products(title, quantity, description, price, image, user_id, category_id)
values ('iPhone 14', 10, 'Like new', 17000000, 'uploads/iphone14.jpg', 1, 1),
       ('Galaxy S23', 5, 'New', 15000000, 'uploads/galaxy-s23.jpg', 1, 1),
       ('ThinkPad X1', 3, '2024', 38000000, 'uploads/thinkpad-x1.jpg', 2, 2);

insert into user_categories(user_id, category_id) values (1,1),(1,2),(2,2);
