# ------------- Simple Queries -------------

#1 - Display the restaurants that have Italian cuisine
GET /restaurants/_search 
{
  "query": {
    "bool": {
      "must": {
        "match": {
          "cuisine": "italian"
        }
      }
    }
  }
}

#2 - Display the Italian restaurants located in Queens borough
GET /restaurants/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "cuisine": "italian"
          }
        },
        {
          "match": {
            "borough": "queens"
          }
        }
      ]
    }
  }
}

#3 - Display all restaurants located in an "Avenue"
GET /restaurants/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "wildcard": {
            "address.street": "*avenue*"
          }
        }
      ]
    }
  }
}

#4 - Display all restaurants that had at least one score greater than 50
GET /restaurants/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "grades.score": {
              "gt": 50
            }
          }
        }
      ]
    }
  }
}

#5 - Display restaurants that have a least a score greater than 50 and that doesn't have American or Italian cuisine
GET /restaurants/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "grades.score": {
              "gt": 50
            }
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "cuisine": "american"
          }
        },
        {
          "match": {
            "cuisine": "italian"
          }
        }
      ]
    }
  }
}

#6 - Display all Japanese restaurants that have been graded in december of 2014
GET /restaurants/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "cuisine": "japanese"
          }
        }
      ],
      "filter":
      {
        "range": {
          "grades.date": {
            "gt": "2014-12-01",
            "lt": "2014-12-31"
          }
        }
      }

    }
  }
}

# ------------- Complex Queries -------------

#1 - Display the number of restaurants per cuisine
GET /restaurants/_search
{
  "size": 0,
  "aggs": {
    "restaurant_per_cuisine": {
      "terms": {
        "field": "cuisine.keyword"
      }
    }
  }
}

#2 - Display the number of distinct cuisine in Manhattan
GET /restaurants/_search
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "borough": "Manhattan"
          }
        }
      ]
    }
  },
  "aggs": {
    "distinct_cuisine": {
      "cardinality": {
        "field": "cuisine.keyword"
      }
    }
  }
}

# ------------- Hard Queries -------------

#1 - Display the 20 better-scored cuisine in descending order
GET /restaurants/_search
{
  "size": 0,
  "aggs": {
    "avg_score_per_cuisine": {
      "terms": {
        "field": "cuisine.keyword",
        "size": 20,
        "order": {
          "avg_score": "desc"
        }
      },
      "aggs": {
        "avg_score": {
          "avg": {
            "field": "grades.score"
          }
        }
      }
    }
  }
}

#2 - Display the most significant terms in the French restaurant's name
PUT restaurants/_mapping
{
  "properties": {
    "name": { 
      "type": "text",
      "fielddata": true
    }
  }
}

GET /restaurants/_search
{
  "size": 0,
  "query": {
    "match": {
      "cuisine": "french"
    }
  },
  "aggs": {
    "name_terms": {
      "terms": {
        "field": "name",
        "size": 10
      }
    }
  }
}