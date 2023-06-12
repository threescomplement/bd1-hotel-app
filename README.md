# Hotel App
Projekt na przedmiot Bazy Danych 1 (2023, semestr letni)

* [Opis i analiza rozwiązania](./Sprawozdanie/Sprawozdanie%20Projekt%20BD1%20-%20Hotel.pdf)
* [Model ER](./Sprawozdanie/ER%20Model.png)
* [Model relacyjny](./Sprawozdanie/Relational%20model.png)
* [Skrypty do bazy danych](./database/scripts)
  * [Założenie schematu](./database/scripts/schema.ddl)
  * [Ładowanie danych](./database/scripts/add-data.sql)
  * [Testowe zapytania](./database/scripts/db_examples.sql)
  * [Definicje funkcji](./database/scripts/payments.sql)
  * [Definicje procedur](./database/scripts/procedures.sql)
  * [Definicje wyzwalaczy](./database/scripts/triggers.sql)
  * [Przykłady wykorzystania funkcji](./database/scripts/payments_examples.sql)
  * [Przykłady wykorzystania procedur](./database/scripts/procedures_examples.sql)
  * [Przykłady wykorzystania wyzwalaczy](./database/scripts/triggers_examples.sql)
* [Kod źródłowy aplikacji w Javie](./src/main/java)

## Uruchomienie aplikacji
Aplikacja wykorzystuje Gradle do budowania, aby uruchomić należy wykonać
```bash
./gradlew run
```

Główna klasa to [HotelApp](./src/main/java/org/example/HotelApp.java)

## Autorzy
* Maksym Bieńkowski
* Mikołaj Garbowski
* Michał Łuszczek
