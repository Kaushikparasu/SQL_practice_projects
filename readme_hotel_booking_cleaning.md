# Hotel Bookings Data Cleaning Project

This project focuses on cleaning and transforming the **Hotel Bookings dataset** using **MySQL** to make it analysis-ready. The process includes handling missing values, correcting data types, creating derived columns, and normalizing categorical fields into dimension tables.

---

## 🔧 Tools Used
- MySQL Workbench
- MySQL 8.0

---

## 🧹 Data Cleaning Steps

1. **Table Creation & Data Import**
   - Created a table named `hotel_bookings`
   - Loaded data using `LOAD DATA INFILE`
   - Replaced string placeholders (e.g., `'NA'`, `'BB'`) with `NULL`

2. **Missing Value Treatment**
   - Replaced nulls in `children`, `agent`, `country` with default values
   - Dropped unnecessary column: `company`

3. **Outlier Handling**
   - Removed unrealistic entries:
     - `adr > 1000` or `adr < 0`
     - `babies = 10` or `children = 10`

4. **Date Transformation**
   - Converted `reservation_status_date` to DATE format
   - Combined `arrival_date_year`, `month`, `day_of_month` into a single `arrival_date` field

5. **Normalization**
   Created separate dimension tables and mapped foreign keys:
   - `hotel` → `hotel_id`
   - `meal` → `meal_id`
   - `market_segment` → `market_id`
   - `country` → `country_id`
   - `customer_type` → `customer_type_id`
   - `distribution_channel` → `distribution_channel_id`

---

## 📁 Final Output
The cleaned `hotel_bookings` table is:
- Free of nulls in key fields
- Fully normalized
- Has clean date columns
- Ready for analysis or dashboarding

---

## 📌 Next Steps (Optional)
- Create a Power BI dashboard
- Run analytical queries / KPIs
- Upload project to GitHub as part of portfolio

---

## 📬 Author
**Kaushik**  
Project completed as part of data analyst learning journey

---

Feel free to clone, reuse, or extend the script for other datasets 🚀

