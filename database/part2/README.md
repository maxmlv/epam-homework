# Part 2 of the Database homework

1. Make backup of your database.

[computer_constructor_backup.sql](computer_constructor_backup.sql)
```
maxmlv@maxmlv:~/epam$ mysqldump -u root -p computer_constructor > ~/epam/database/part2/computer_constructor_backup.sql
Enter password:
```

2. Delete the table and/or part of the data in the table.

Changes table table __gpu__ in database
```
mysql> select * from gpu;
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

mysql> update gpu set model='hhhhhhhhhhhhhh' where id=3;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from gpu;
+----+--------+-------------------+---------+
| id | brand  | model             | price   |
+----+--------+-------------------+---------+
|  1 | Nvidia | GTX 1070 Ti       |  400.00 |
|  2 | Nvidia | RTX 3070 Ti       |  599.00 |
|  3 | Nvidia | hhhhhhhhhhhhhh    | 1999.00 |
|  4 | AMD    | Radeon RX 6500 XT |  200.00 |
|  5 | AMD    | Radeon RX 6900 XT |  999.00 |
+----+--------+-------------------+---------+
5 rows in set (0.00 sec)
```

12. Restore your database.

Restoring the database from .sql backup file
```
maxmlv@maxmlv:~/epam$ mysql -u root -p computer_constructor < ~/epam/database/part2/computer_constructor_backup.sql

mysql> select * from gpu;
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
```

3. Transfer your local database to RDS AWS.

Compress backup file
```
tar -zcvf backup.tar.gz computer_constructor_backup.sql
```
Copy compressed backup to __EC2__ instace in same __VPC__ as __RDS__ mysql database
```
scp -r -i ~/.ssh/EPAM.pem ~/epam/database/part2/backup.tar.gz ubuntu@3.120.111.227:~/backup.tar.gz

backup.tar.gz                                                                         100% 1377    25.1KB/s   00:00
```

14. Connect to your database.

Extract backup arcive and connect to __RDS__ database from __EC2__ instance

```
mysql -h computer-constructor.cefgdboyaarn.eu-central-1.rds.amazonaws.com -P 3306 -u admin -p
```

Import database from .sql file

```
mysql> source computer_constructor_backup.sql;

mysql> show tables;
+--------------------------------+
| Tables_in_computer_constructor |
+--------------------------------+
| cpu                            |
| customers                      |
| gpu                            |
| ram                            |
+--------------------------------+
4 rows in set (0.00 sec)
```

15. Execute SELECT operator similar step 6.

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

mysql> SELECT COUNT(id) AS total_models, brand FROM cpu GROUP BY brand;
+--------------+-------+
| total_models | brand |
+--------------+-------+
|            3 | AMD   |
|            3 | Intel |
+--------------+-------+
2 rows in set (0.00 sec)

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
6 rows in set (0.01 sec)
```

16. Create the dump of your database.

```
ubuntu@ip-10-0-14-32:~$ mysqldump -h computer-constructor.cefgdboyaarn.eu-central-1.rds.amazonaws.com -P 3306 -u admin -p > rds_computer_constructor.sql

ubuntu@ip-10-0-14-32:~$ ls
backup.tar.gz  computer_constructor_backup.sql  rds_computer_constructor.sql
```