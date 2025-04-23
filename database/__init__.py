import psycopg2
from faker import Faker
import uuid
import random
from datetime import datetime
import json
import os
import bcrypt

fake = Faker()

def insert_users(cursor, n=10):
    users = []
    for _ in range(n):
        raw_password = "123456"
        hashed_password = bcrypt.hashpw(raw_password.encode('utf-8'), bcrypt.gensalt()).decode()

        users.append((
            str(uuid.uuid4()),
            fake.email(),
            hashed_password,
            random.choice(['user', 'admin']),
            datetime.now()
        ))

    cursor.executemany("""
        INSERT INTO users (user_id, email, hashed_password, role, created_at)
        VALUES (%s, %s, %s, %s, %s)
    """, users)

    print("\nDanh sách user & mật khẩu:")
    for u in users:
        print(f"Email: {u[1]:<30} | Password: (đã hash)")

    return [u[0] for u in users]

def run_sql_file(cursor, path):
    with open(path, 'r', encoding='utf-8') as file:
        cursor.execute(file.read())

def main():
    conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user="postgres",
        password="123456"
    )
    conn.autocommit = True
    cursor = conn.cursor()

    cursor.execute("SELECT 1 FROM pg_database WHERE datname = 'fire_detection'")
    exists = cursor.fetchone()
    if not exists:
        cursor.execute("CREATE DATABASE fire_detection")
        print("Đã tạo database 'fire_detection'")
    else:
        print("Database 'fire_detection' đã tồn tại")

    cursor.close()
    conn.close()

    conn = psycopg2.connect(
        host="localhost",
        database="fire_detection",
        user="postgres",
        password="123456"
    )
    cursor = conn.cursor()

    # Chạy file SQL tạo DB
    run_sql_file(cursor, "init_db.sql")

    # Sinh dữ liệu giả
    user_ids = insert_users(cursor, 10)

    conn.commit()
    cursor.close()
    conn.close()
    print("Đã khởi tạo và sinh dữ liệu xong!")

if __name__ == "__main__":
    main()
