# Animal_Shelter_Database
A fully normalised Microsoft SQL Server database designed to manage the day-to-day operations of an animal shelter — covering animals, kennels, adoptions, fostering, medical care, staff, resources, and public visits.

---

## Project Files

| File | Description |
|---|---|
| `CreateAnimalShelter_5.sql` | Full database creation script — tables, constraints, indexes, seed data, triggers, views, stored procedures, logins, and roles |
| `Database_Backup.sql` | Script to take a full backup of `AnimalShelterDB` to disk |
| `DBD_Project.docx` | Design document — ER diagram, normalization steps, database object descriptions, security model, and environment specification |
| `Pawprint_animal_shelter_database.pptx` | Presentation summarising the project |

---

## Database Overview

**Database name:** `AnimalShelterDB`

Hosted on **Azure SQL Database** (DTU Model, Standard S1 — 20 DTUs, 250 GB), with **SQL Server Express 2022** used locally to access the server.

---

## Tables

The schema was normalised through five steps (1NF → 3NF + further decomposition) and contains the following tables:

| Table | Description |
|---|---|
| `Animal` | Core animal records — name, type, breed, colour, gender, birthdate, admission date, weight, kennel, adoption status, sterilisation, notes |
| `Animal_Type` | Lookup table for animal types (e.g. dog, cat) |
| `Animal_Breed` | Lookup table for breeds, with approximate size |
| `Color` | Lookup table for colours and patterns |
| `Kennel` | Kennel numbers and sizes |
| `Medication` | Medication catalogue with name and description |
| `Animal_Medication` | Junction table linking animals to medications, with dose, time, and prescribing vet |
| `Veterinarian` | Vet contact and practice details |
| `Vaccination` | Vaccination records per animal and vet |
| `Person` | Contact details for adopters and foster caregivers |
| `Foster` | Foster agreements — person, animal, start and end dates |
| `Adoption` | Adoption records — person, animal, and date |
| `Visitation` | Scheduled visits by potential adopters |
| `Staff` | Staff records — contact details, role, employment dates |
| `Staff_Shift` | Shift assignments for staff members |
| `Resource` | Shelter resource inventory — food, medical supplies, maintenance items |
| `Resource_Type` | Lookup table for resource categories |
| `Audit` | Audit log table — records all INSERT, UPDATE, and DELETE operations across the database |

### Key Constraints

- `Animal.Admission_Date` defaults to the current date (`GetDate()`)
- `Animal.Birth_Date` must be on or before `Admission_Date`
- `Veterinarian.Email`, `Person.Email`, `Staff.Email`, and `Staff.Phone` / `Person.Phone` are all unique
- Staff employment dates are validated for logical order

---

## Indexes

Non-clustered indexes are defined on frequently queried foreign key columns to improve join and lookup performance.

---

## Triggers

Every table has an AFTER trigger (`trAdoption`, `trAnimal`, `trAnimalBreed`, `trAnimalType`, `trColor`, `trFoster`, `trKennel`, `trMedication`, `trPerson`, `trResource`, `trResourceType`, `trStaff`, `trStaffShift`, `trVaccination`, `trVeterinarian`, `trVisitation`, `trAnimalMedication`) that writes a record to the `Audit` table on INSERT, UPDATE, and DELETE — capturing the user, timestamp, and operation type.

---

## Views

| View | Description |
|---|---|
| `vAudit` | Human-readable audit log |
| `vAnimalStats` | Summary statistics on animals (counts by type, adoption status, etc.) |
| `vAnimalMedication` | Animals joined with their current medications and prescribing vet |
| `vAnimal` | Full animal detail including type, breed, colour, and kennel |
| `vCurrentlyAdopted` | Animals with active adoptions and adopter details |
| `vCurrentFoster` | Animals currently in foster care with foster details |
| `vVisits` | All visitation records with animal and visitor info |
| `vUpcomingVisits` | Visits scheduled for future dates |
| `vVeterinarian` | Full vet contact information |
| `vVaccination` | Vaccination records with animal and vet details |
| `vStaffShift` | Staff shift schedule |
| `vResource` | Resource inventory with type details |

---

## Stored Procedures

| Procedure | Description |
|---|---|
| `AlterBreed` | Update the name or size of an animal breed |
| `AlterType` | Update an animal type name |
| `AlterColor` | Update a colour/pattern name |
| `UpdateAnimal` | Update core details on an animal record |

---

## Security

Three roles are defined with different permission levels:

| Role | Access Level |
|---|---|
| `db_owner` / `FullAdmin` | Full access to all objects |
| `high_staff` | Full CRUD on most tables; SELECT-only on salary-sensitive staff columns; no DELETE on resources |
| `staff_users` | Read-only access to most data; limited write access to lookup tables; no access to sensitive staff/person columns beyond name and contact |

Twelve SQL logins (`User1`–`User10`, `DBadmin`, `Data_Admin`) are created and assigned to the appropriate role.

---

## Recommended Schema Organisation (Azure)

| Schema | Tables |
|---|---|
| `Animal` | Animal, Animal_Type, Animal_Breed, Color, Kennel, Adoption, Foster, Visitation, Vaccination, Animal_Medication, Medication |
| `Vet` | Veterinarian |
| `Resource` | Resource, Resource_Type |
| `Staff` | Staff, Staff_Shift |
| `People` | Person |
| `Audit` | Audit |

---

## Backup

The `Database_Backup.sql` script creates a full backup of `AnimalShelterDB` to `C:\Databasebackups\AnimalShelterBD.bak`. Backups should be scheduled between **02:00 and 04:00 AM** to avoid impacting performance.

---

## Performance Targets

- Maximum query response time: **2 seconds**
- Concurrent users supported: **up to 15**
- Transactions per minute: **up to 50**
- Maximum records: **100 000** (heaviest tables: Animal, Adoption, Foster, Visitation, Vaccination, Resource, Person, Staff_Shift, Animal_Medication, Medication)

---

## Setup

1. Install **SQL Server Express 2022** from [microsoft.com](https://www.microsoft.com/en-za/sql-server/sql-server-downloads#windows) (free).
2. Open `CreateAnimalShelter_5.sql` in SQL Server Management Studio (SSMS).
3. Update the file paths in the `CREATE DATABASE` statement if your SQL Server data directory differs from the default.
4. Execute the script — it will create the database, all objects, seed data, logins, and roles in order.
5. To back up the database, run `Database_Backup.sql` and update the target path if needed.
