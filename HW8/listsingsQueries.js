// TODO: write MongoDB queries below
// 1. show exactly two documents from the listings collection in any order
db.listings.find().limit(2)

// 2. show exactly 10 documents in any order… but print in easier to read format and noting the host names for further use
db.listings.find().limit(10).pretty()

// 3. choose two host names… and show all of the listings hosted by either of the two hosts
db.listings.find({$or: [{"host_name":"Raymond"}, {"host_name":"Jan"}]}, {"name":1, "price":1, "neighbourhood":1, "host_name":1})

// 4. find all of the unique host_name
db.listings.distinct("host_name")

// 5. find all of the places that have more than 2 beds in city
db.listings.find({$and: [{"beds": {$gt: "2"}}, {"neighbourhood_group_cleansed": "Brooklyn"}]}, {"name":1, "beds":1, "city":1, "review_scores_rating":1, "price":1}).sort({"review_scores_rating": -1})

// 6. show the number of listings per host
db.listings.aggregate([{$group: {_id: "$host_id", count: {$count:{}}}}]).sort({count: -1})

// 7. in city (again, use neighbourhood_group_cleansed), Manhattan, 
// find the average review_scores_rating per neighbourhood, 
// and only show the ones above 4.5 if the scale if the scores is 0-5 or 95 if the scale of scores is 0-100… sorted in descending order of rating
db.listings.aggregate([
    {$match: {"neighbourhood_group_cleansed": "Manhattan"}}, 
    {$group:
        {_id: "$neighbourhood_cleansed", avg_score: 
        {$avg: {$toDouble: "$review_scores_rating"}}}}, 
    {$match: {"avg_score": {$gt: 4.5}}}]).sort({"avg_score": -1})