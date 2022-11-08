# Part 3 of the Database homework

## Working with MongoDB

17. Create a database. Use the use command to connect to a new database (If it 
doesn't exist, Mongo will create it when you write to it).

```
test> use strore
switched to db strore
```

18. Create a collection. Use db.createCollection to create a collection. I'll leave the subject up to you. Run show dbs and show collections to view your database and collections.

```
strore> db.createCollection("products")
{ ok: 1 }
```

19. Create some documents. Insert a couple of documents into your collection. I'll leave the subject matter up to you, perhaps cars or hats.

```
strore> db.products.insertOne({"name": "Apples", "quantity": "130 kg", "price": 13.50, "tags": ["fruits", "organic"], "arrived at": Date()})
{
  acknowledged: true,
  insertedId: ObjectId("636a5a23979dee9093032fd6")
}
strore> db.products.insertOne({"name": "Hazelnuts", "quantity": "25 kg", "price": 30, "tags": ["nut", "snack"], "arrived at": Date()})
{
  acknowledged: true,
  insertedId: ObjectId("636a5a7f979dee9093032fd7")
}
```

20. Use find() to list documents out.

```
strore> db.products.find()
[
  {
    _id: ObjectId("636a5a23979dee9093032fd6"),
    name: 'Apples',
    quantity: '130 kg',
    price: 13.5,
    tags: [ 'fruits', 'organic' ],
    'arrived at': 'Tue Nov 08 2022 13:31:15 GMT+0000 (Coordinated Universal Time)'
  },
  {
    _id: ObjectId("636a5a7f979dee9093032fd7"),
    name: 'Hazelnuts',
    quantity: '25 kg',
    price: 30,
    tags: [ 'nut', 'snack' ],
    'arrived at': 'Tue Nov 08 2022 13:32:47 GMT+0000 (Coordinated Universal Time)'
  }
]
```