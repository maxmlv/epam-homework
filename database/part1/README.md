# Part 1 of the Database task

1. Download MySQL server for your OS on VM.
2. Install MySQL server on VM.

``` 
maxmlv@maxmlv:~$ mysql --version
mysql  Ver 8.0.31-0ubuntu0.22.04.1 for Linux on x86_64 ((Ubuntu))
```

3. Select a subject area and describe the database schema, (minimum 3 tables)
4. Create a database on the server through the console.

```
mysql> CREATE DATABASE computer_constructor;
Query OK, 1 row affected (0.02 sec)

mysql> USE computer_constructor;
Database changed
```

Example of creating table:
```
mysql> CREATE TABLE cpu ( id INTEGER NOT NULL auto_increment PRIMARY KEY, brand VARCHAR(20), model VARCHAR(20), price DECIMAL(10,2) );
Query OK, 0 rows affected (0.06 sec)
```

5. Fill in tables.

``` 
mysql> SELECT * FROM cpu;
+----+-------+---------------+--------+
| id | brand | model         | price  |
+----+-------+---------------+--------+
|  1 | AMD   | Ryzen 5 5600  | 199.00 |
|  2 | AMD   | Ryzen 7 5800X | 300.00 |
|  3 | AMD   | Ryzen 9 7950X | 699.00 |
|  4 | Intel | i5 9600K      | 262.00 |
|  5 | Intel | i7 12700K     | 419.00 |
|  6 | Intel | i9 12900KS    | 739.00 |
+----+-------+---------------+--------+
6 rows in set (0.00 sec)

mysql> SELECT * FROM gpu;
+----+--------+-------------------+---------+
| id | brand  | model             | price   |
+----+--------+-------------------+---------+
|  1 | Nvidia | GTX 1070 Ti       |  400.00 |
|  2 | Nvidia | RTX 3070 Ti       |  599.00 |
|  3 | Nvidia | RTX 3090 Ti       | 1999.00 |
|  4 | AMD    | Radeon RX 6500 XT |  200.00 |
|  5 | AMD    | Radeon RX 6900 XT |  999.00 |
+----+--------+-------------------+---------+
5 rows in set (0.00 sec)

mysql> SELECT * FROM ram;
+----+----------+---------------------+--------+
| id | brand    | model               | price  |
+----+----------+---------------------+--------+
|  1 | Corsair  | Vengeance LED 2x8GB | 149.99 |
|  2 | Kingston | HyperX Fury 2x8GB   |  80.00 |
|  3 | Adata    | XPG SPECTRIX 2x8GB  |  75.97 |
+----+----------+---------------------+--------+
3 rows in set (0.00 sec)
```

6. Construct and execute SELECT operator with WHERE, GROUP BY and ORDER BY.

```
mysql> SELECT * FROM gpu WHERE price > 400;
+----+--------+-------------------+---------+
| id | brand  | model             | price   |
+----+--------+-------------------+---------+
|  2 | Nvidia | RTX 3070 Ti       |  599.00 |
|  3 | Nvidia | RTX 3090 Ti       | 1999.00 |
|  5 | AMD    | Radeon RX 6900 XT |  999.00 |
+----+--------+-------------------+---------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM cpu ORDER BY price DESC;
+----+-------+---------------+--------+
| id | brand | model         | price  |
+----+-------+---------------+--------+
|  6 | Intel | i9 12900KS    | 739.00 |
|  3 | AMD   | Ryzen 9 7950X | 699.00 |
|  5 | Intel | i7 12700K     | 419.00 |
|  2 | AMD   | Ryzen 7 5800X | 300.00 |
|  4 | Intel | i5 9600K      | 262.00 |
|  1 | AMD   | Ryzen 5 5600  | 199.00 |
+----+-------+---------------+--------+
6 rows in set (0.00 sec)

mysql> SELECT COUNT(id) AS total_models, brand FROM gpu GROUP BY brand;
+--------------+--------+
| total_models | brand  |
+--------------+--------+
|            3 | Nvidia |
|            2 | AMD    |
+--------------+--------+
2 rows in set (0.00 sec)
```

7. Execute other different SQL queries DDL, DML, DCL.

### DDL

```
mysql> CREATE DATABASE ddl_practice;
Query OK, 1 row affected (0.05 sec)

mysql> USE ddl_practice;
Database changed
--------------------------------------------

mysql> CREATE TABLE books ( book_id INTEGER NOT NULL auto_increment PRIMARY KEY, name VARCHAR(20), author VARCHAR(20) );
Query OK, 0 rows affected (0.10 sec)
--------------------------------------------

mysql> ALTER TABLE books ADD price DECIMAL(10,2);
Query OK, 0 rows affected (0.05 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> INSERT INTO books (name, author, price) VALUES('Hello world', 'Max Malieiev', 10.99);
Query OK, 1 row affected (0.01 sec)

mysql> SELECT * FROM books;
+---------+-------------+--------------+-------+
| book_id | name        | author       | price |
+---------+-------------+--------------+-------+
|       1 | Hello world | Max Malieiev | 10.99 |
+---------+-------------+--------------+-------+
1 row in set (0.00 sec)
--------------------------------------------

mysql> TRUNCATE TABLE books;
Query OK, 0 rows affected (0.05 sec)

mysql> SELECT * FROM books;
Empty set (0.00 sec)
--------------------------------------------

mysql> RENAME TABLE books TO articles;
Query OK, 0 rows affected (0.03 sec)
--------------------------------------------

mysql> DROP TABLE articles;
Query OK, 0 rows affected (0.02 sec)

mysql> DROP DATABASE ddl_practice;
Query OK, 0 rows affected (0.03 sec)
--------------------------------------------
```
### DML

