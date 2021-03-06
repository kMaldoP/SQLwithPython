import psycopg2

# Connect to your postgres DB
conn = psycopg2.connect(
    """
    dbname=week3 user=postgres host=localhost port=5432
    """
)
conn.set_session(autocommit=True)


# Open a cursor to perform database operations
cur = conn.cursor()

cur.execute(
    """
    DROP TABLE IF EXISTS veggies
    """
)

cur.execute(
    """
    CREATE TABLE veggies(
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        color TEXT NOT NULL
    )
    """
)

cur.execute(
    """
    INSERT INTO veggies VALUES 
    (1, 'carrot', 'orange'),
    (2, 'onion', 'yellow'),
    (3, 'onion', 'red'),
    (4, 'zucchini', 'green'),
    (5, 'squash', 'yellow'),
    (6, 'pepper', 'red'),
    (7, 'pepper', 'green'),
    (8, 'pepper', 'orange'),
    (9, 'pepper', 'yellow'),
    (10, 'onion', 'white'),
    (11, 'green bean', 'green'),
    (12, 'jicama', 'tan'),
    (13, 'tomatillo', 'green'),
    (14, 'radicchio', 'purple'),
    (15, 'potato', 'brown')
    """
)

# Execute a query
cur.execute(
    """
    SELECT color, name FROM veggies
    """
)

veggie_records = cur.fetchall()
for v in veggie_records:
    print(v[0], v[1])

# Retrieve query results
records = cur.fetchall()

print("INSERTED VEGGIES:", records, '\n')