```
mysql> INSERT INTO books ( name, author, price ) VALUES ('Kafka on the shore', 'Haruki Murakami', 29.99);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO books ( name, author, price ) VALUES ('1984', 'George Orwell', 15.50);
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO books ( name, author, price ) VALUES ('Sun and steel', 'Yukio Mishima', 25.75);
Query OK, 1 row affected (0.02 sec)

mysql> SELECT * FROM books;
+---------+--------------------+-----------------+-------+
| book_id | name               | author          | price |
+---------+--------------------+-----------------+-------+
|       1 | Kafka on the shore | Haruki Murakami | 29.99 |
|       2 | 1984               | George Orwell   | 15.50 |
|       3 | Sun and steel      | Yukio Mishima   | 25.75 |
+---------+--------------------+-----------------+-------+
3 rows in set (0.00 sec)

mysql> UPDATE books SET price=23.40 WHERE book_id=2;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM books;
+---------+--------------------+-----------------+-------+
| book_id | name               | author          | price |
+---------+--------------------+-----------------+-------+
|       1 | Kafka on the shore | Haruki Murakami | 29.99 |
|       2 | 1984               | George Orwell   | 23.40 |
|       3 | Sun and steel      | Yukio Mishima   | 25.75 |
+---------+--------------------+-----------------+-------+
3 rows in set (0.00 sec)

mysql> DELETE FROM books WHERE book_id=2;
Query OK, 1 row affected (0.01 sec)

mysql> SELECT * FROM books;
+---------+--------------------+-----------------+-------+
| book_id | name               | author          | price |
+---------+--------------------+-----------------+-------+
|       1 | Kafka on the shore | Haruki Murakami | 29.99 |
|       3 | Sun and steel      | Yukio Mishima   | 25.75 |
+---------+--------------------+-----------------+-------+
2 rows in set (0.00 sec)
```

### DCL

```
### root ###

mysql> CREATE USER 'dcl_practice'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT ALL ON `dcl_practice`.* TO 'dcl_practice'@'localhost';
Query OK, 0 rows affected (0.01 sec)

### dcl_practice ###

mysql> SELECT * FROM secrets;
+-----------+
| secret    |
+-----------+
| shhhhhhhh |
+-----------+
1 row in set (0.00 sec)

### root ###

mysql> REVOKE SELECT ON `dcl_practice`.* FROM 'dcl_practice'@'localhost';
Query OK, 0 rows affected (0.02 sec)

### dcl_practice ###

mysql> SELECT * FROM secrets;
ERROR 1142 (42000): SELECT command denied to user 'dcl_practice'@'localhost' for table 'secrets'
```

9. Make a selection from the main table DB MySQL.

```
mysql> SELECT * FROM db;
+-----------+--------------------+---------------+-------------+-------------+-------------+-------------+-------------+-----------+------------+-----------------+------------+------------+-----------------------+------------------+------------------+----------------+---------------------+--------------------+--------------+------------+--------------+
| Host      | Db                 | User          | Select_priv | Insert_priv | Update_priv | Delete_priv | Create_priv | Drop_priv | Grant_priv | References_priv | Index_priv | Alter_priv | Create_tmp_table_priv | Lock_tables_priv | Create_view_priv | Show_view_priv | Create_routine_priv | Alter_routine_priv | Execute_priv | Event_priv | Trigger_priv |
+-----------+--------------------+---------------+-------------+-------------+-------------+-------------+-------------+-----------+------------+-----------------+------------+------------+-----------------------+------------------+------------------+----------------+---------------------+--------------------+--------------+------------+--------------+
| localhost | dcl_practice       | dcl_practice  | N           | Y           | Y           | Y           | Y           | Y         | N          | Y               | Y          | Y          | Y                     | Y                | Y                | Y              | Y                   | Y                  | Y            | Y          | Y            |
| localhost | performance_schema | mysql.session | Y           | N           | N           | N           | N           | N         | N          | N               | N          | N          | N                     | N                | N                | N              | N                   | N                  | N            | N          | N            |
| localhost | sys                | mysql.sys     | N           | N           | N           | N           | N           | N         | N          | N               | N          | N          | N                     | N                | N                | N              | N                   | N                  | N            | N          | Y            |
+-----------+--------------------+---------------+-------------+-------------+-------------+-------------+-------------+-----------+------------+-----------------+------------+------------+-----------------------+------------------+------------------+----------------+---------------------+--------------------+--------------+------------+--------------+
3 rows in set (0.00 sec)
```